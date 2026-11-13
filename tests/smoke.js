// Teste offline do primeiro render do modo conectado com Supabase simulado.
// Não substitui testes de integração no projeto real nem testes de políticas RLS.
const fs=require('node:fs');
const vm=require('node:vm');
const assert=require('node:assert/strict');
const elems={};
const create=(id)=>elems[id]||=( {innerHTML:'',textContent:'',classList:{toggle(){}},addEventListener(){},setAttribute(){}} );
const app=create('#app');
const doc={getElementById(id){return create('#'+id);},querySelector(s){return create(s);},querySelectorAll(){return [create('.topbar'),create('.bottom-nav')];}};
const db={
 auth:{getSession:async()=>({data:{session:null},error:null}),onAuthStateChange(){},signOut:async()=>({error:null})},
 rpc:async(name)=> {assert.equal(name,'bj_find_providers');return {data:[],error:null};},
 from(){throw Error('Sem sessão, a busca pública não deve consultar tabelas privadas.');}
};
const context={
 window:{BJ_CONFIG:{supabaseUrl:'https://exemplo.supabase.co',supabasePublishableKey:'sb_publishable_teste'},
   supabase:{createClient(){return db;}}, addEventListener(){}},
 document:doc,navigator:{},location:{protocol:'http:',hostname:'invalido.test'},
 console, setTimeout, clearTimeout, confirm(){return false;}, Date, Intl
};
vm.runInNewContext(fs.readFileSync(require('node:path').join(__dirname,'../live-app.js'),'utf8'),context);
setTimeout(()=>{
  try{
    assert.match(app.innerHTML,/Pneu furou\?/);
    assert.match(app.innerHTML,/0<\/strong>/);
    assert.match(doc.querySelector('.demo-banner').innerHTML,/Piloto conectado/);
    console.log('OK: modo conectado inicializa sem sessão, exibe mapa gratuito e não consulta dados privados.');
  }catch(err){console.error(err);process.exitCode=1;}
},30);