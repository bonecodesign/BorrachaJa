# FND-03 — PRD: requisitos do Salva Motoca!

**Versão 0.1 • Público: desenvolvimento, UX, QA, operação e governança**

## Objetivo do produto

Entregar uma jornada digital confiável que permita encontrar borracharias e contratar **reparo de pneus no local ou reboque de motocicletas** com orçamento escolhido pelo profissional, decisão do cliente, gestão de disponibilidade e pagamentos protegidos, após homologação comercial.

**Estado atual:** protótipo e Supabase integrados na branch de desenvolvimento, com testes virtuais. Não publicado comercialmente nem homologado ponta a ponta em produção. A palavra "implementado" não implica lançamento.

## Papéis

- **Visitante:** consulta mapa de oficinas aprovadas, sem criar pedido.
- **Motociclista solicitante:** cadastra-se, inicia pedido, visualiza propostas, aceita/recusa, encerra solicitação e acompanha histórico.
- **Prestador/borracheiro:** cadastra-se, aguarda aprovação, informa serviços, escolhe status online/offline, atende pedidos atribuídos e propõe valor.
- **Administrador autorizado:** verifica identidade e habilitação, aprova/suspende, audita chamados, revisa disputas e trata ocorrências; acesso com segregação de privilégios.
- **Suporte/financeiro futuros:** apenas papéis específicos, com permissões mínimas.

## Requisitos funcionais

| ID | Requisito | Critério de aceite | Situação |
| --- | --- | --- | --- |
| SM-F01 | Mapa gratuito | Visitante consulta estabelecimentos aprovados e ativos sem pagar | Implementação inicial; testes virtuais |
| SM-F02 | Cadastro | Cliente e prestador autenticam separadamente; validação de e-mail real | Parcial |
| SM-F03 | Homologação | Prestador pendente não aparece no mapa; administração aprova manualmente | Regras banco testadas; painel pendente |
| SM-F04 | Presença | Só quem escolheu online e mantém sinal recente entra em novos pedidos | Implementado; teste virtual |
| SM-F05 | Busca manual/automática | Apenas prestadores elegíveis, com critérios geográficos objetivos | Parcial; roteamento real pendente |
| SM-F06 | Solicitação | Cliente registra problema e área; ID e chave de idempotência impedem duplicações técnicas | Implementação inicial; teste virtual |
| SM-F07 | Orçamento | Prestador atribuído informa valor final em centavos e detalhes; proposta auditável | Implementado; teste virtual |
| SM-F08 | Aceite | Cliente aceita proposta válida; pedido espera pagamento, sem marcar como pago | Implementado; teste virtual |
| SM-F09 | Recusa | Recusa 1 permite retorno posterior; recusa 2 tira prestador apenas do pedido atual | Implementado; teste virtual |
| SM-F10 | Encerramento | Titular encerra pedido de teste; nova solicitação começa com contadores zerados | Implementado; teste virtual |
| SM-F11 | Temporizador | Sem resposta em prazo configurado, avança de forma segura; evitar múltiplos prestadores simultâneos | Pendente |
| SM-F12 | Notificações | Mudança de status chega aos participantes sem exigir atualização manual | Pendente |
| SM-F13 | Pagamento protegido | Pix/cartão, confirmação de provedor, conciliação, divisão e estorno auditados | Pendente; desativado |
| SM-F14 | Atendimento | Progresso, chegada, conclusão e disputa com confirmação apropriada | Pendente |
| SM-F15 | Suporte | Abertura de ocorrência, protocolo, revisão humana e prazo claro | Pendente |
| SM-F16 | Painel administrativo | Aprovação, suspensão, auditoria, gestão de chamados e suporte | Pendente |
| SM-F17 | Avaliação | Reputação com controle antifraude e direito de resposta apropriado | Pendente |
| SM-F18 | Acessibilidade | Contraste, navegação por teclado, mensagens acessíveis e clareza de estado | A validar |
| SM-F19 | Reboque de motos | Cliente seleciona reboque, descreve necessidade de remoção, recebe orçamento de profissional habilitado, aceita/recusa e segue a mesma regra de rodada | **Categoria cadastrada no banco e prevista no produto; fluxo E2E e pagamento pendentes** |
| SM-F20 | Modalidades do prestador | Prestador pode ofertar reparo, reboque ou ambos, com homologação e disponibilidade conforme serviço e cobertura | Especificado; validação técnica pendente |

