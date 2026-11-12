# BorrachaJá! — começar o cadastro dos fornecedores com R$ 0

**Esta etapa ainda não publica o site ou disponibiliza reparos reais.** O objetivo é ter cadastro de usuários e uma lista privada dos fornecedores potenciais em um banco de teste gratuito.

1. Crie ou acesse seu projeto gratuito em https://supabase.com/dashboard.
2. Se for um projeto novo, no **SQL Editor**, rode primeiro `supabase/schema.sql` e depois `supabase/02_fornecedores_potenciais.sql` (uma vez cada, na ordem indicada).
3. Encontre a **Project URL** e a **publishable key** no painel Supabase. Copie-as para `config.js`. **Nunca coloque `service_role`, `secret` ou senha do banco nesse arquivo.**
4. Abra o PWA em um servidor local (`python3 -m http.server 8080`), crie sua conta e siga o `README.md` para torná-la administradora.
5. Em **Perfil → Administração → Fornecedores potenciais**, use o modelo `fornecedores_candidatos_exemplo.csv`. Acrescente os demais prestadores da sua lista, indique borracharia, delivery e/ou reboque e importe o CSV.
6. Verifique dados reais com cada prestador; ele deve criar sua própria conta e ser aprovado antes de aparecer no mapa. Para usar em celulares de pessoas diferentes será necessário hospedar o site em HTTPS e configurar as URLs de autenticação do Supabase.

### O que já está preparado

- CSV importável no painel administrativo, até 200 linhas por arquivo;
- cadastro manual e estados de prospecção;
- tabela privada com acesso somente de administradores (RLS);
- categorias múltiplas, sem ativar o serviço de reboque nesta fase;
- cadastros não verificados separados do mapa e dos pedidos;
- orçamento, pagamento e comissões **ainda não operacionais**.

### O que ainda depende de você

Criar o projeto Supabase e fornecer a configuração **pública** (Project URL e publishable key) ao código. Sem isso, o aplicativo segue em demonstração, e esta nova área administrativa não estará ativa. **Não compartilhe senha, token de serviço, chave secreta ou credenciais financeiras.**

Para detalhes técnicos e testes, veja `README.md`.