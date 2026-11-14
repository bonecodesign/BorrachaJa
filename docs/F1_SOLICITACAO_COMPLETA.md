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

## Ordem obrigatória antes de integrar à `main`
1. Revisar e aprovar a migration `supabase/migrations/20261114013000_f1_solicitacao_dados_foto.sql`, incluindo políticas Storage, RLS, limites e backup. Corrigida na branch após uma versão inválida. A migration **não foi aplicada** no Supabase remoto.
2. Aplicá-la em um **Supabase de homologação separado**, não diretamente no banco ativo; executar testes HTTP com Auth real, cliente, prestador designado e terceiro. O ensaio em PostgreSQL 17 isolado já foi realizado, mas não substitui esta etapa.
3. Revisar privacidade, retenção, limpeza de fotos órfãs e proteção contra spam/limites de upload.
4. Rodar testes HTTP/E2E com 2 contas e dispositivo real antes de aceitar deploy; validar requisições duplicadas após falha de rede.
5. Promover a migration aprovada em janela controlada **antes** de publicar a versão que consulta as colunas novas. Atenção: as cinco colunas F1 são `NOT NULL` e o servidor exige foto existente; a versão antiga do formulário também não poderá criar pedidos depois da migration. Fazer virada coordenada, com janela de indisponibilidade controlada se necessário; não liberar parcialmente.
6. Confirmar que o acesso ao endereço exato continua bloqueado antes do pagamento; a foto pode ser vista apenas por cliente e prestador atualmente designado.

## Testes disponíveis
- `node --test tests/request-f1.test.js`
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
- **Validação no servidor:** foto existente é verificada por trigger `SECURITY INVOKER`; os campos F1 são obrigatórios; caminho da foto deve coincidir com o ID do cliente e o `request_key`.
- **CI:** job `validar-f1` com 11 testes JS e checagem de sintaxe, e job `sql-isolado-f1` com PostgreSQL 17 e RLS, ambos com sucesso na execução inicial de validação da migration.
- **Limitação fundamental:** a conta Supabase vinculada apresenta somente o projeto `Salva Motoca`, sem branch de desenvolvimento existente. Não foi criada infraestrutura que gere cobrança sem autorização. **Não houve teste real HTTP de upload, Auth e Storage Supabase.**
- **Retrabalho evitado no formulário:** proteção contra alteração silenciosa da foto após upload e recuperação de tentativa de upload idempotente quando a primeira resposta falhar; ainda faltam testes E2E de falha real de rede.
- **Segurança remanescente:** revisão de todas as permissões e dos avisos de `SECURITY DEFINER` já existentes no Supabase, testes Android/desktop, limitação de taxa e limpeza de fotos órfãs antes de implantação.

**Próximo gate:** executar esta migration e o aplicativo F1 em um Supabase de homologação independente, com contas de teste consentidas e sem dados reais. O PostgreSQL descartável é ensaio de banco, não homologação operacional. A `main` continua preservada.
