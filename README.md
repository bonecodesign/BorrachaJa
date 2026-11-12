# BorrachaJá! Oficial

Marketplace de borracharia delivery para motociclistas e motoboys.

> **Status: MVP em desenvolvimento — não utilizar para solicitar atendimentos reais ou emergenciais.** O sistema ainda não processa pagamentos nem garante disponibilidade de profissionais.

## Produto oficial

- Aplicativo gratuito e mapa de borracharias gratuito.
- Atendimento de borracheiro no local mediante orçamento e pagamento na plataforma.
- Escolha do profissional ou busca automática por proximidade/disponibilidade.
- Comunicação dentro do aplicativo, sem divulgação pública de telefone/WhatsApp.
- Comissão da plataforma sobre atendimentos delivery pagos.
- Cadastro e verificação dos prestadores antes de aparecerem no mapa.
- Desenvolvimento priorizando ferramentas gratuitas e custos iniciais mínimos.

## Organização

O código-fonte do MVP demonstrativo, o esquema do banco de dados e os testes serão importados após revisão e preparação do repositório.

**Não inserir** senhas, tokens, chaves secretas, documentos pessoais, telefones internos de fornecedores nem dados reais de clientes no GitHub.

Consulte [docs/PRODUTO_OFICIAL.md](docs/PRODUTO_OFICIAL.md) para as regras atuais do produto.

## Estado do piloto conectado (12/11/2026)

O Supabase **BorrachaJa** já possui banco real com esquema diferente do SQL legado. A branch de desenvolvimento inclui `live-app-current.js`, que consulta as tabelas existentes, autentica contas, recebe cadastros pendentes e permite pedidos e orçamentos apenas de **teste**.

- Consulte `docs/INTEGRACAO_SUPABASE.md` antes de qualquer mudança de banco.
- A proteção do endereço do pedido foi reforçada no Supabase e registrada em `supabase/applied/`.
- O app continua **não publicado**, sem pagamentos reais, sem atendimento garantido e sem despacho operacional.
- Os fornecedores de prospecção não são prestadores homologados; seu cadastro privado não é publicado.

