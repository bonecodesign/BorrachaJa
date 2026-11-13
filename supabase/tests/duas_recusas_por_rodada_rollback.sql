-- TESTE REPRODUZÍVEL; identidades fictícias e ROLLBACK.

BEGIN;
INSERT INTO auth.users(id,email) VALUES
('95100000-0000-4000-8000-000000000001','solicitante-recusa@example.invalid'),
('95100000-0000-4000-8000-000000000011','borracheiro-a@example.invalid'),
('95100000-0000-4000-8000-000000000012','borracheiro-b@example.invalid'),
('95100000-0000-4000-8000-000000000099','outro-recusa@example.invalid');
INSERT INTO public.providers(id,owner_id,display_name,city,state_code,status,is_active,approved_at)
VALUES
('96100000-0000-4000-8000-000000000011','95100000-0000-4000-8000-000000000011','Borracharia de Teste A','Belo Horizonte','MG','approved',true,now()),
('96100000-0000-4000-8000-000000000012','95100000-0000-4000-8000-000000000012','Borracharia de Teste B','Belo Horizonte','MG','approved',true,now());
INSERT INTO public.provider_services(provider_id,category_id,is_active)
SELECT p.id,c.id,true FROM public.providers p CROSS JOIN public.service_categories c
WHERE p.id IN ('96100000-0000-4000-8000-000000000011','96100000-0000-4000-8000-000000000012') AND c.code='borracharia_delivery';
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000011',true);
SELECT public.bj_set_presence(true);
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000012',true);
SELECT public.bj_set_presence(true);
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000001',true);
INSERT INTO public.service_requests(id,customer_id,provider_id,category_id,problem_description,address_details,status,request_key)
SELECT '97100000-0000-4000-8000-000000000001','95100000-0000-4000-8000-000000000001','96100000-0000-4000-8000-000000000011',c.id,'Reparo de pneu virtual','Endereço fictício, 11','requested',
'98100000-0000-4000-8000-000000000001'
FROM public.service_categories c WHERE c.code='borracharia_delivery';
-- Rodada 1: A recusado uma vez -> B.
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000011',true);
SELECT public.bj_submit_quote('97100000-0000-4000-8000-000000000001',12000,'Orçamento A1');
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000001',true);
DO $$ DECLARE result text; BEGIN
 result:=public.bj_answer_quote((SELECT id FROM public.service_quotes
 WHERE request_id='97100000-0000-4000-8000-000000000001' AND status='proposed'),false);
 IF result<>'next_provider' OR (SELECT provider_id FROM public.service_requests WHERE id='97100000-0000-4000-8000-000000000001')<>'96100000-0000-4000-8000-000000000012'::uuid
 THEN RAISE EXCEPTION 'Primeira recusa não transferiu de A para B'; END IF;
END $$;
-- B recusado uma vez -> A retorna à fila.
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000012',true);
SELECT public.bj_submit_quote('97100000-0000-4000-8000-000000000001',13500,'Orçamento B1');
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000001',true);
DO $$ DECLARE result text; BEGIN
 result:=public.bj_answer_quote((SELECT id FROM public.service_quotes
 WHERE request_id='97100000-0000-4000-8000-000000000001' AND status='proposed'),false);
 IF result<>'next_provider' OR (SELECT provider_id FROM public.service_requests WHERE id='97100000-0000-4000-8000-000000000001')<>'96100000-0000-4000-8000-000000000011'::uuid
 THEN RAISE EXCEPTION 'Borracheiro A não voltou à mesma fila após uma recusa'; END IF;
END $$;
-- A recusado segunda vez -> B, A não deverá ser escolhido de novo.
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000011',true);
SELECT public.bj_submit_quote('97100000-0000-4000-8000-000000000001',12500,'Orçamento A2');
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000001',true);
DO $$ DECLARE result text; BEGIN
 result:=public.bj_answer_quote((SELECT id FROM public.service_quotes
 WHERE request_id='97100000-0000-4000-8000-000000000001' AND status='proposed'),false);
 IF result<>'next_provider' OR (SELECT provider_id FROM public.service_requests WHERE id='97100000-0000-4000-8000-000000000001')<>'96100000-0000-4000-8000-000000000012'::uuid
 THEN RAISE EXCEPTION 'Recusa de A segunda vez não seguiu para B'; END IF;
