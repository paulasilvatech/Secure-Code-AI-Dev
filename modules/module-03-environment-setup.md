# Module 03: Setting Up Your Security Environment

## 📋 Module Overview

**Duration**: 2.5 hours  
**Level**: Intermediate  
**Prerequisites**: Completed Module 01 and 02

## 🎯 Learning Objectives

By the end of this module, you will:
- Set up a complete security development environment
- Configure VS Code with security extensions
- Install and configure security tools
- Set up local security scanning
- Configure cloud security environments
- Integrate security tools into your workflow

## 📚 Module Contents

1. [Introduction](#introduction)
2. [Development Environment Setup](#development-environment-setup)
3. [Security Tools Installation](#security-tools-installation)
4. [Cloud Environment Configuration](#cloud-environment-configuration)
5. [Integration and Testing](#integration-and-testing)
6. [Exercises](#exercises)

## Introduction

A properly configured security environment is the foundation for secure development. This module guides you through setting up a comprehensive security-focused development environment that integrates seamlessly with your workflow.

## Development Environment Setup

### VS Code Security Configuration

#### Essential Security Extensions

```bash
# Install security extensions
code --install-extension ms-vscode.azure-account
code --install-extension ms-azuretools.vscode-azureresourcegroups
code --install-extension github.vscode-github-actions
code --install-extension github.copilot
code --install-extension github.copilot-chat
code --install-extension ms-vscode.vscode-node-azure-pack
code --install-extension humao.rest-client
code --install-extension redhat.vscode-yaml
code --install-extension ms-vscode.powershell
code --install-extension hashicorp.terraform
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
```

#### Security-Focused Extensions

```bash
# Security scanning extensions
code --install-extension snyk-security.snyk-vulnerability-scanner
code --install-extension trailofbits.weaudit
code --install-extension SonarSource.sonarlint-vscode
code --install-extension aquasecurityofficial.trivy-vulnerability-scanner

# Code quality and security
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension streetsidesoftware.code-spell-checker
```

### VS Code Settings for Security

Create or update `.vscode/settings.json`:

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/.env": true,
    "**/*.key": true,
    "**/*.pem": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/*.code-search": true,
    "**/.env": true,
    "**/secrets": true
  },
  "github.copilot.enable": {
    "*": true,
    "yaml": true,
    "plaintext": true,
    "markdown": true
  },
  "sonarlint.rules": {
    "javascript:S2068": {
      "level": "on"
    }
  },
  "trivy.severity": "HIGH,CRITICAL"
}
```

## Security Tools Installation

### Local Security Tools

#### 1. Git Security Tools

```bash
# Install git-secrets
# macOS
brew install git-secrets

# Linux
git clone https://github.com/awslabs/git-secrets.git
cd git-secrets
make install

# Configure git-secrets
git secrets --install
git secrets --register-aws
git secrets --register-azure
```

#### 2. Container Security Tools

```bash
# Install Trivy
# macOS
brew install aquasecurity/trivy/trivy

# Linux
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

# Install Hadolint
# macOS
brew install hadolint

# Linux
wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
chmod +x /bin/hadolint
```

#### 3. SAST Tools

```bash
# Install Semgrep
pip install semgrep

# Install Bandit (Python)
pip install bandit

# Install ESLint (JavaScript)
npm install -g eslint eslint-plugin-security

# Install gosec (Go)
go install github.com/securego/gosec/v2/cmd/gosec@latest
```

#### 4. Dependency Scanning

```bash
# Install OWASP Dependency Check
VERSION="8.4.0"
curl -L -o dependency-check.zip "https://github.com/jeremylong/DependencyCheck/releases/download/v${VERSION}/dependency-check-${VERSION}-release.zip"
unzip dependency-check.zip

# Install Snyk CLI
npm install -g snyk
snyk auth
```

### Security Tool Configuration

#### Create `.trivyignore`:

```text
# Ignore specific vulnerabilities
CVE-2023-12345

# Ignore test files
test/
tests/
*_test.go
*.test.js
```

#### Create `.semgrep.yml`:

```yaml
rules:
  - id: hardcoded-secret
    pattern: |
      $KEY = "..."
    pattern-either:
      - metavariable-regex:
          metavariable: $KEY
          regex: (password|secret|key|token|api_key)
    message: Hardcoded secret detected
    severity: ERROR
    languages: [javascript, python, go]
```

## Cloud Environment Configuration

### Azure Security Setup

```bash
# Login to Azure
az login

# Create resource group for security resources
az group create --name rg-security-workshop --location eastus

# Create Key Vault
az keyvault create \
  --name kv-workshop-$RANDOM \
  --resource-group rg-security-workshop \
  --location eastus \
  --enable-rbac-authorization

# Create Log Analytics Workspace
az monitor log-analytics workspace create \
  --resource-group rg-security-workshop \
  --workspace-name law-workshop \
  --location eastus
```

### GitHub Environment Setup

```bash
# Set up GitHub CLI
gh auth login

# Configure GitHub environment
gh secret set AZURE_CREDENTIALS < azure-creds.json
gh secret set AZURE_SUBSCRIPTION_ID --body "$AZURE_SUBSCRIPTION_ID"
gh secret set AZURE_TENANT_ID --body "$AZURE_TENANT_ID"

# Enable GitHub Advanced Security features
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  /repos/{owner}/{repo} \
  -f security_and_analysis='{"advanced_security":{"status":"enabled"},"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}'
```

## Integration and Testing

### Create Security Pipeline

Create `.github/workflows/security-scan.yml`:

```yaml
name: Security Scanning

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: 'trivy-results.sarif'
      
      - name: Run Semgrep
        uses: returntocorp/semgrep-action@v1
        with:
          config: >-
            p/security-audit
            p/secrets
```

### Test Your Environment

Create `test-security-env.sh`:

```bash
#!/bin/bash

echo "🔍 Testing Security Environment Setup..."

# Check VS Code
if command -v code &> /dev/null; then
    echo "✅ VS Code installed"
else
    echo "❌ VS Code not found"
fi

# Check security tools
tools=("git-secrets" "trivy" "hadolint" "semgrep" "snyk")
for tool in "${tools[@]}"; do
    if command -v $tool &> /dev/null; then
        echo "✅ $tool installed"
    else
        echo "❌ $tool not found"
    fi
done

# Check Azure CLI
if command -v az &> /dev/null; then
    echo "✅ Azure CLI installed"
    if az account show &> /dev/null; then
        echo "✅ Azure CLI authenticated"
    else
        echo "❌ Azure CLI not authenticated"
    fi
else
    echo "❌ Azure CLI not found"
fi

# Check GitHub CLI
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI installed"
    if gh auth status &> /dev/null; then
        echo "✅ GitHub CLI authenticated"
    else
        echo "❌ GitHub CLI not authenticated"
    fi
else
    echo "❌ GitHub CLI not found"
fi
```

## 📝 Exercises

### Exercise 1: Complete Environment Setup (30 minutes)

1. Install all required VS Code extensions
2. Configure VS Code security settings
3. Install all security tools
4. Run the test script to verify installation

### Exercise 2: Configure Security Scanning (30 minutes)

1. Set up git-secrets in a test repository
2. Create a Dockerfile and scan it with Hadolint
3. Run Trivy on a sample project
4. Configure Semgrep with custom rules

### Exercise 3: Cloud Security Setup (45 minutes)

1. Create Azure security resources using the provided scripts
2. Configure GitHub secrets for your repository
3. Enable GitHub Advanced Security features
4. Create and test the security scanning workflow

### Exercise 4: Integration Testing (45 minutes)

1. Create a sample vulnerable application
2. Run all security tools against it
3. Fix the vulnerabilities found
4. Create a security report

## 🎯 Module Summary

### Key Takeaways

1. **Comprehensive Setup**: A secure development environment requires multiple tools working together
2. **Automation First**: Security tools should be integrated into your normal workflow
3. **Cloud Integration**: Modern security requires cloud-native tools and services
4. **Continuous Scanning**: Security scanning should happen at every stage

### Skills Acquired

- ✅ VS Code security configuration
- ✅ Security tool installation and setup
- ✅ Cloud security environment setup
- ✅ Security pipeline creation
- ✅ Integration of multiple security tools

## 📚 Additional Resources

### Tools Documentation
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Semgrep Rules](https://semgrep.dev/r)
- [Git Secrets](https://github.com/awslabs/git-secrets)
- [VS Code Security](https://code.visualstudio.com/docs/editor/security)

### Best Practices
- [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/)
- [Microsoft Security Development Lifecycle](https://www.microsoft.com/en-us/securityengineering/sdl)

## ✅ Module Completion Checklist

Before moving to the next module, ensure you have:

- [ ] Installed and configured VS Code with security extensions
- [ ] Installed all required security tools
- [ ] Set up cloud security resources
- [ ] Created and tested security pipelines
- [ ] Completed all exercises

## 🚀 Next Steps

Ready to use AI for secure coding? Continue to [Module 04: AI-Powered Secure Coding with GitHub Copilot](module-04-copilot.md) where we'll explore how to leverage AI for security.

---

**Need Help?** Check our [Troubleshooting Guide](../docs/troubleshooting-guide.md) or ask in [Discussions](https://github.com/paulasilvatech/Secure-Code-AI-Dev/discussions).

---

## 🧭 Navigation

| Previous | Up | Next |
|----------|----|----- |
| [← Module 02: GitHub Advanced Security](module-02-ghas.md) | [📚 All Modules](../README.md#-learning-path) | [Module 04: Copilot Security →](module-04-copilot.md) |

**Quick Links**: [🏠 Home](../README.md) • [📖 Workshop Overview](../docs/secure-code-ai-workshop.md) • [🛡️ Security FAQ](../docs/workshop-faq.md) 