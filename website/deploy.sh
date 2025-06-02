#!/bin/bash

# Script de deploy para GitHub Pages

echo "🚀 Iniciando deploy do website..."

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    echo "❌ Erro: Execute este script no diretório website/"
    exit 1
fi

# Instalar dependências
echo "📦 Instalando dependências..."
npm install

# Build do projeto
echo "🔨 Buildando projeto..."
npm run build

# Verificar se o build foi bem-sucedido
if [ $? -eq 0 ]; then
    echo "✅ Build concluído com sucesso!"
    echo "📁 Arquivos gerados em: ./dist/"
    echo ""
    echo "Para deploy manual no GitHub Pages:"
    echo "1. Ative GitHub Pages nas configurações do repositório"
    echo "2. Configure source como 'GitHub Actions'"
    echo "3. Faça push das mudanças - o deploy será automático"
    echo ""
    echo "Para testar localmente:"
    echo "npm run preview"
else
    echo "❌ Erro no build"
    exit 1
fi