END $$;
-- B recusado segunda vez: A e B já tiveram duas recusas -> sem outro fornecedor.
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000012',true);
SELECT public.bj_submit_quote('97100000-0000-4000-8000-000000000001',14000,'Orçamento B2');
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000001',true);
DO $$ DECLARE result text; BEGIN
 result:=public.bj_answer_quote((SELECT id FROM public.service_quotes
 WHERE request_id='97100000-0000-4000-8000-000000000001' AND status='proposed'),false);
 IF result<>'no_provider' OR (SELECT status FROM public.service_requests WHERE id='97100000-0000-4000-8000-000000000001')<>'no_provider'
 THEN RAISE EXCEPTION 'Após segunda recusa de ambos deveria ficar sem fornecedor'; END IF;
END $$;
RESET ROLE;
DO $$ BEGIN
 IF (SELECT rejection_count FROM public.bj_request_attempts
     WHERE request_id='97100000-0000-4000-8000-000000000001' AND provider_id='96100000-0000-4000-8000-000000000011')<>2
 THEN RAISE EXCEPTION 'A precisa ter exatamente duas recusas'; END IF;
 IF (SELECT rejection_count FROM public.bj_request_attempts
     WHERE request_id='97100000-0000-4000-8000-000000000001' AND provider_id='96100000-0000-4000-8000-000000000012')<>2
 THEN RAISE EXCEPTION 'B precisa ter exatamente duas recusas'; END IF;
 IF (SELECT COUNT(*) FROM public.service_quotes WHERE request_id='97100000-0000-4000-8000-000000000001')<>4
 THEN RAISE EXCEPTION 'Histórico deveria conter 4 propostas recusadas'; END IF;
END $$;
-- Só solicitante pode encerrar, outro usuário não pode.
SET LOCAL ROLE authenticated;
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000099',true);
DO $$ DECLARE blocked boolean:=false; BEGIN
 BEGIN PERFORM public.bj_finish_request('97100000-0000-4000-8000-000000000001');
 EXCEPTION WHEN OTHERS THEN blocked:=true; END;
 IF NOT blocked THEN RAISE EXCEPTION 'Terceiro encerrou solicitação alheia'; END IF;
END $$;
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000001',true);
DO $$ BEGIN
 IF public.bj_finish_request('97100000-0000-4000-8000-000000000001')<>'cancelled'
 THEN RAISE EXCEPTION 'Cliente não conseguiu encerrar a rodada'; END IF;
END $$;
-- Rodada 2, id novo: mesmo A deve estar elegível de novo apesar de duas recusas anteriores.
INSERT INTO public.service_requests(id,customer_id,provider_id,category_id,problem_description,address_details,status,request_key)
SELECT '97100000-0000-4000-8000-000000000002','95100000-0000-4000-8000-000000000001','96100000-0000-4000-8000-000000000011',c.id,'Novo reparo de pneu virtual','Outro endereço fictício','requested',
'98100000-0000-4000-8000-000000000002'
FROM public.service_categories c WHERE c.code='borracharia_delivery';
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000011',true);
SELECT public.bj_submit_quote('97100000-0000-4000-8000-000000000002',11800,'Orçamento A em novo pedido');
SELECT set_config('request.jwt.claim.sub','95100000-0000-4000-8000-000000000001',true);
DO $$ DECLARE result text; BEGIN
 result:=public.bj_answer_quote((SELECT id FROM public.service_quotes
 WHERE request_id='97100000-0000-4000-8000-000000000002' AND status='proposed'),false);
 IF result<>'next_provider' OR (SELECT provider_id FROM public.service_requests WHERE id='97100000-0000-4000-8000-000000000002')<>'96100000-0000-4000-8000-000000000012'::uuid
 THEN RAISE EXCEPTION 'A não voltou a ser elegível no novo pedido'; END IF;
END $$;
RESET ROLE;
DO $$ BEGIN
 IF (SELECT rejection_count FROM public.bj_request_attempts
     WHERE request_id='97100000-0000-4000-8000-000000000002' AND provider_id='96100000-0000-4000-8000-000000000011')<>1
 THEN RAISE EXCEPTION 'Na segunda rodada a contagem deveria começar em zero e virar um'; END IF;
 IF (SELECT rejection_count FROM public.bj_request_attempts
     WHERE request_id='97100000-0000-4000-8000-000000000001' AND provider_id='96100000-0000-4000-8000-000000000011')<>2
 THEN RAISE EXCEPTION 'O histórico anterior foi modificado'; END IF;
 IF (SELECT COUNT(*) FROM public.payment_records)<>0
 THEN RAISE EXCEPTION 'Pagamento criado indevidamente'; END IF;
END $$;
ROLLBACK;
SELECT 'PASSOU: 1a recusa retorna à fila; 2a sai da rodada; novo pedido zera contador; terceiro não encerra; rollback' AS resultado;
