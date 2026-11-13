# BorrachaJá! Oficial — Especificação de referência

**Nome oficial:** BorrachaJá!

**Proposta:** conectar motociclistas a borracharias e borracheiros delivery, em formato de marketplace (modelo semelhante ao de um aplicativo de delivery).

## Acesso gratuito

O aplicativo e a consulta ao mapa de borracharias são gratuitos. O usuário pode localizar estabelecimentos, conferir informações disponíveis e obter rota até o local. A ida direta ao estabelecimento não gera comissão para a plataforma.

## Delivery intermediado

**Somente o atendimento de borracheiro no local é cobrado pelo aplicativo**. O mapa permanece gratuito e a plataforma não cobra comissão por visitas presenciais. A hipótese comercial atual de comissão do delivery é de 15%, a validar com os prestadores.

**Reboque de motos:** poderá ser avaliado em uma expansão futura. Não está incluído nas cobranças nem no despacho ativo do MVP.

O cliente pode escolher um profissional ou solicitar busca automática. O profissional informa um orçamento, o cliente aceita e paga por meio do aplicativo. A divisão financeira e os repasses dependem de integração homologada com um provedor de pagamentos. Nesta fase, os pagamentos reais estão desativados.

## Comunicação

Telefones e links externos não são exibidos nos perfis. Chamados delivery usam fluxos de orçamento e comunicação interna. Informações de segurança e suporte permanecem acessíveis conforme necessidade.

## Profissionais e administração

Os prestadores se cadastram e passam por verificação antes de aparecerem como ativos. O administrador gerencia solicitações e aprovações. Dados de contato administrativo e registros privados não pertencem a este repositório público.

## Política de desenvolvimento

O projeto está em fase de MVP; deve usar planos gratuitos quando possível, sem afirmar disponibilidade comercial ou atendimento de emergência antes de testes completos.

## Próximas etapas

1. Testar contas separadas de motociclista e prestador no Supabase `BorrachaJa`.
2. Homologar manualmente prestadores reais antes de exibi-los no mapa.
3. Implementar aceite de orçamento, gestão segura de estados e antifraude.
4. Homologar pagamentos e split automático exclusivamente para borracharia delivery.
5. Publicar apenas após testes operacionais, legais e de segurança.
