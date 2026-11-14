-- F1 - MIGRACAO PROPOSTA, NAO APLICADA NO PROJETO REMOTO.
-- Revisar em homologacao antes de executar e preservar rollback/backup.
-- Compativel com os pedidos legados: novos campos inicialmente opcionais no banco.
begin;

alter table public.service_requests
  add column if not exists motorcycle_brand text,
  add column if not exists motorcycle_model text,
  add column if not exists motorcycle_year integer,
  add column if not exists service_types text[],
  add column if not exists photo_path text;

alter table public.service_requests
  add constraint f1_vehicle_data_check check (
    (motorcycle_brand is null or char_length(btrim(motorcycle_brand)) between 2 and 70)
    and (motorcycle_model is null or char_length(btrim(motorcycle_model)) between 2 and 90)
    and (motorcycle_year is null or motorcycle_year between 1950 and 2100)
  ),
  add constraint f1_selected_service_types_check check (
    service_types is null or (
      cardinality(service_types) between 1 and 6
      and array_position(service_types, null) is null
      and service_types <@ array[
        'pneu_furado','troca_camara','troca_pneu',
        'calibragem_valvula','reboque_moto','outro'
      ]::text[]
      and not ('reboque_moto' = any(service_types))
    )
  ),
  add constraint f1_photo_path_owned_by_customer check (
    photo_path is null or (
      request_key is not null and
      photo_path = customer_id::text || '/' || request_key::text || '.jpg'
    )
  );

-- Bucket privado; sem links publicos. 5 MB apos reduzir imagem e remover metadados no cliente.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('request-photos', 'request-photos', false, 5242880, array['image/jpeg']::text[])
on conflict (id) do nothing;

-- Somente o autor pode criar arquivos em seu namespace. Sem overwrite.
create policy "f1_request_photo_author_upload" on storage.objects
for insert to authenticated
with check (
  bucket_id = 'request-photos' and
  (storage.foldername(name))[1] = (select auth.uid())::text and
  name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}\.jpg
);

-- Dono ou prestador designado podem ler a foto para orcamento.
-- RLS de service_requests continua limitando a visibilidade do pedido.
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

-- Dono pode limpar uploads nao utilizados antes de criar o pedido.
create policy "f1_request_photo_author_delete" on storage.objects
for delete to authenticated
using (
  bucket_id = 'request-photos' and
  (storage.foldername(name))[1] = (select auth.uid())::text
  and not exists (
    select 1 from public.service_requests r
    where r.photo_path = storage.objects.name
      and r.customer_id = (select auth.uid())
  )
);

commit;

);

-- Dono ou prestador designado podem ler a foto para orcamento.
-- RLS de service_requests continua limitando a visibilidade do pedido.
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

-- Dono pode limpar uploads nao utilizados antes de criar o pedido.
create policy "f1_request_photo_author_delete" on storage.objects
for delete to authenticated
using (
  bucket_id = 'request-photos' and
  (storage.foldername(name))[1] = (select auth.uid())::text
);

commit;
