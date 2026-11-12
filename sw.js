const CACHE = 'borrachaja-static-v3';
const ASSETS = ['./', './index.html','./app.js','./bootstrap.js','./live-app.js','./supplier-import.js','./fornecedores_candidatos_exemplo.csv','./styles.css','./manifest.webmanifest','./assets/icon-192.png','./assets/icon-512.png'];
self.addEventListener('install', (event) => event.waitUntil(caches.open(CACHE).then((c) => c.addAll(ASSETS)).then(()=>self.skipWaiting())));
self.addEventListener('activate', (event) => event.waitUntil(caches.keys().then((keys) => Promise.all(keys.filter((key)=>key.startsWith('borrachaja-')&&key!==CACHE).map((key)=>caches.delete(key)))).then(()=>self.clients.claim())));
self.addEventListener('fetch',(event)=>{
 if(event.request.method !== 'GET' || new URL(event.request.url).origin !== self.location.origin) return;
 event.respondWith(fetch(event.request).then((res)=>{
   if(res.ok) { const copy=res.clone(); caches.open(CACHE).then((cache)=>cache.put(event.request,copy)).catch(()=>{}); }
   return res;
 }).catch(()=>caches.match(event.request)));
});