## Regras operacionais fechadas

**Mapa:** consulta sem cobrança e sem comissão por simples visita ao local.

**Modalidades pagas previstas no produto:** reparo delivery e reboque de motos, sob comissão comercial de 15% sobre serviços efetivamente pagos. Nenhuma cobrança está habilitada nesta etapa; no banco ativo, reboque aparece temporariamente não cobrável e não é oferecido pelo front-end conectado. Corrigir e homologar essa divergência antes de operar.

**Elegibilidade delivery:** homologado, serviço habilitado, flag online voluntária e sinal de comunicação com o servidor nos últimos ~90 s.

**Orçamento:** preço informado pelo prestador, sem alterar automaticamente depois de aceito. Cliente decide aceitar/recusar, sem pagamento direto ao prestador fora do fluxo previsto.

**Fila:** rodada identificada por ID da solicitação. A primeira recusa do cliente para prestador A coloca A de volta na fila, mas não entrega imediatamente o mesmo pedido a A. Na segunda recusa do mesmo cliente no mesmo pedido, A é inelegível naquela rodada. Novo pedido = histórico independente, contadores zerados.

**Encerramento:** no piloto, encerra como cancelado, não como atendimento realizado. Não deve permitir cancelamento automático com pagamento efetivado sem fluxo de estorno/mediação.

**Privacidade:** cliente vê endereço próprio; profissional só recebe localização exata no momento operacional legítimo e autorizado pelo servidor. Não expor dados sensíveis nos logs, mapa ou repositório público.

## Estados e transições (proposta atual)

- Solicitação: requested → quoted → awaiting_payment (aceite) ou requested novamente (recusa e novo prestador); no_provider se sem próximo; cancelled para encerramento de teste. Estados paid/accepted/in_progress/completed dependem de operações futuras.
- Orçamento: proposed → accepted / declined / expired.
- Presença: online solicitado + heartbeat recente = elegível; offline solicitado ou sem heartbeat recente = não elegível.
- Prestador: pending → approved (admin) ou rejected; suspensão e reativação com auditoria.

## Requisitos não funcionais

**Segurança:** RLS, autenticação, privilégio mínimo, proteção contra manipulação de estado e preço, limites de requisição, logs de auditoria, segredos fora do navegador e teste de funções privilegiadas.

**Confiabilidade:** idempotência, confirmação de gravação, concorrência transacional, recuperação após queda de rede, backup/restore e respostas claras para falhas.

**Privacidade:** minimizar GPS/endereço, informar finalidades, definir retenção, direitos dos titulares e controles de acesso.

**Desempenho:** estabelecer metas quantitativas só após teste de carga e configuração de infraestrutura reais.

**Acessibilidade e UX:** telas simples, legíveis, sem exigir interação insegura enquanto o motociclista dirige.

## Critérios de liberação para piloto com pagamentos

1. Fluxos F01–F16 críticos cobertos por testes HTTP/E2E com usuário real de teste.
2. Dois prestadores diferentes recebem propostas com regra de recusas e novo pedido.
3. Autohomologação e acesso cruzado a dados não são possíveis.
4. Pagamento confirmado apenas por integração do servidor com provedor homologado; webhook autenticado, idempotente e conciliado.
5. Consentimentos, termos, canal de privacidade e suporte publicados corretamente.
6. Teste de indisponibilidade do provedor e contingência, sem cobranças duplicadas.
7. Revisões jurídica, financeira e operacional formalmente aprovadas.
