/* F1 — prévia real no Google Chrome/Chromium (desktop e viewport de celular).
 * Sem conexão com Supabase. Não cria pedidos, pagamentos ou despachos.
 * Rode: node --test tests/f1-browser.test.js
 * Requer playwright-core pinado pelo job e Chrome/Chromium instalado.
 */
"use strict";
const test = require("node:test");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const { pathToFileURL } = require("node:url");
const { chromium } = require("playwright-core");

const PAGE = pathToFileURL(path.join(__dirname, "../docs/F1_PREVIEW.html")).href;
const executablePath = process.env.CHROME_BIN || [
  "/usr/bin/google-chrome", "/usr/bin/google-chrome-stable",
  "/usr/bin/chromium", "/usr/bin/chromium-browser"
].find(file => fs.existsSync(file));

// PNG 1 x 1, fictício; os bytes não contêm metadados de localização.
const png = Buffer.from(
  "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/RZ8AAAAASUVORK5CYII=",
  "base64"
);

async function visit(viewport) {
  assert.ok(executablePath, "Chrome/Chromium nao foi encontrado no runner");
  const browser = await chromium.launch({
    executablePath, headless: true, args: ["--no-sandbox", "--disable-dev-shm-usage"]
  });
  const page = await browser.newPage({ viewport });
  const external = [];
  page.on("request", request => {
    if (/^https?:/i.test(request.url())) external.push(request.url());
  });
  await page.route(/^https?:\/\//, route => route.abort());
  await page.goto(PAGE);
  return { browser, page, external };
}

async function fillRequest(page, services) {
  for (const value of services) await page.locator(`input[name="services"][value="${value}"]`).check();
  await page.locator('input[name="brand"]').fill("Honda");
  await page.locator('input[name="model"]').fill("CG 160");
  await page.locator('input[name="year"]').fill("2024");
  await page.locator('textarea[name="problem"]').fill("O pneu traseiro furou.");
  await page.locator('textarea[name="address"]').fill("Rua de Testes, 123");
  await page.locator('input[name="photo"]').setInputFiles({
    name: "problema.png", mimeType: "image/png", buffer: png
  });
  await page.locator('button[type="submit"]').click();
  return page.locator("#f1-preview-status");
}

test("Chrome desktop: formulário real valida serviços múltiplos, mostra foto e não envia dados", async () => {
  const { browser, page, external } = await visit({ width: 1280, height: 800 });
  try {
    const status = await fillRequest(page, ["pneu_furado", "troca_camara"]);
    await status.getByText(/Dados válidos para simulação/).waitFor();
    const message = await status.textContent();
    assert.match(message, /Honda CG 160 \(2024\)/);
    assert.match(message, /Foto selecionada: problema.png/);
    assert.match(message, /Nenhuma informação foi transmitida/);
    assert.equal(await page.locator("#f1-preview-image").isVisible(), true);
    assert.deepEqual(external, [], "A prévia tentou chamar serviço externo");
  } finally {
    await browser.close();
  }
});

test("Chrome com viewport móvel: reboque bloqueado e interface sem rolagem horizontal", async () => {
  const { browser, page, external } = await visit({ width: 375, height: 812 });
  try {
    const status = await fillRequest(page, ["pneu_furado", "reboque_moto"]);
    await status.getByText(/Reboque será liberado/).waitFor();
    const width = await page.evaluate(() => document.documentElement.scrollWidth);
    assert.ok(width <= 375, `Rolagem horizontal indevida: ${width}px`);
    assert.deepEqual(external, [], "A prévia tentou chamar serviço externo");
  } finally {
    await browser.close();
  }
});

test("Chrome desktop: foto de formato não permitido é recusada pela validação", async () => {
  const { browser, page } = await visit({ width: 1280, height: 800 });
  try {
    await page.locator('input[name="services"][value="pneu_furado"]').check();
    await page.locator('input[name="brand"]').fill("Honda");
    await page.locator('input[name="model"]').fill("CG 160");
    await page.locator('input[name="year"]').fill("2024");
    await page.locator('textarea[name="problem"]').fill("O pneu traseiro furou.");
    await page.locator('textarea[name="address"]').fill("Rua de Testes, 123");
    await page.locator('input[name="photo"]').setInputFiles({
      name: "falso.svg", mimeType: "image/svg+xml",
      buffer: Buffer.from("<svg xmlns='http://www.w3.org/2000/svg'/>")
    });
    await page.locator('button[type="submit"]').click();
    await page.locator("#f1-preview-status").getByText(/JPG, PNG ou WebP/).waitFor();
  } finally {
    await browser.close();
  }
});
