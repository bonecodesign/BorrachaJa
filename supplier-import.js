/* BorrachaJá! — parser e normalizador de CSV para leads. Sem enviar dados a terceiros. */
(function (root) {
  'use strict';
  function parseCsv(input) {
    const s = String(input || '').replace(/^\uFEFF/, '');
    const first = s.split(/\r?\n/, 1)[0] || '';
    const delimiter = (first.match(/;/g) || []).length >= (first.match(/,/g) || []).length ? ';' : ',';
    const rows = []; let row = [], field = '', quote = false;
    for (let i = 0; i < s.length; i++) {
      const c = s[i];
      if (c === '"') {
        if (quote && s[i + 1] === '"') { field += '"'; i++; }
        else if (!field.length || quote) quote = !quote;
        else field += c;
      } else if (c === delimiter && !quote) { row.push(field); field = ''; }
      else if ((c === '\n' || c === '\r') && !quote) {
        if (c === '\r' && s[i + 1] === '\n') i++;
        row.push(field);
        if (row.some(x => x.trim())) rows.push(row);
        row = []; field = '';
      } else field += c;
    }
    if (quote) throw new Error('CSV inválido: campo entre aspas não foi fechado.');
    row.push(field); if (row.some(x => x.trim())) rows.push(row);
    if (rows.length < 2) throw new Error('CSV precisa ter cabeçalho e ao menos um fornecedor.');
    const head = rows.shift().map(x => x.trim().toLowerCase().normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '').replace(/[\s-]+/g, '_'));
    if (!head.includes('nome')) throw new Error('CSV sem coluna obrigatória "nome".');
    if (rows.length > 200) throw new Error('Importe até 200 fornecedores por arquivo.');
    return rows.map((cols, rowIdx) => {
      if (cols.length > head.length) throw new Error(`Linha ${rowIdx + 2}: número de colunas inválido.`);
      const x = {}; head.forEach((k, i) => { x[k] = (cols[i] || '').trim(); });
      return x;
    });
  }
  function yes(value) { return /^(1|true|sim|s|yes|x)$/i.test(String(value || '').trim()); }
  function keyForLead(name, city, hood) {
    return ('lead-' + [name, city, hood].join('-').normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '').toLowerCase().replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '').slice(0, 168)).slice(0, 180);
  }
  function normalize(raw) {
    const business_name = String(raw.nome || '').trim();
    const neighborhood = String(raw.bairro || '').trim();
    const city = String(raw.cidade || 'Belo Horizonte').trim();
    const offers_workshop = yes(raw.borracharia);
    const offers_delivery = yes(raw.delivery);
    const offers_tow = yes(raw.reboque);
    const source_note = String(raw.origem || 'Lista preliminar').trim();
    const contact_private = String(raw.contato_administrativo || '').trim();
    const notes = String(raw.observacoes || '').trim();
    if (business_name.length < 3 || business_name.length > 120) throw new Error(`Nome inválido: ${business_name.slice(0, 35) || '(vazio)'}`);
    if (!offers_workshop && !offers_delivery && !offers_tow) throw new Error(`Marque ao menos uma categoria para ${business_name}.`);
    if (neighborhood.length > 100 || city.length < 2 || city.length > 100 || source_note.length > 250 || contact_private.length > 250 || notes.length > 700)
      throw new Error(`Campos muito longos para ${business_name}.`);
    return { source_key:keyForLead(business_name,city,neighborhood), business_name, neighborhood, city,
      offers_workshop, offers_delivery, offers_tow, source_note, contact_private, notes, status:'prospect' };
  }
  function loadCsv(source) {
    const records = parseCsv(source).map((record, i) => {try { return normalize(record); }
      catch(err) { throw new Error(`Linha ${i + 2}: ${err.message}`); }});
    if (new Set(records.map(r => r.source_key)).size !== records.length)
      throw new Error('O arquivo contém fornecedores duplicados pelo nome, bairro e cidade. Revise antes de importar.');
    return records;
  }
  root.BJ_SUPPLIERS = {parseCsv, normalize, keyForLead, loadCsv};
  if (typeof module !== 'undefined' && module.exports) module.exports = root.BJ_SUPPLIERS;
})(typeof window === 'undefined' ? globalThis : window);