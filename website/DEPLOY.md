# 🚀 Deploy via GitHub Actions para GitHub Pages

## Configuração Inicial (uma vez apenas)

### 1. Ativar GitHub Pages no repositório:
1. Vá em **Settings** > **Pages**
2. Em **Source**, selecione **GitHub Actions**
3. Salve as configurações

### 2. Verificar permissões:
1. Vá em **Settings** > **Actions** > **General**
2. Em **Workflow permissions**, marque **Read and write permissions**
3. Salve as configurações

## Deploy Automático

### O deploy acontece automaticamente quando:
- ✅ Push na branch `main`
- ✅ Mudanças na pasta `website/`
- ✅ Ou execução manual via **Actions** tab

### Processo automático:
1. **Build**: Instala dependências e gera build otimizado
2. **Deploy**: Publica no GitHub Pages
3. **URL**: Disponível em `https://paulasilvatech.github.io/Secure-Code-AI-Dev/`

## Deploy Manual

### Via GitHub Interface:
1. Vá na aba **Actions**
2. Selecione **Deploy Website to GitHub Pages**
3. Clique em **Run workflow**
4. Selecione branch `main`
5. Clique em **Run workflow**

### Via Commit:
```bash
# Fazer mudanças na pasta website/
git add website/
git commit -m "Update website"
git push origin main
```

## Monitoramento

### Verificar status do deploy:
1. Aba **Actions** - ver progresso em tempo real
2. **Settings** > **Pages** - ver URL do site
3. Logs detalhados de build e deploy

### URLs importantes:
- **Repositório**: https://github.com/paulasilvatech/Secure-Code-AI-Dev
- **Website**: https://paulasilvatech.github.io/Secure-Code-AI-Dev/
- **Actions**: https://github.com/paulasilvatech/Secure-Code-AI-Dev/actions

## Desenvolvimento Local

```bash
cd website
npm install
npm run dev    # http://localhost:5173/Secure-Code-AI-Dev/
npm run build  # Testar build
```

## Troubleshooting

### Se o deploy falhar:
1. Verificar logs na aba **Actions**
2. Conferir se GitHub Pages está ativado
3. Verificar permissões de workflow
4. Testar build local com `npm run build`