# BorrachaJá! Oficial

Marketplace de borracharias, borracharia delivery e reboque de motos para motociclistas e motoboys. **Operação inicial: Belo Horizonte e região metropolitana de MG.**

> **Status: MVP em desenvolvimento — não utilizar para solicitar atendimentos reais ou emergenciais.** O sistema ainda não processa pagamentos nem garante disponibilidade de profissionais.

## Produto oficial

- Aplicativo gratuito e mapa de borracharias gratuito.
- Atendimento de borracheiro no local e reboque de motos mediante orçamento e pagamento na plataforma.
- Escolha do profissional ou busca automática por proximidade/disponibilidade.
- Comunicação dentro do aplicativo, sem divulgação pública de telefone/WhatsApp.
- Comissão de **15%** da plataforma sobre serviços delivery e reboque pagos. Consultar o mapa e ir diretamente à borracharia é gratuito, sem comissão.
- Cadastro e verificação dos prestadores antes de aparecerem no mapa.
- Desenvolvimento priorizando ferramentas gratuitas e custos iniciais mínimos.

## Organização

O banco inicial está criado no Supabase `BorrachaJa-Oficial`, com **8 tabelas**, RLS e migrações versionadas em `supabase/migrations/`. O código do aplicativo, os testes e a integração de pagamentos ainda serão desenvolvidos e homologados.

Consulte [supabase/README.md](supabase/README.md) para detalhes técnicos e regras de versionamento. **A sincronização automática GitHub ↔ Supabase ainda não está configurada**.

**Não inserir** senhas, tokens, chaves secretas, documentos pessoais, telefones internos de fornecedores nem dados reais de clientes no GitHub.

Consulte [docs/PRODUTO_OFICIAL.md](docs/PRODUTO_OFICIAL.md) para as regras atuais do produto.
