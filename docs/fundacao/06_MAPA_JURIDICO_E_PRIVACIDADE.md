# FND-06 — Mapa jurídico, proteção de dados e conformidade

**Versão 0.1 — roteiro de diligência; não substitui assessoria jurídica ou contábil.**

## Escopo e condição de uso

O Salva Motoca! ainda não tem pessoa jurídica, canais contratuais e provedor financeiro definidos neste caderno. **Não publicar como documentos finais** enquanto não forem preenchidos CNPJ/razão social, contatos oficiais, responsáveis, regras de cobrança, prazos e versão contratual.

A qualificação da plataforma como intermediadora tecnológica não elimina automaticamente eventuais obrigações previstas no Código de Defesa do Consumidor, na legislação de comércio eletrônico ou na LGPD. A definição concreta de responsabilidade exige análise jurídica do modelo operacional real.

## Matriz de conformidade e entregáveis

| Frente | Documentos ou evidências necessários | Status |
| --- | --- | --- |
| Constituição e tributos | Razão social, CNPJ, CNAE(s), enquadramento fiscal, contratos e notas fiscais | Indefinido |
| Consumidor | Termos claros, identificação do fornecedor, preço total, atendimento, cancelamento e reembolso, mediação | Minutas a revisar |
| Prestadores | Contrato de adesão, obrigações, requisitos profissionais, preço, repasse, suspensão e responsabilidade | Minuta a revisar |
| Dados pessoais | Política de privacidade, inventário de dados, bases legais, retenção, atendimento a titulares, contratos com operadores | Parcial |
| Segurança | RLS, teste de acesso, gestão de segredos, revisão de funções privilegiadas, resposta a incidentes | Parcial |
| Financeiro | Contrato com PSP, split, conciliação, disputa, estorno e validação de webhooks | Não iniciado |
| Localização | Limites de finalidade, mínimo compartilhamento, precisão e retenção do endereço de solicitantes | A validar |
| Comunicação e reputação | Regras para avaliações, publicidade, prevenção de fraude e direito de contestação | Pendente |
| Acessibilidade | Fluxos acessíveis, idioma e canal de atendimento | Pendente |
| Propriedade intelectual | Nome, marca, domínio, direitos sobre software e material de parceiros | A verificar |

## Inventário inicial de dados pessoais (sujeito a revisão)

| Categoria | Finalidade proposta | Acesso estritamente necessário |
| --- | --- | --- |
| Conta do solicitante | Autenticação, suporte, histórico | Titular e funções internas autorizadas |
| Conta e documentação do prestador | Homologação, pagamento, segurança | Administração autorizada; nunca catálogo público integral |
| Localização aproximada | Procurar profissionais relevantes | Sistema de descoberta; precisão mínima viável |
| Endereço exato do serviço | Executar atendimento contratado | Solicitante e prestador responsável **somente em estágio autorizado** |
| Propostas, aceite e recusa | Intermediar contratação e auditar decisões | Partes envolvidas e suporte com autorização |
| Mensagens e incidentes | Suporte, resolução de disputas e proteção | Participantes e equipe autorizada |
| Metadados de pagamento | Conciliação e comprovação | Financeiro e suporte com privilégio mínimo |
| Logs de segurança | Prevenção, auditoria e investigação | Equipe autorizada |

**Base legal e prazo:** definir individualmente para cada finalidade e categoria com orientação profissional; não presumir consentimento como base universal nem retenção ilimitada. Dados de localização e comprovantes exigem atenção especial.

## Princípios de desenho

1. Coletar somente dados necessários para o serviço ou obrigação legal aplicável.
2. Não expor números de telefone, GPS exato do cliente ou documentos de validação no mapa.
3. Não compartilhar endereço com profissional antes da etapa legitimamente autorizada.
4. Diferenciar consentimento opcional de dados estritamente necessários ao contrato.
5. Permitir acesso, correção, contestação e solicitações de direitos nos prazos legais.
6. Manter registros mínimos de quem aprovou prestador e decidiu disputas.
7. Não usar base pública de prospecção como cadastro de profissionais aprovados sem contato e autorização.
8. Separar material de teste de dados reais e evitar dados reais no GitHub público.
9. Designar responsável pela proteção de dados e canal de contato, avaliando regras aplicáveis a agentes de pequeno porte.
10. Definir prazo de eliminação ou anonimização e mecanismo de backup seguro.

## Plano de resposta a incidentes

**Detectar** incidente, **conter** acessos indevidos, **registrar** o fato, **avaliar** impacto e categoria de dados, **decidir** comunicações obrigatórias à ANPD e titulares, **corrigir** e **revisar**. O regulamento da ANPD prevê, como regra geral para incidentes de risco ou dano relevante, comunicação pelo controlador em até três dias úteis, com nuances e hipóteses específicas a serem verificadas. Deve haver responsável e procedimento operacional documentado.

## Revisão contratual necessária

- Deveres do prestador na execução do serviço e requisitos de segurança e qualidade.
- Direitos de informação e reparação do consumidor.
- Regras para alterações de orçamento e consentimento expresso para preço adicional.
- Reembolso, atrasos, não comparecimento e serviço não prestado.
- Política de avaliação/reputação e critérios de suspensão com possibilidade de contestação.
- Tributos, documentos fiscais, distribuição dos custos de PSP e repasses.
- Eventuais requisitos técnicos para deslocamento ou atividade específica, conforme modalidade.

## Referências normativas oficiais para revisão

- LGPD — Lei 13.709/2018, texto atualizado: https://www2.camara.leg.br/legin/fed/lei/2018/lei-13709-14-agosto-2018-787077-normaatualizada-pl.html
- Código de Defesa do Consumidor — Lei 8.078/1990: https://www.planalto.gov.br/ccivil_03/leis/l8078compilado.htm
- Marco Civil da Internet — Lei 12.965/2014: https://www.planalto.gov.br/ccivil_03/_ato2011-2014/2014/lei/l12965.htm
- ANPD — comunicação de incidentes: https://www.gov.br/anpd/pt-br/canais_atendimento/agente-de-tratamento/comunicado-de-incidente-de-seguranca-cis
- ANPD — guias e materiais: https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes

**Revisão jurídica humana obrigatória** antes de publicar Termos, Política, Contrato de Prestador ou aceitar operações com valores reais.

## Modalidade de reboque de motocicletas — revisão específica

O reboque já integra o escopo oficial do Salva Motoca!, mas sua disponibilização comercial exige verificar separadamente: requisitos profissionais e documentais de prestadores e veículos, segurança da operação de transporte, responsabilidade por avarias e por carga, condições de origem e destino, restrições de acesso, eventual seguro e regras aplicáveis à atividade.

Do ponto de vista de privacidade, considerar **dois locais protegidos** (origem e destino) e compartilhar somente os dados estritamente necessários com prestador homologado, em etapa autorizada. A integração financeira de reboque deve preservar transparência de preço, confirmação de pagamento e direitos de cancelamento/estorno.

Essa revisão não altera as atuais permissões do banco, não libera cobranças e não equivale a homologação legal.
