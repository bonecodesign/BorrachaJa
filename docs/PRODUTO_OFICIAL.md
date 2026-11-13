# Salva Motoca! Oficial — Especificação de referência

**Nome oficial:** Salva Motoca!

**Proposta:** conectar motociclistas a borracharias, borracheiros delivery e fornecedores de reboque de motos, em formato de marketplace.

**Área inicial de operação:** Belo Horizonte (BH) e região metropolitana de Minas Gerais.

## Acesso gratuito

O aplicativo e a consulta ao mapa de borracharias são gratuitos. O usuário pode localizar estabelecimentos, conferir informações disponíveis e obter rota até o local. A ida direta ao estabelecimento não gera comissão para a plataforma.

## Serviços intermediados

A contratação dentro da plataforma cobre **borracharia no local do problema** e **reboque de motos**, ambos sujeitos à comissão de **15%** sobre o valor do serviço pago. Um mesmo fornecedor pode atender às duas modalidades.

O cliente pode escolher um profissional ou solicitar busca automática. O profissional informa orçamento discriminado entre serviço e deslocamento, quando aplicável; o cliente vê o total antes de aceitar. Qualquer extra posterior exige novo orçamento e novo aceite. A divisão financeira e os repasses dependem de integração homologada com um provedor de pagamentos. Quando ativada, a tarifa de processamento será um encargo do cliente, mostrada separadamente antes da confirmação; a comissão de 15% incidirá somente sobre o valor do serviço. Nesta fase, os pagamentos reais estão desativados.

## Comunicação

Telefones e links externos não são exibidos nos perfis. Chamados delivery usam fluxos de orçamento e comunicação interna.

## Profissionais e administração

Os prestadores se cadastram e passam por verificação antes de aparecerem como ativos. O administrador gerencia solicitações e aprovações. Dados de contato administrativo e registros privados não pertencem a este repositório público.

## Disponibilidade online e decisão sobre orçamento

O prestador homologado escolhe **ficar online** ou **ficar offline**. Apenas quem oferece delivery, está habilitado e tem comunicação recente com o servidor entra na fila de novos pedidos.

- **Aceitar:** pedido fica aguardando pagamento; não há cobrança nem despacho enquanto a integração financeira não existir.
- **Recusar:** a primeira recusa mantém o prestador elegível para outra oportunidade mais adiante na mesma rodada; após duas recusas do mesmo solicitante na mesma solicitação, fica de fora daquela rodada. O pedido segue para o próximo profissional online elegível, priorizando os mais próximos e sem retornar imediatamente ao recém-recusado. A área de busca se amplia gradualmente apenas quando necessário, respeitando sempre a área de atendimento declarada pelo prestador. Encerrar e criar novo pedido reinicia as contagens.
- **Conexão perdida:** a presença efetiva expira automaticamente. Desligar a disponibilidade bloqueia novos pedidos e preserva os já recebidos.

## Serviços oficiais e regras comerciais

1. **📍🛞 Mapa de borracharias físicas:** download, consulta e rotas gratuitos, sem comissão pela simples consulta.
2. **🛞 Delivery de borracharia:** atendimento para reparo de pneu no local, com solicitação, comunicação, orçamento e pagamento dentro da plataforma; comissão de **15%** sobre o valor do serviço efetivamente pago. Deslocamento e tarifa de processamento não compõem essa comissão.
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

## Regra de resposta do prestador

- Prestador online tem **5 minutos** para aceitar ou recusar a solicitação.
- Sem resposta no período, o pedido segue para o próximo prestador elegível.
- **10 ausências em 30 dias** levam o perfil à revisão administrativa; não há bloqueio automático.
- A regra depende de notificação entregue e registrada; seu acionamento fica pendente da implementação e homologação dos canais de aviso.

## Área de atendimento do prestador

- Cada prestador declara sua área de atendimento no perfil e pode atualizá-la.
- Chamados só são ofertados dentro dessa área; estar online não obriga o prestador a atender fora dela.
- A busca progressiva prioriza proximidade, mas respeita essa delimitação.

## Notificações de chamados

- Prestador só participa quando estiver online e tiver autorizado notificações.
- O chamado gera alerta no app/PWA com som, vibração e contador de 5 minutos; há lembretes aos 2min e 4min30s.
- A plataforma registra envio, entrega quando tecnicamente disponível, abertura e resposta.
- Se a notificação falhar, não há ausência atribuída ao prestador; o pedido segue ao próximo elegível.
- SMS e WhatsApp não são usados nesta primeira fase.
4. Homologar pagamentos e split automático.
5. Publicar somente após validações operacionais, legais e de segurança.
