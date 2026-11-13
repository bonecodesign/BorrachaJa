# Salva Motoca! Oficial

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

## Estado do piloto conectado

O Supabase **Salva Motoca** possui o banco real e o MVP usa as tabelas atuais para autenticação, cadastros pendentes, pedidos e orçamentos de **teste**.

- Consulte [docs/INTEGRACAO_SUPABASE.md](docs/INTEGRACAO_SUPABASE.md) antes de qualquer mudança no banco.
- O endereço do pedido permanece protegido até a confirmação de pagamento real, que ainda não existe neste MVP.
- O app segue **não publicado**, sem pagamentos reais, sem atendimento garantido e sem despacho operacional.
- Os fornecedores de prospecção não são prestadores homologados; seu cadastro privado não é publicado.

### Disponibilidade e orçamentos

O prestador aprovado pode ficar **online** ou **offline**; a presença exige comunicação recente com o servidor. Ele informa o orçamento e o cliente decide aceitar ou recusar.

Na mesma solicitação, a primeira recusa mantém o prestador elegível para uma oportunidade futura; a segunda recusa do mesmo solicitante o exclui daquela rodada. Encerrar a solicitação e criar outra reinicia a contagem.

Aceitar o orçamento **não realiza pagamento**. A integração financeira permanece futura.

## Organização

O banco está criado no Supabase `Salva Motoca`, com tabelas operacionais, prospecção privada, RLS e migrações versionadas. O código do aplicativo e os testes de MVP estão nesta base; pagamentos e operação comercial ainda exigem homologação.

Consulte [supabase/README.md](supabase/README.md) para regras de versionamento e [docs/PRODUTO_OFICIAL.md](docs/PRODUTO_OFICIAL.md) para a especificação vigente.

**Não inserir** senhas, tokens, chaves secretas, documentos pessoais, telefones internos de fornecedores nem dados reais de clientes no GitHub.
