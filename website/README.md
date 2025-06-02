# 🛡️ Secure Code AI Website

Landing page para o workshop **Secure Code AI Development** com design sky-blue e deploy automático via GitHub Actions.

## 🚀 Deploy Automático

**O site é automaticamente publicado via GitHub Actions para GitHub Pages!**

- **URL do Site**: https://paulasilvatech.github.io/Secure-Code-AI-Dev/
- **Deploy automático** a cada push na pasta `website/`
- **Configuração**: Ver [DEPLOY.md](./DEPLOY.md)

## 💻 Desenvolvimento Local

```bash
# Instalar dependências
npm install

# Desenvolvimento (localhost:5173)
npm run dev

# Build para produção
npm run build

# Preview do build
npm run preview
```

## 🛠️ Tecnologias

- **React 18** + TypeScript
- **Vite** (build tool moderno)
- **Tailwind CSS** (estilização)
- **Lucide React** (ícones)
- **GitHub Actions** (CI/CD)
- **GitHub Pages** (hosting)

## 📁 Estrutura

```
website/
├── secure-code-landing-skyblue.tsx  # Landing page principal
├── secure-code-logo.tsx             # Componente de logo
├── src/                             # Arquivos fonte
│   ├── main.tsx                     # Entry point
│   └── index.css                    # Estilos globais
├── dist/                            # Build de produção
├── package.json                     # Dependências
└── DEPLOY.md                        # Guia de deploy
```

## 🎨 Design

- **Tema**: Sky Blue gradient
- **Componentes**: Seções modernas com animações
- **Responsivo**: Mobile-first design
- **Performance**: Otimizado para produção