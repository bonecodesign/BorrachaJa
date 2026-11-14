# F1 — Solicitação completa segura (PR de revisão)

**Estado:** implementação isolada na branch `feat/f1-solicitacao-completa-segura`. Não implantar em produção, não habilitar pagamentos, chat ou despacho.

## Entrega
- Formulário do motociclista com **marca**, **modelo**, **ano**, **descrição**, **endereço protegido**, **foto obrigatória** e **seleção de múltiplos tipos de serviço**.
- Revisão explícita dos dados antes da submissão.
- Foto transformada no navegador por canvas para JPG com até 1600 px e 5 MB, removendo EXIF e metadados embutidos; original de até 8 MB e tipo JPG/PNG/WebP.
- Armazenamento proposto em bucket **privado** `request-photos`, nome `<uid>/<request_key>.jpg`, sem URLs públicas. Clientes autenticados podem ler suas fotos; prestador atribuído pode lê-las para elaborar orçamento; links assinados expiram em 60 segundos.
- Dados do veículo e tipos selecionados persistidos em colunas dedicadas de `service_requests`, preservando idempotência pelo `request_key`.
- Reboque consta na lista para transparência, mas **fica bloqueado** na validação e no banco nesta F1; integração específica em F3 (atualmente cadastro e despacho só atendem `borracharia_delivery`).
- Estado `requested` continua de **teste**. Não altera `payment_records`, comissão, chat, repasse, status financeiros nem prestadores.

## Decisão de infraestrutura: somente um Supabase

- A opção de segundo projeto Free foi **descartada por decisão do responsável pelo Salva Motoca!**. Não criar outro projeto ou branch nem contratar plano Pro.
- Utilizar **GitHub Actions com PostgreSQL 17 descartável** para validar migrações, políticas RLS e compatibilidade com fluxos legados, antes de qualquer mudança ao Supabase existente.
- A migração F1 foi convertida para o padrão de **expansão retrocompatível**: aceitar os pedidos do app atual com os novos campos nulos; aceitar pedidos F1 apenas quando todos os novos campos estiverem preenchidos e a foto existir; rejeitar pedidos parcialmente preenchidos.
- **Não alterar o Supabase ativo nesta etapa.** A mudança real de esquema exigirá revisão de backup, controle de acesso, autorização específica e plano de reversão funcional (flag desligada).
- Não habilitar pagamentos, despacho de socorro, chat ou reboque comercial.

## Ordem obrigatória antes de integrar à `main`
1. Revisar e aprovar a migration `supabase/migrations/20261114013000_f1_solicitacao_dados_foto.sql`, incluindo políticas Storage, RLS, limites e backup. Corrigida na branch após uma versão inválida. A migration **não foi aplicada** no Supabase remoto.
2. **Apenas após uma aprovação específica para modificar o banco existente**, aplicar a migration aditiva no **único Supabase Salva Motoca!**, com backup prévio e registro de estado, mantendo `f1TestRequestsEnabled: false`. Os testes de RLS e compatibilidade já rodam em PostgreSQL 17 descartável no GitHub Actions.
3. Revisar privacidade, retenção, limpeza de fotos órfãs e proteção contra spam/limites de upload.
4. Antes de ligar F1, realizar testes HTTP/E2E com contas fictícias controladas no **único Supabase**, incluindo cliente, prestador designado e terceiro; usar fotos e endereços fictícios, sem publicar serviços reais. Validar duplicações e limpar os dados de teste com cuidado.
5. A migration é **aditiva**: os cinco campos F1 ficam nulos em pedidos legados e devem estar **todos presentes** nos novos pedidos F1. Assim, a versão atual pode continuar funcionando. Após backup e revisão, aplicar a estrutura mantendo a flag F1 desligada; só liberar o formulário após testes de upload, RLS e autenticação no projeto único. Se houver problema, desativar a flag; não remover colunas ou dados automaticamente.
6. Confirmar que o acesso ao endereço exato continua bloqueado antes do pagamento; a foto pode ser vista apenas por cliente e prestador atualmente designado.

## Gate de homologação e proteção contra deploy prematuro

- `config.js` contém `f1TestRequestsEnabled: false` por padrão. O formulário da F1 permanece visível para revisão, porém o envio é desabilitado. A função de submissão verifica novamente essa opção, inclusive se o usuário tentar forçar o evento.
- **Manter `f1TestRequestsEnabled: false` no único projeto**, até a migração aditiva ser aprovada e aplicada com backup, com teste Auth/Storage/RLS real e liberação explícita. Essa é uma trava de interface, não um controle de autorização no banco.
- O cache do PWA (`sw.js`) passou a incluir `request-f1.js` e mudou de versão. Evita que uma instalação antiga use a tela nova com módulo F1 ausente.
- O Supabase ativo continua sem migration F1 e sem bucket de fotos; nenhuma criação ou alteração de recursos remotos ocorreu nesta etapa.
- Antes de ativar pedidos F1, confirmar coerência entre versão do app e a regra **todos ou nenhum** da migration; a criação de pedidos legados continua disponível quando todos os novos campos são nulos.

## Nova bateria de testes da interface com Supabase simulado

O arquivo `tests/f1-app-flow.test.js` executa o código real `live-app-current.js` em um DOM mínimo simulado por Node.js, usando um falso Supabase sem HTTP e sem serviços pagos. Abrange criação de pedido e upload, cancelamento na revisão, falha de upload, falha na inserção e retry sem duplicar foto, proteção contra alteração da foto depois de enviada, rejeição de reboque e bloqueio pelo gate de homologação. Os testes unitários do módulo também rejeitam marca/modelo longos, sem truncar silenciosamente.

