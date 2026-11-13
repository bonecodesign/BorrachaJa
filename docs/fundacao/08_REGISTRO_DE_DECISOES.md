# FND-08 — Registro mestre de decisões

**Versão 0.1 • Fonte de verdade para decisões de produto e negócio**  
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
| SM-DEC-014 | Comissão de referência: **15% sobre serviços delivery efetivamente pagos** | Hipótese comercial registrada; confirmar instrumento financeiro e contratual |
| SM-DEC-015 | Reboque é ideia de expansão futura e não entra no pagamento ativo do MVP | Referência atual documentada; reavaliar antes de expandir |
| SM-DEC-016 | Foco no mesmo projeto e nas alterações versionadas; migrações só após análise do banco ativo | Aprovada |

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
| SM-OPEN-002 | PSP, Pix/cartões, custos de processamento e split | Repasse e margem |
| SM-OPEN-003 | Critérios e documentos exatos para homologar borracheiros | Segurança e legalidade |
| SM-OPEN-004 | Área de atuação, raio e priorização de prestadores | Chamados viáveis |
| SM-OPEN-005 | Tempo máximo de resposta e recusa pelo próprio prestador | Evitar pedidos parados |
| SM-OPEN-006 | Preço composto, deslocamento, extras e revisão de orçamento | Previsibilidade financeira |
| SM-OPEN-007 | Cancelamento após pagamento, estorno e mediação | Direitos e incidentes |
| SM-OPEN-008 | Regime de tributação, notas e tratamento contábil | Sustentabilidade legal |
| SM-OPEN-009 | Disponibilidade de suporte e escalonamento humano | Operação real |
| SM-OPEN-010 | Metas quantitativas de piloto, lançamento e indicadores | Gate de decisão |
| SM-OPEN-011 | Política de idade/elegibilidade para contas e geolocalização | Direitos e proteção de dados |
| SM-OPEN-012 | Critérios de ranking e reputação, prevenção de direcionamento injusto | Transparência |
| SM-OPEN-013 | Marca/slogan finais, domínio e registro de marca | Identidade e propriedade intelectual |

## Controle de alteração

Uma alteração deve receber: ID, enunciado anterior, enunciado novo, razão, data, responsável que aprovou, impacto técnico/financeiro/jurídico, PR e teste de regressão. Caso uma decisão posterior conflite com uma antiga, sinalizar o conflito expressamente antes de alterar o código.

## Itens que NÃO estão decididos

Não presumir: tarifa obrigatoriamente suportada por qualquer parte, tempo de chegada garantido, atendimento 24 horas, cobertura de todo município, vínculo trabalhista ou ausência de vínculo, exclusão contratual ampla de responsabilidade, retenção indefinida de dados, habilitação de pagamentos ou autorização automática de candidatos prospectados.
