-- Teste virtual sem persistência de dados; executado com sucesso.
begin;
insert into auth.users(id,email) values
('95000000-0000-4000-8000-000000000001','virtual-cliente@example.invalid'),('95000000-0000-4000-8000-000000000011','virtual-a@example.invalid'),
('95000000-0000-4000-8000-000000000012','virtual-b@example.invalid'),('95000000-0000-4000-8000-000000000099','virtual-terceiro@example.invalid');
insert into public.providers(id,owner_id,display_name,city,state_code,status,is_active,approved_at)
values
('96000000-0000-4000-8000-000000000011','95000000-0000-4000-8000-000000000011','Borracharia Fictícia A','Belo Horizonte','MG','approved',true,now()),
('96000000-0000-4000-8000-000000000012','95000000-0000-4000-8000-000000000012','Borracharia Fictícia B','Belo Horizonte','MG','approved',true,now());
insert into public.provider_services(provider_id,category_id,is_active)
select p.id,c.id,true from public.providers p cross join public.service_categories c
where p.id in ('96000000-0000-4000-8000-000000000011','96000000-0000-4000-8000-000000000012') and c.code='borracharia_delivery';
set local role authenticated;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000011',true);
select public.bj_set_presence(true);
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000012',true);
select public.bj_set_presence(true);
reset role;
select set_config('request.jwt.claim.sub','',true);
set local role anon;
do $$ begin
 if (select count(*) from public.bj_online_providers())!=2 then raise exception 'Visitante nao ve 2 online'; end if;
end $$;
reset role;set local role authenticated;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000001',true);
insert into public.service_requests(id,customer_id,provider_id,category_id,problem_description,status,request_key)
select '97000000-0000-4000-8000-000000000001','95000000-0000-4000-8000-000000000001','96000000-0000-4000-8000-000000000011',c.id,'Pneu furado moto virtual','requested',
'98000000-0000-4000-8000-000000000001'
from public.service_categories c where c.code='borracharia_delivery';
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000011',true);
select public.bj_submit_quote('97000000-0000-4000-8000-000000000001',12000,'Pneu e deslocamento');
do $$ begin
 if (select status from public.service_requests where id='97000000-0000-4000-8000-000000000001')!='quoted' then raise exception 'Nao marcou quoted'; end if;
end $$;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000099',true);
do $$ declare denied boolean:=false;begin
 begin perform public.bj_answer_quote(
  (select id from public.service_quotes where request_id='97000000-0000-4000-8000-000000000001'),true);
 exception when others then denied:=true;end;
 if not denied then raise exception 'Terceiro aceitou proposta';end if;
end $$;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000001',true);
do $$ declare outcome text; begin
 outcome := public.bj_answer_quote((select id from public.service_quotes where request_id='97000000-0000-4000-8000-000000000001'),false);
 if outcome!='next_provider' then raise exception 'Recusa nao encaminhou: %',outcome;end if;
 if (select provider_id from public.service_requests where id='97000000-0000-4000-8000-000000000001')!='96000000-0000-4000-8000-000000000012'::uuid then raise exception 'Proximo errado';end if;
end $$;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000011',true);
do $$ begin
 if (select count(*) from public.service_requests where id='97000000-0000-4000-8000-000000000001')!=0 then raise exception 'Prestador antigo ve chamado';end if;
 if (select count(*) from public.service_quotes where request_id='97000000-0000-4000-8000-000000000001')!=1 then raise exception 'Prestador antigo nao ve proprio historico';end if;
end $$;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000012',true);
select public.bj_submit_quote('97000000-0000-4000-8000-000000000001',13900,'Nova oferta do segundo prestador');
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000001',true);
do $$ declare outcome text;begin
 outcome :=public.bj_answer_quote(
  (select id from public.service_quotes where request_id='97000000-0000-4000-8000-000000000001' and status='proposed'),true);
 if outcome!='awaiting_payment' then raise exception 'Aceite nao entrou em awaiting_payment';end if;
 if (select status from public.service_requests where id='97000000-0000-4000-8000-000000000001')!='awaiting_payment' then raise exception 'Status pedido errado';end if;
end $$;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000012',true);
select public.bj_set_presence(false);
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000001',true);
insert into public.service_requests(id,customer_id,provider_id,category_id,problem_description,status,request_key)
select '97000000-0000-4000-8000-000000000002','95000000-0000-4000-8000-000000000001','96000000-0000-4000-8000-000000000011',c.id,'Outro pneu furado ficticio','requested',
'98000000-0000-4000-8000-000000000002'
from public.service_categories c where c.code='borracharia_delivery';
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000011',true);
select public.bj_submit_quote('97000000-0000-4000-8000-000000000002',15000,'Orcamento sem alternativa');
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000001',true);
do $$ declare outcome text;begin
 outcome :=public.bj_answer_quote(
 (select id from public.service_quotes where request_id='97000000-0000-4000-8000-000000000002' and status='proposed'),false);
 if outcome!='no_provider' then raise exception 'Sem fornecedor nao reconhecido: %',outcome;end if;
 if (select provider_id from public.service_requests where id='97000000-0000-4000-8000-000000000002') is not null then raise exception 'Pedido sem fornecedor nao liberou provider';end if;
end $$;
select set_config('request.jwt.claim.sub','95000000-0000-4000-8000-000000000011',true);
select public.bj_set_presence(false);
do $$ begin
 if (select count(*) from public.bj_online_providers())!=0 then raise exception 'Desligados continuam online';end if;
end $$;
reset role;
do $$ begin
 if (select count(*) from public.bj_request_attempts where request_id='97000000-0000-4000-8000-000000000001')!=2 then raise exception 'Trilha de tentativas invalida';end if;
 if (select count(*) from public.payment_records)!=0 then raise exception 'Pagamento indevido';end if;
end $$;
rollback;
select 'PASSOU: online, recusa e próximo, aceite sem pagamento, sem fornecedor, privacidade, auditoria; rollback' resultado;