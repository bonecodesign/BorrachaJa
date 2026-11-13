# Salva Motoca! Oficial — Especificação de referência

**Nome oficial:** Salva Motoca!

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

## Disponibilidade online e decisão sobre orçamento

O prestador homologado escolhe **ficar online** ou **ficar offline**. Apenas quem oferece delivery, está habilitado e tem comunicação recente com o servidor entra na fila de novos pedidos.

O prestador fixa o valor do orçamento. O motociclista decide:

- **Aceitar:** pedido fica aguardando pagamento pelo aplicativo; não há cobrança nem despacho enquanto a integração financeira não existir.
- **Recusar:** a primeira recusa mantém o prestador elegível para outra oportunidade mais adiante na mesma rodada; após duas recusas do **mesmo solicitante na mesma solicitação**, fica de fora daquela rodada. O pedido segue para o próximo profissional online elegível, sem retornar imediatamente ao recém-recusado. Encerrar e criar novo pedido reinicia as contagens.
- **Conexão perdida:** a presença efetiva expira automaticamente. Desligar a disponibilidade bloqueia novos pedidos e preserva os já recebidos.

## Serviços oficiais e regras comerciais

1. **📍🛞 Mapa de borracharias físicas:** download, consulta e rotas gratuitos, sem comissão pela simples consulta.
2. **🛞 Delivery de borracharia:** atendimento para reparo de pneu no local, com solicitação, comunicação, orçamento e pagamento dentro da plataforma; comissão de **15%** sobre o valor efetivamente pago.
3. **🚚 Reboque de motos:** remoção ou transporte com solicitação, comunicação, orçamento e pagamento dentro da plataforma; **a mesma comissão de 15%**.

O prestador pode oferecer uma ou ambas as modalidades pagas em um único cadastro, com oferta, preço, disponibilidade e cobertura independentes.

## Prospecção inicial — BH + Contagem

Levantamento de 12/11/2026: **36 candidatos únicos**, associados a **40 ofertas**; quatro candidatos têm as duas modalidades de socorro, algumas ainda dependentes de confirmação. A referência pública, sem telefones, está em `data/prestadores_candidatos_BH_2026-11-12.csv`.

No Supabase `Salva Motoca`, os dados internos de prospecção ficam em tabelas privadas com RLS e sem acesso direto de `anon` ou `authenticated`. Contatos não são publicados no repositório nem exibidos no aplicativo.

**Nenhum candidato é parceiro homologado ou habilitado para chamados.** Não exibir ofertas, horários 24h ou disponibilidade operacional como confirmados até validação comercial e técnica. Pagamentos reais permanecem desativados enquanto não houver homologação do processador e do split financeiro.

## Política de desenvolvimento

O projeto está em fase de MVP. Deve usar planos gratuitos quando possível, sem afirmar disponibilidade comercial ou atendimento de emergência antes de testes operacionais, legais e de segurança.

## Próximas etapas

1. Validar contas separadas de motociclista e prestador em ambiente de teste.
2. Homologar manualmente prestadores reais antes de exibi-los no mapa.
3. Testar tempo de resposta, notificações, cobertura e fluxos antifraude.
4. Homologar pagamentos e split automático.
5. Publicar somente após validações operacionais, legais e de segurança.
