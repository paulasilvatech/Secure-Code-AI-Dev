# 🚀 Quick Start Guide

Get started with the Secure Code AI Development Workshop in just 30 minutes! This guide will help you set up your environment and complete your first security scan.

## ⚡ Prerequisites Checklist

Before starting, ensure you have:

- [ ] GitHub account with [GitHub Advanced Security](https://github.com/features/security) access
- [ ] [Azure free account](https://azure.microsoft.com/free/) created
- [ ] [VS Code](https://code.visualstudio.com/) installed
- [ ] [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [ ] [GitHub Copilot](https://github.com/features/copilot) subscription active
- [ ] Terminal/Command Prompt access

## 🏃‍♀️ 5-Minute Setup

### Step 1: Clone the Repository

```bash
# Clone the workshop repository
git clone https://github.com/paulasilvatech/Secure-Code-AI-Dev.git
cd Secure-Code-AI-Dev

# Create your own branch
git checkout -b my-workshop-progress
```

### Step 2: Run the Quick Setup Script

```bash
# Make the script executable (macOS/Linux)
chmod +x scripts/quick-setup.sh

# Run the quick setup
./scripts/quick-setup.sh
```

For Windows users:
```powershell
# Run in PowerShell as Administrator
.\scripts\quick-setup.ps1
```

### Step 3: Verify Installation

```bash
# Run verification script
./scripts/verify-setup.sh
```

You should see all green checkmarks ✅ for required tools.

## 🎯 Your First Security Scan (10 minutes)

### 1. Create a Sample Vulnerable Application

```bash
# Navigate to templates directory
cd templates/vulnerable-app

# Install dependencies
npm install

# Run initial security scan
npm audit
```

### 2. Enable GitHub Advanced Security

```bash
# Push to GitHub
git add .
git commit -m "Initial vulnerable app"
git push origin my-workshop-progress

# Enable GHAS in your repository settings
# Go to: Settings > Security & Analysis > Enable all
```

### 3. Fix Your First Vulnerability with AI

Open VS Code and use GitHub Copilot:

```javascript
// Type this comment in app.js
// fix the SQL injection vulnerability in the login function

// Copilot will suggest secure code
```

## 📚 Quick Module Overview

Here's what you'll learn in each of the 10 modules:

### Core Security (Modules 1-3)
1. **[Shift-Left Security](../modules/module-01-shift-left.md)** - Security fundamentals (1.5h)
2. **[GitHub Advanced Security](../modules/module-02-ghas.md)** - GHAS features (1h)
3. **[Security Environment Setup](../modules/module-03-environment-setup.md)** - Tools & configuration (1.5h)

### AI-Powered Development (Modules 4-6)
4. **[AI Secure Coding](../modules/module-04-copilot.md)** - GitHub Copilot for security (2h)
5. **[Container Security](../modules/module-05-container.md)** - DevSecOps practices (2h)
6. **[Agentic AI](../modules/module-06-agentic.md)** - Automated security agents (2h)

### Enterprise Security (Modules 7-10)
7. **[Multi-Cloud Security](../modules/module-07-multicloud.md)** - Cross-cloud strategies (2h)
8. **[Microsoft Sentinel](../modules/module-08-sentinel.md)** - SIEM/SOAR setup (2.5h)
9. **[Security Dashboards](../modules/module-09-dashboards.md)** - Monitoring & reporting (2h)
10. **[Advanced Patterns](../modules/module-10-advanced.md)** - Zero-trust & more (2.5h)

## 🛠️ Essential Commands Cheat Sheet

### Git Commands
```bash
git status                    # Check current status
git add .                     # Stage all changes
git commit -m "message"       # Commit changes
git push origin branch-name   # Push to GitHub
```

### Docker Commands
```bash
docker build -t app .         # Build image
docker run -p 3000:3000 app   # Run container
docker ps                     # List running containers
docker scan app               # Scan for vulnerabilities
```

### Azure CLI Commands
```bash
az login                      # Login to Azure
az group create -n rg-workshop -l eastus  # Create resource group
az acr create -n myregistry -g rg-workshop --sku Basic  # Create container registry
```

### Security Scanning
```bash
# GitHub CLI security commands
gh secret scan                # Scan for secrets
gh api /repos/{owner}/{repo}/code-scanning/alerts  # View alerts

# Local scanning
trivy fs .                    # Scan filesystem
snyk test                     # Test for vulnerabilities
```

## 🎓 Learning Paths

### 🚀 Express Path (3 hours)
Perfect for a quick introduction:
1. Module 1: Shift-Left basics (45 min)
2. Module 2: GHAS setup (30 min)
3. Module 4: AI secure coding (90 min)
4. Quick lab: Fix 3 vulnerabilities (15 min)

### 📚 Standard Path (8 hours)
Comprehensive security coverage:
1. Complete Modules 1-7
2. Hands-on labs for each module
3. Build a secure CI/CD pipeline
4. Deploy to cloud with security

### 🏆 Advanced Path (16+ hours)
Full enterprise implementation:
1. All 10 modules in detail
2. Multi-cloud deployment
3. Complete monitoring setup
4. Custom security agents
5. Production-ready implementation

## 🔧 Troubleshooting Quick Fixes

### Docker Not Running
```bash
# macOS/Windows
# Open Docker Desktop application

# Linux
sudo systemctl start docker
```

### GitHub Authentication Issues
```bash
# Reconfigure GitHub CLI
gh auth logout
gh auth login

# Use personal access token
git config --global credential.helper store
```

### Azure Login Problems
```bash
# Clear Azure credentials
az logout
az account clear
az login --use-device-code
```

## 📊 Success Metrics

Track your progress:
- [ ] Completed environment setup
- [ ] Ran first security scan
- [ ] Fixed first vulnerability with AI
- [ ] Enabled GHAS on repository
- [ ] Completed at least 3 modules
- [ ] Deployed secure application

## 🚦 Next Steps

1. **Complete Module 1** - [Start Here](../modules/module-01-shift-left.md)
2. **Join Community** - [GitHub Discussions](https://github.com/paulasilvatech/Secure-Code-AI-Dev/discussions)
3. **Share Progress** - Post your achievements with #SecureCodeAI

## 🆘 Need Help?

- 📖 [Detailed Troubleshooting Guide](troubleshooting-guide.md)
- 💬 [Workshop FAQ](workshop-faq.md)
- 🤝 [Community Support](https://github.com/paulasilvatech/Secure-Code-AI-Dev/discussions)
- 📧 Direct support: workshop@secureaidev.com

---

## 🎉 Congratulations!

You're ready to start your secure coding journey! Remember:
- Take breaks between modules
- Practice with real code
- Ask questions in discussions
- Share your learnings

**Ready for Module 1?** → [Start with Shift-Left Security](../modules/module-01-shift-left.md)

---

<div align="center">
  <strong>🛡️ Secure Code. 🤖 AI-Powered. 🚀 Production-Ready.</strong>
</div>

## 🧭 Navigation

| Previous | Up | Next |
|----------|----|----- |
| [📖 Main README](../README.md) | [📚 Documentation](../README.md#-documentation) | [🚀 Workshop Overview](secure-code-ai-workshop.md) |

**Quick Links**: [🛡️ Security FAQ](workshop-faq.md) • [🔧 Troubleshooting](troubleshooting-guide.md) • [📦 Products](products-overview.md) 