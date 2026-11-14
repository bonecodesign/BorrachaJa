-- F1 / Salva Motoca! -- MIGRACAO PROPOSTA (NAO APLICAR DIRETAMENTE NA PRODUCAO).
-- Pre-requisitos: Supabase com storage.objects/storage.buckets, usuarios com Auth, backup e testes de RLS.
-- Aplicar em ambiente de homologacao ANTES de implantar o frontend F1. DB antigo nao aceita o novo payload.
-- Nao altera pagamentos, despacho, reboque comercial ou o status de prestadores.
begin;

alter table public.service_requests
  add column motorcycle_brand text,
  add column motorcycle_model text,
  add column motorcycle_year integer,
  add column service_types text[],
  add column photo_path text;

-- F1 e exigida no banco. Ambiente de testes atual nao tem pedidos persistidos.
-- Se houver pedidos legados, NAO executar sem estrategia de migracao e validacao humana.
alter table public.service_requests
  alter column motorcycle_brand set not null,
  alter column motorcycle_model set not null,
  alter column motorcycle_year set not null,
  alter column service_types set not null,
  alter column photo_path set not null;

alter table public.service_requests
  add constraint f1_vehicle_data_check check (
    char_length(btrim(motorcycle_brand)) between 2 and 70
    and char_length(btrim(motorcycle_model)) between 2 and 90
    and motorcycle_year between 1950 and 2100
  ),
  add constraint f1_selected_service_types_check check (
    cardinality(service_types) between 1 and 6
    and array_position(service_types, null) is null
    and service_types <@ array[
      'pneu_furado', 'troca_camara', 'troca_pneu',
      'calibragem_valvula', 'reboque_moto', 'outro'
    ]::text[]
    and not ('reboque_moto' = any(service_types))
  ),
  add constraint f1_photo_path_owned_by_customer check (
    request_key is not null
    and photo_path = customer_id::text || '/' || request_key::text || '.jpg'
  );

-- Acesso a fotos e privado e exige as politicas RLS abaixo.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('request-photos', 'request-photos', false, 5242880, array['image/jpeg']::text[])
on conflict (id) do update
  set public = false,
      file_size_limit = excluded.file_size_limit,
      allowed_mime_types = excluded.allowed_mime_types;

create policy "f1_request_photo_author_upload" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'request-photos'
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}\.jpg$'
  );

-- O autor pode consultar a propria foto.
-- O prestador designado pode consultar apenas a foto do pedido que lhe pertence.
-- Quando o prestador for trocado, o antigo perde autorizacao para gerar novas URLs.
create policy "f1_request_photo_participants_read" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'request-photos' and (
      (storage.foldername(name))[1] = (select auth.uid())::text
      or exists (
        select 1 from public.service_requests r
        join public.providers p on p.id = r.provider_id
        where r.photo_path = storage.objects.name
          and p.owner_id = (select auth.uid())
      )
    )
  );

-- Limpeza somente de arquivos ainda nao vinculados a pedidos.
create policy "f1_request_photo_author_delete" on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'request-photos'
    and (storage.foldername(name))[1] = (select auth.uid())::text
    and not exists (
      select 1 from public.service_requests r
      where r.photo_path = storage.objects.name
        and r.customer_id = (select auth.uid())
    )
  );

-- Garantia no servidor: nao aceitar referencia a foto inexistente no Storage.
-- Security INVOKER: usa a permissao e o JWT do usuario que esta criando o pedido.
create function public.sm_f1_verify_photo_exists()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if not exists (
    select 1 from storage.objects o
    where o.bucket_id = 'request-photos'
      and o.name = new.photo_path
  ) then
    raise exception 'Foto privada ausente ou sem permissao para este pedido'
      using errcode = '23514';
  end if;
  return new;
end;
$$;

create trigger sm_f1_photo_exists_on_insert
  before insert or update of photo_path on public.service_requests
  for each row execute function public.sm_f1_verify_photo_exists();

commit;
