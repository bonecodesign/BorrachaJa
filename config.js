// Configuração PÚBLICA do piloto Salva Motoca!: URL e publishable key.
// A chave publishable NÃO é secret/service_role; as permissões dependem do RLS.
// JAMAIS inserir senhas, service_role ou sb_secret_* neste arquivo.
window.BJ_CONFIG = {
  supabaseUrl: 'https://yivkqyjdeouxnwtwfekc.supabase.co',
  // F1 bloqueada ate homologacao de Storage, RLS e schema num ambiente separado.
  // Ativar apenas na configuracao do ambiente de homologacao, nunca neste piloto ativo.
  f1TestRequestsEnabled: false,
  supabasePublishableKey: 'sb_publishable_SKToaitJDdgDAYUrwChkbg__ntPtZd3'
};