**Atenção:** esses testes não exercitam navegadores reais, autenticação HTTP, Storage real, decodificação de imagens com EXIF ou pagamentos. O ensaio PostgreSQL/RLS usa banco descartável; ainda falta teste Auth/Storage real no único Supabase, usando exclusivamente dados de teste após autorização.


## Pré-visualização local segura da F1

O arquivo `docs/F1_PREVIEW.html` apresenta os controles reais planejados, incluindo serviços múltiplos, foto, dados da moto e revisão de um resumo, **sem conectar ao Supabase ou enviar fotos**.

Para abrir localmente, na pasta do projeto execute:

```bash
python3 -m http.server 8080
```

Em seguida, acesse `http://localhost:8080/docs/F1_PREVIEW.html`. Usar apenas dados fictícios. A foto é exibida temporariamente no próprio navegador por URL local; a prévia não cria solicitações, não gera pagamentos e não realiza despacho. O comportamento foi conferido estaticamente e por testes de sintaxe; **ainda falta a revisão visual em navegador/dispositivo real**.

### Resultado dos testes da branch

- `node --test tests/request-f1.test.js tests/f1-app-flow.test.js tests/f1-preview.test.js`: **23/23 aprovados** na execução automatizada.
- `sql-isolado-f1`: migration e ensaio de RLS passaram em PostgreSQL 17 descartável.
- `sw.js`: cache atualizado para conter `request-f1.js`, com verificação de sintaxe pela CI.
- `config.js`: trava `f1TestRequestsEnabled: false`; tentativa forçada de envio é bloqueada pela própria aplicação.
- Nenhuma alteração foi aplicada ao Supabase ativo, nenhuma branch Supabase foi criada e não houve custos novos de infraestrutura autorizados.

## Testes disponíveis
- `node --test tests/request-f1.test.js tests/f1-app-flow.test.js tests/f1-preview.test.js`
- `node --check request-f1.js`
- `node --check live-app-current.js`
- Workflow do GitHub Actions `F1 - testes sem pagamentos`.

## Casos manuais obrigatórios (ainda pendentes)
- Validar campos e múltiplos tipos em Android/desktop; cancelar a revisão sem perder o formulário.
- Selecionar reboque (bloqueio explicativo, sem pedido).
- Foto com dados EXIF: validar arquivo reprocessado e ausência de localização oculta.
- Foto adulterada/maior que 8 MB: rejeição antes de upload; falha de rede no upload e na criação do pedido.
- Upload com identidade A: B não pode ler, listar, baixar nem remover; prestador só pode ler enquanto atribuído; não há acesso público.
- Orçamento do prestador com foto disponível e endereço exato indisponível até pagamento confirmado.
- Recusa de orçamento e troca de prestador, preservando sigilo da foto.
- Logout e reentrada, token expirado, sessão simultânea e duplicação por `request_key`.

## Riscos e limites
- O fluxo F1 depende de bucket privado e migration ainda não homologados.
- Upload anterior à criação do pedido pode deixar foto órfã em falha; prever rotina administrativa de limpeza com janela segura, limites e auditoria.
- O browser ainda não realiza despacho automático, orçamento itemizado ou pagamento; são fases diferentes.
- Antes de liberar ao público, revisar os avisos do Supabase sobre `SECURITY DEFINER` e concluir testes E2E e políticas de dados.

**Não fazer merge automático. Revisão humana necessária.**

## Resultado da revisão e execução isolada

- **Problema corrigido:** migration anterior tinha expressão regular interrompida e trechos SQL duplicados; o arquivo foi reescrito e reaplicado com sucesso no banco PostgreSQL 17 descartável do GitHub Actions.
- **Banco isolado, com fixtures mínimas:** `tests/f1-stage-setup.sql` simula Auth, Storage, prestadores e solicitações; `tests/f1-stage-rls.sql` executa a migration real e confirma que cliente consulta a própria foto, prestador designado recebe acesso, terceiro/anon não consultam, troca de prestador retira acesso anterior e apenas fotos não vinculadas podem ser excluídas.
- **Validação no servidor:** foto existente é verificada por trigger `SECURITY INVOKER` para pedidos F1 completos; pedidos legados sem dados F1 continuam aceitos; pedidos F1 parciais são rejeitados; caminho da foto deve coincidir com ID do cliente e `request_key`.
- **CI:** job `validar-f1` com 11 testes JS e checagem de sintaxe, e job `sql-isolado-f1` com PostgreSQL 17 e RLS, ambos com sucesso na execução inicial de validação da migration.
- **Limitação fundamental:** a conta Supabase vinculada apresenta somente o projeto `Salva Motoca`, sem branch de desenvolvimento existente. Não foi criada infraestrutura que gere cobrança sem autorização. **Não houve teste real HTTP de upload, Auth e Storage Supabase.**
- **Retrabalho evitado no formulário:** proteção contra alteração silenciosa da foto após upload e recuperação de tentativa de upload idempotente quando a primeira resposta falhar; ainda faltam testes E2E de falha real de rede.
- **Segurança remanescente:** revisão de todas as permissões e dos avisos de `SECURITY DEFINER` já existentes no Supabase, testes Android/desktop, limitação de taxa e limpeza de fotos órfãs antes de implantação.

**Próximo gate no projeto único:** backup, revisão humana das políticas e aplicação controlada da migration **aditiva** no Supabase existente, somente após autorização específica. Depois, testes com contas fictícias e ativação da flag F1 apenas quando aprovada. A `main` continua preservada.
