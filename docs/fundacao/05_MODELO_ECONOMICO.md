# FND-05 — Modelo econômico-financeiro e hipóteses

**Versão 0.2 — estudo interno, não previsão de faturamento**

## Hipóteses aprovadas ou registradas

- **Mapa e consulta:** gratuitos, sem cobrança pela ida direta à oficina.
- **Serviços intermediados de borracharia delivery e reboque de motos:** comissão de **15%** sobre o valor efetivamente pago e liquidado pelo aplicativo, conforme decisão comercial e escopo da especificação oficial (SM-DEC-014 e SM-DEC-015). A aplicação prática permanece condicionada a contratos, regras de estorno, tributação e integração financeira homologada.
- **Reboque:** já integra o produto oficial, não é expansão futura. Sua categoria existe no banco, mas no Supabase ativo está com `paid_in_app=false` e comissão de 0%; trata-se de uma **lacuna de integração técnica**, não de uma alteração da regra comercial. Não ativar cobrança antes da homologação.
- **Preço de serviço:** definido pelo prestador por orçamento; cliente aceita ou recusa.
- **Pagamento:** Pix/cartões e split ainda não conectados nem homologados.
- **Custo inicial de desenvolvimento:** priorizar ferramentas gratuitas quando possível, **não** considerar que a operação real terá custo zero.

## Unidade econômica de uma transação

Definições (valores em reais):
- P = preço total aceito e liquidado;
- c = comissão nominal (referência 0,15);
- F = tarifa de processamento cobrada pelo provedor de pagamentos, suportada contratualmente pelo prestador (SM-DEC-017);
- F_plataforma = eventual custo de pagamento que recaia efetivamente sobre a plataforma por exigência do PSP, contingência ou impossibilidade de repasse (não presumir zero);
- V = custo variável de infraestrutura, mensagens e suporte atribuível ao pedido;
- T = tributos incidentes na operação da plataforma, conforme enquadramento;
- D = perda média esperada com disputas/estornos/fraudes;
- R = ajustes, reembolsos e repasses reversos.

**Comissão bruta definida para cálculo = P × 0,15.**

**Resultado de contribuição estimado da plataforma = (P × c) − F_plataforma − V − T − D − R.**

**Alocação de custos aprovada:** a tarifa ordinária de processamento do Pix e dos cartões é responsabilidade do **prestador**, tanto na borracharia delivery quanto no reboque, distinta dos 15% de comissão. O repasse ilustrativo, antes de tributos próprios, ajustes ou reservas, é **P − (P × 0,15) − F**. A comissão bruta da plataforma permanece **P × 0,15**; sua margem depende de outros custos efetivos, impostos e devoluções. O PSP escolhido precisará permitir a cobrança ou dedução transparente dessa tarifa do saldo do prestador, sem acréscimo inesperado ao cliente. Não assumir tarifas numéricas sem contrato.

### Exemplo meramente ilustrativo — NÃO é preço de mercado

| Valor aceito hipotético | Comissão de 15% | Parcela antes de outras taxas e tributos |
| ---: | ---: | ---: |
| R$ 80,00 | R$ 12,00 | R$ 68,00 |
| R$ 100,00 | R$ 15,00 | R$ 85,00 |
| R$ 150,00 | R$ 22,50 | R$ 127,50 |

**Atenção:** números acima mostram valores antes da tarifa de processamento, que será suportada pelo prestador, além de impostos, suporte e eventuais devoluções. Não são promessa de repasse líquido.

## Variáveis para a planilha de viabilidade

| Variável | Unidade | Situação |
| --- | --- | --- |
| Prestadores homologados | quantidade | Sem base operacional ainda |
| Prestadores online ativos por hora | quantidade | Medir em piloto |
| Pedidos iniciados por dia | quantidade | Hipótese a levantar |
| Pedidos que recebem orçamento | % | Teste real pendente |
| Taxa de aceite | % | Teste real pendente |
| Ticket médio efetivamente pago | R$ | Pesquisa e piloto pendentes |
| Comissão nominal | % | **15% aprovada internamente**; implementação pendente |
| Tarifa de processamento (Pix/cartões) | R$/pedido e % | **Prestador responsável — SM-DEC-017**; valores e forma de desconto a negociar com PSP |
| Custo variável de atendimento | R$/pedido | Medir |
| Impostos e obrigações | % e R$ | Contador/jurídico definir |
| Chargeback/refund | % e R$ | Medir |
| Custo fixo mensal | R$ | Orçar |
| Capital de giro e reserva | R$ | Definir |

## Fórmulas de planejamento

**Pedidos liquidados mensais = pedidos iniciados × % com orçamento × % de aceite × % liquidados.**

**Comissão bruta mensal = (reparos delivery liquidados × ticket médio de reparo + reboques liquidados × ticket médio de reboque) × 15%.**

Acompanhar conversão, ticket, despesas variáveis e risco separadamente para cada modalidade.

**Margem de contribuição mensal = comissão bruta − custos variáveis da plataforma − devoluções e ajustes associados.**

**Resultado operacional estimado = margem de contribuição − custos fixos − despesas e tributos adicionais que caibam à plataforma.**

**Ponto de equilíbrio**, quando a margem média unitária for positiva: custos fixos mensais ÷ margem média por pedido. Não publicar ponto de equilíbrio sem medir custos reais.

## Riscos financeiros

1. Comissão insuficiente para custo de pagamento e suporte em tickets baixos.
2. Estornos/chargebacks, golpes e disputas sobre serviço prestado.
3. Repasses antecipados antes de confirmação de liquidação.
4. Impostos e retenções não modelados corretamente.
5. Necessidade de atendimento humano em casos de risco e reclamação.
6. Processador que não ofereça split, conciliação ou reembolso adequados.
7. Falta de prestadores online suficiente para gerar conversão.

## Controles obrigatórios

- Não manter dados brutos de cartão.
- Conciliar pagamento pelo servidor, com webhook validado, deduplicado e auditável.
- Separar valores de terceiros de receita da plataforma no planejamento contábil.
- Relatório de conciliação, estorno, retenção e imposto por período.
- Exibir ao cliente valor final antes de confirmação, sem taxas surpresas.
- **SM-DEC-017 aprovada:** o prestador suporta a tarifa ordinária de processamento Pix/cartão; negociar valor e forma de cobrança com PSP. Aprovar separadamente a matriz de tributos, cancelamentos, reembolsos e chargebacks.
- Não habilitar cobranças até testes reais e revisão contratual.

## Decisões comerciais pendentes

**A comissão de 15% já está aprovada como percentual comercial dos serviços intermediados; sua aplicação no reboque precisa ser compatibilizada com banco, interface e contratos.** **A responsabilidade pela tarifa de processamento Pix/cartão já está aprovada para o prestador.** Ainda é necessário decidir: provedor financeiro e sua tabela efetiva de tarifas, forma de desconto/repasse, preço mínimo de serviço; cobrança por deslocamento; eventuais condições promocionais; split automático; calendário de repasses; reserva financeira para contingências; estornos parciais e tratamento de fraudes.

## Cenários propostos para análise futura

Construir planilha com **conservador**, **base** e **expansão**, alimentada por dados de entrevistas e do piloto (não inserir números arbitrários como estimativa real). Registrar por cenário: prestadores ativos, horários, pedidos, ticket, conversão, taxa de pagamento, reembolso, margem e necessidade de caixa.
