# BorrachaJá! Oficial — Especificação de referência

**Nome oficial:** BorrachaJá!

**Proposta:** conectar motociclistas a borracharias, borracheiros delivery e fornecedores de reboque de motos, em formato de marketplace.

**Área inicial de operação:** Belo Horizonte (BH) e região metropolitana de Minas Gerais.

## Acesso gratuito

O aplicativo e a consulta ao mapa de borracharias são gratuitos. O usuário pode localizar estabelecimentos, conferir informações disponíveis e obter rota até o local. A ida direta ao estabelecimento não gera comissão para a plataforma.

## Serviços intermediados

A contratação dentro da plataforma cobre **borracharia no local do problema** e **reboque de motos**, ambos sujeitos à comissão de **15%** sobre o valor do serviço pago. Um mesmo fornecedor pode atender às duas modalidades.

O cliente pode escolher um profissional ou solicitar busca automática. O profissional informa um orçamento, o cliente aceita e paga por meio do aplicativo. A divisão financeira e os repasses dependem de integração homologada com um provedor de pagamentos. Nesta fase, os pagamentos reais estão desativados.

## Comunicação

Telefones e links externos não são exibidos nos perfis. Chamados delivery usam fluxos de orçamento e comunicação interna. Informações de segurança e suporte permanecem acessíveis conforme necessidade.

## Profissionais e administração

Os prestadores se cadastram e passam por verificação antes de aparecerem como ativos. O administrador gerencia solicitações e aprovações. Dados de contato administrativo e registros privados não pertencem a este repositório público.

## Política de desenvolvimento

O projeto está em fase de MVP; deve usar planos gratuitos quando possível, sem afirmar disponibilidade comercial ou atendimento de emergência antes de testes completos.

## Próximas etapas

1. Organizar o código do MVP e os testes.
2. Evoluir e testar o projeto Supabase `BorrachaJa-Oficial` (criado com esquema inicial, migrações e RLS), usando exclusivamente `bonecodesign/BorrachaJa` para versionamento.
3. Validar os primeiros prestadores.
4. Homologar pagamentos e split automático.
5. Publicar apenas após testes operacionais, legais e de segurança.

## Serviços oficiais e regras comerciais — 12/11/2026

O BorrachaJá! Oficial atende inicialmente motociclistas de Belo Horizonte e Região Metropolitana com três funcionalidades:

1. **📍🛞 Mapa de borracharias físicas:** download, consulta e rotas gratuitos, sem comissão pela simples consulta.
2. **🛞 Delivery de borracharia:** atendimento para reparo de pneu no local, com solicitação, comunicação, orçamento e pagamento dentro da plataforma; comissão de **15%** sobre o valor efetivamente pago pelo serviço.
3. **🚚 Reboque de motos:** remoção/transporte com solicitação, comunicação, orçamento e pagamento dentro da plataforma; **a mesma comissão de 15%**.

O prestador pode oferecer uma ou ambas as modalidades pagas em **um único cadastro**, com oferta, preço, disponibilidade e cobertura independentes. O ícone duplo é 🛞🚚.

### Prospecção inicial — BH + Contagem

Levantamento de 12/11/2026: **36 candidatos únicos**, associados a **40 ofertas**; quatro candidatos têm as duas modalidades de socorro, algumas ainda dependentes de confirmação. Fonte de referência pública, sem telefones: `data/prestadores_candidatos_BH_2026-11-12.csv`.

No Supabase `BorrachaJa-Oficial`, os dados internos da prospecção ficam nas tabelas `prestadores_prospeccao`, `ofertas_prospeccao` e `configuracao_comercial`, com RLS e sem acesso direto de `anon` ou `authenticated` nesta etapa. Contatos não são publicados no repositório nem exibidos no aplicativo.

**Nenhum candidato é parceiro homologado ou habilitado para chamados**. Não exibir ofertas, horários 24h ou disponibilidade operacional como confirmados até validação comercial e técnica. Pagamentos reais permanecem desativados enquanto não houver homologação do processador e do split financeiro.
