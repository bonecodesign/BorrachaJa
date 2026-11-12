(() => {
  const cfg = window.BJ_CONFIG || {};
  const configured = /^https:\/\/[^\s/]+\.supabase\.co\/?$/.test(String(cfg.supabaseUrl || '').trim()) &&
    String(cfg.supabasePublishableKey || '').startsWith('sb_publishable_');
  const load = (url, onload) => {
    const script = document.createElement('script');
    script.src = url;
    script.onload = onload || null;
    script.onerror = () => {
      document.getElementById('app').innerHTML = '<div class="notice bad">Não foi possível iniciar o aplicativo. Verifique a rede e os arquivos.</div>';
    };
    document.body.appendChild(script);
  };
  if (configured) {
    // SDK fixado na versão 2.119.0, sem dependências pagas.
    load('https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.119.0', () => load('./live-app-current.js'));
  } else {
    load('./app.js'); // Somente demonstração local, quando não houver projeto configurado.
  }
})();