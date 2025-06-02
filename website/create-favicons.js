#!/usr/bin/env node

// Script para criar favicons a partir do logo SVG
// Para executar: node create-favicons.js

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// SVG otimizado para favicon (32x32)
const faviconSVG = `<svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Shield with gradient -->
  <path d="M16 4 L23 7 L23 15 C23 20, 19 24, 16 25 C13 24, 9 20, 9 15 L9 7 Z" 
        fill="url(#skyBlueGradient)" opacity="0.9"/>
  
  <!-- Lock icon in center -->
  <g transform="translate(16, 13)">
    <rect x="-2.5" y="-0.8" width="5" height="4" rx="0.8" fill="#0369a1"/>
    <path d="M-1.5 -0.8 L-1.5 -2 A 1.5 1.5 0 0 1 1.5 -2 L1.5 -0.8" stroke="#0ea5e9" stroke-width="0.8" fill="none"/>
    <circle cx="0" cy="1.2" r="0.6" fill="#0ea5e9"/>
  </g>
  
  <!-- Code brackets -->
  <text x="6.5" y="22" fill="#0ea5e9" font-size="3.5" font-family="monospace" font-weight="bold">&lt;/&gt;</text>
  
  <!-- AI sparkle -->
  <g transform="translate(23, 5)">
    <path d="M0 1.5 L0.8 0 L1.5 1.5 L3 2.2 L1.5 3 L0.8 4.5 L0 3 L-1.5 2.2 Z" fill="#38bdf8" opacity="0.9"/>
  </g>
  
  <!-- Check mark circle -->
  <circle cx="24" cy="21" r="2" fill="#0ea5e9"/>
  <path d="M22.5 21 L23 21.5 L25.5 19" stroke="white" stroke-width="0.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
  
  <defs>
    <linearGradient id="skyBlueGradient" x1="9" y1="4" x2="23" y2="25">
      <stop offset="0%" stop-color="#e0f2fe"/>
      <stop offset="50%" stop-color="#7dd3fc"/>
      <stop offset="100%" stop-color="#0284c7"/>
    </linearGradient>
  </defs>
</svg>`;

// Criar diretório public se não existir
const publicDir = path.join(__dirname, 'public');
if (!fs.existsSync(publicDir)) {
  fs.mkdirSync(publicDir);
}

// Salvar SVG favicon
fs.writeFileSync(path.join(publicDir, 'favicon.svg'), faviconSVG);

// Criar um favicon.ico simples (base64 encoded PNG)
const simpleFaviconICO = 'AAABAAEAEBAAAAEAIABoBAAAFgAAACgAAAAQAAAAIAAAAAEAIAAAAAAAAAQAABILAAASCwAAAAAAAAAAAAD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A////AP///wD///8A7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+/v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+//7+/v/+/v7//v7+/8AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD+AAAA/gAAAP4AAAD/AAAA/wAAAP8AAAD/AAAA/wAAAP8AAAD/AAAA';

// Decodificar base64 e salvar como favicon.ico
const buffer = Buffer.from(simpleFaviconICO, 'base64');
fs.writeFileSync(path.join(publicDir, 'favicon.ico'), buffer);

console.log('✅ Favicons criados:');
console.log('   - public/favicon.svg (moderno)');
console.log('   - public/favicon.ico (compatibilidade)');
console.log('\n🚀 Para executar no navegador, abra: generate-favicon.html');