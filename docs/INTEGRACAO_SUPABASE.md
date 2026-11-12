# Integração real do BorrachaJá! com Supabase

## Projetos autorizados

- GitHub: `bonecodesign/BorrachaJa`
- Supabase: `BorrachaJa`, projeto `yivkqyjdeouxnwtwfekc`, região `sa-east-1`
- O projeto não atende emergências nem processa dinheiro nesta fase.

## Estrutura REAL do banco (revisada em 12/11/2026)

O banco já possui o esquema publicado nas migrations do Supabase, diferente do `supabase/schema.sql` de uma versão anterior. **NÃO executar `supabase/schema.sql` neste projeto.**

| Domínio | Tabelas |
| --- | --- |
| Contas | `app_profiles` |
| Catálogo | `service_categories`, `providers`, `provider_services` |
| Pedidos e orçamentos | `service_requests`, `service_quotes`, `request_messages` |
| Pagamentos (somente modelagem) | `payment_records` |
| Prospecção (PRIVADA) | `prestadores_prospeccao`, `ofertas_prospeccao`, `configuracao_comercial` |

As 36 entradas de prospecção e 40 ofertas cadastradas **não equivalem a prestadores aprovados** e não aparecem no mapa. A tabela `providers` estava vazia no momento da auditoria.

## Front-end conectado

- `config.js` contém somente a URL e **publishable key** do Supabase (informações destinadas ao navegador, nunca uma chave secreta).
- `bootstrap.js` carrega a biblioteca do Supabase fixada em `2.119.0` e `live-app-current.js`.
- `live-app-current.js` usa exclusivamente as tabelas reais, permite consultar o mapa gratuitamente, criar conta, enviar solicitação de cadastro de prestador, abrir pedidos **de TESTE** e registrar orçamentos de teste.
- Cadastro de prestador cria registros `providers` e `provider_services` inativos. Aprovação/habilitação requer verificação administrativa por canal seguro.
- Nenhuma confirmação de pagamento, repasse automático, despacho operacional ou contato externo está habilitada.

## Segurança do endereço

Foi aplicada a migration `20261112214828_restringir_localizacao_pedidos_antes_pagamento`.

- Colunas `address_details`, `latitude` e `longitude` de `service_requests` não podem mais ser lidas diretamente pelo papel `authenticated`.
- A função `bj_get_request_location(uuid)` confere `auth.uid()`, oferece endereço ao próprio cliente, e só o disponibiliza ao prestador quando `payment_records.status = 'paid'`.
- O advisor do Supabase aponta a função como `SECURITY DEFINER` invocável por `authenticated`. Esse uso é proposital, com checagem explícita de titularidade; revisar manualmente e testar com contas separadas antes de produção.
- Nenhuma senha, `service_role` ou chave `sb_secret_*` pode entrar no GitHub ou navegador.

## Para executar localmente

Na pasta do projeto:

```bash
python3 -m http.server 8080
```

Abra `http://localhost:8080` com internet. A autenticação do Supabase poderá exigir confirmação de e-mail. O modo demonstração anterior permanece em `app.js`, mas a configuração atual carrega o modo conectado.

## Verificações recomendadas antes de uso público

1. Conta anônima visualiza somente prestadores aprovados e ativos.
2. Contas de cliente e prestador não conseguem consultar dados pessoais umas das outras.
3. Prestador sem pagamento não consegue ler `address_details`, `latitude` nem `longitude` via REST ou RPC.
4. Cadastro de prestador começa sempre `pending` / inativo; a administração precisa validar o serviço.
5. A criação de orçamento não deve confirmar atendimento ou alterar status financeiro.
6. Testar atualização de sessão, confirmação de e-mail e RLS em dois navegadores independentes.
7. Não habilitar pagamentos reais até implementar webhooks com assinatura, antifraude, split, conciliação e reembolso.

## Alertas e pendências

- O `service_requests` existente ainda não oferece idempotência contra criação duplicada. Implantar antes de pedidos reais.
- O esquema de prospecção é isolado sem políticas de consulta pública (comportamento desejado).
- É necessário criar ferramenta de homologação administrativa segura e definir método de captura de localização correto para o pedido.
- A busca automática usa distância aproximada: ainda não possui despacho automático confiável.
