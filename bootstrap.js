(() => {
  const cfg = window.BJ_CONFIG || {};
  const configured = /^https:\/\/[^\s/]+\.supabase\.co\/?$/.test(String(cfg.supabaseUrl || '').trim()) &&
    String(cfg.supabasePublishableKey || '').trim().length > 20;
  const load = (url, onload) => {
    const script = document.createElement('script');
    script.src = url;
    script.onload = onload || null;
    script.onerror = () => {
      document.getElementById('app').innerHTML = '<div class="notice bad">Não foi possível iniciar o aplicativo. Confira a rede e os arquivos.</div>';
    };
    document.body.appendChild(script);
  };
  if (configured) {
    load('https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2', () => load('./supplier-import.js', () => load('./live-app.js')));
  } else {
    load('./app.js'); // Demonstração local, independente de Supabase.
  }
})();