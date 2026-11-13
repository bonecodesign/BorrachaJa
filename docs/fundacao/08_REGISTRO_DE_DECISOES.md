# FND-08 — Registro mestre de decisões

**Versão 0.2 • Fonte de verdade para decisões de produto e negócio**  
Aprovado significa **definido pelo responsável do produto**, não necessariamente implementado, homologado juridicamente ou publicado.

## Decisões expressas consolidadas

| ID | Decisão | Estado |
| --- | --- | --- |
| SM-DEC-001 | Nome público atual: **Salva Motoca!**; identidade anterior BorrachaJá! é legado técnico | Aprovada; migração de marca parcial |
| SM-DEC-002 | Repositório de trabalho autorizado: **bonecodesign/salvamotoca**, sem tocar outros projetos | Aprovada |
| SM-DEC-003 | Praça piloto inicial: **Belo Horizonte, MG** | Aprovada |
| SM-DEC-004 | Consulta ao mapa de borracharias: **gratuita**, sem comissão por visita direta | Aprovada |
| SM-DEC-005 | Prestador delivery informa o valor do orçamento; cliente pode aceitar ou recusar | Aprovada |
| SM-DEC-006 | O prestador escolhe **online/offline** no aplicativo; sem internet e sinal recente não recebe novos pedidos | Aprovada |
| SM-DEC-007 | O prestador recusado **volta à fila após a primeira recusa** do mesmo solicitante na mesma solicitação | Aprovada |
| SM-DEC-008 | Após a **segunda recusa** do mesmo solicitante na mesma solicitação, o prestador fica fora somente daquela rodada | Aprovada |
| SM-DEC-009 | Encerrar a solicitação e criar outra **zera a contagem** para todos os prestadores elegíveis, sem bloqueio permanente | Aprovada |
| SM-DEC-010 | Profissionais precisam ser aprovados antes de aparecer como habilitados | Aprovada |
| SM-DEC-011 | Contatos telefônicos/WhatsApp de terceiros não ficam publicados para evitar desintermediação | Aprovada |
| SM-DEC-012 | Pagamentos reais não serão ativados antes de integração, testes e homologação | Aprovada |
| SM-DEC-013 | Desenvolvimento inicial deve evitar serviços pagos sem autorização, priorizando custo R$ 0 | Aprovada como restrição de projeto |
| SM-DEC-014 | Comissão de **15% sobre o valor de serviços de borracharia delivery efetivamente pagos pelo aplicativo** | **Aprovada expressamente em 12/11/2026**. Implementação condicionada a contrato, tributação, PSP, split e regras de estorno; sem ativação de cobranças nesta decisão |
| SM-DEC-015 | Reboque de motos já integra o produto; seu pagamento real e despacho comercial permanecem desativados até homologação | Atualizada em 13/11/2026; sem autorização para cobrança real |
| SM-DEC-016 | Foco no mesmo projeto e nas alterações versionadas; migrações só após análise do banco ativo | Aprovada |
| SM-DEC-017 | Tarifa de processamento de Pix/cartão é encargo do **cliente**, exibida separadamente antes da confirmação; comissão de 15% incide somente sobre o serviço | **Aprovada expressamente em 13/11/2026**; implementação depende de PSP, contrato, impostos, regras de estorno e transparência |
| SM-DEC-018 | Orçamento deve discriminar serviço e deslocamento quando aplicável; qualquer extra posterior exige novo orçamento e novo aceite; não há acréscimo automático após aceite | **Aprovada expressamente em 13/11/2026**; pagamentos reais continuam desativados |

## Definições técnicas adotadas, ajustáveis após testes

- Heartbeat de prestador aproximadamente a cada 30 segundos; presença considerada efetiva com sinal recente, dentro de janela de cerca de 90 segundos.
- Busca piloto no mesmo município, com proximidade aproximada quando houver coordenadas.
- Em cada rodada, preferir quem tem zero recusas, depois quem tem uma; nunca devolver imediatamente a proposta ao profissional recém-recusado.
- Encerrar solicitação de **teste** usa estado cancelado. A conclusão de serviço real exige outra lógica.
- Cada solicitação tem ID independente e histórico de tentativas próprio.

## Pendências de aprovação do responsável pelo produto

| ID | Tema pendente | Por que importa |
| --- | --- | --- |
| SM-OPEN-001 | Pessoa jurídica, razão social, CNPJ e contatos oficiais | Contratos, notas e canal de atendimento |
| SM-OPEN-002 | PSP, Pix/cartões, custo efetivo, split e regras de liquidação da tarifa já atribuída ao cliente | Implementar sem taxas-surpresa e com transparência |
| SM-OPEN-003 | Critérios e documentos exatos para homologar borracheiros | Segurança e legalidade |
| SM-OPEN-004 | Área de atuação, raio e priorização de prestadores | Chamados viáveis |
| SM-OPEN-005 | Tempo máximo de resposta e recusa pelo próprio prestador | Evitar pedidos parados |
| SM-OPEN-006 | Política de preço mínimo e deslocamento por área | Definir previsibilidade sem criar cobrança automática |
| SM-OPEN-007 | Cancelamento após pagamento, estorno e mediação | Direitos e incidentes |
| SM-OPEN-008 | Regime de tributação, notas e tratamento contábil | Sustentabilidade legal |
| SM-OPEN-009 | Disponibilidade de suporte e escalonamento humano | Operação real |
| SM-OPEN-010 | Metas quantitativas de piloto, lançamento e indicadores | Gate de decisão |
| SM-OPEN-011 | Política de idade/elegibilidade para contas e geolocalização | Direitos e proteção de dados |
| SM-OPEN-012 | Critérios de ranking e reputação, prevenção de direcionamento injusto | Transparência |
| SM-OPEN-013 | Marca/slogan finais, domínio e registro de marca | Identidade e propriedade intelectual |

## Histórico de validação

- **12/11/2026 — SM-DEC-014:** responsável pelo produto aprovou expressamente a comissão de **15% sobre o valor dos serviços delivery efetivamente pagos no Salva Motoca!**. Não há autorização para iniciar cobranças reais.
- **13/11/2026 — SM-DEC-017:** responsável pelo produto aprovou a **tarifa de processamento como encargo do cliente**, destacada antes da confirmação e separada da comissão. PSP, custo real, split, estorno e tributos continuam pendentes de homologação.
- **13/11/2026 — SM-DEC-015 atualizada:** reboque já está implementado no produto; pagamento e despacho comercial continuam desativados.
- **13/11/2026 — SM-DEC-018:** orçamento discriminado entre serviço e deslocamento; extras exigem novo aceite. Não há cobrança automática posterior.

## Controle de alteração

Uma alteração deve receber: ID, enunciado anterior, enunciado novo, razão, data, responsável que aprovou, impacto técnico/financeiro/jurídico, PR e teste de regressão. Caso uma decisão posterior conflite com uma antiga, sinalizar o conflito expressamente antes de alterar o código.

## Itens que NÃO estão decididos

Não presumir: valor ou modalidade da tarifa sem PSP homologado, tempo de chegada garantido, atendimento 24 horas, cobertura de todo município, vínculo trabalhista ou ausência de vínculo, exclusão contratual ampla de responsabilidade, retenção indefinida de dados, habilitação de pagamentos ou autorização automática de candidatos prospectados.
