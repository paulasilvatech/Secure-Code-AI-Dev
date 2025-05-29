# 📁 Workshop Resources

This directory contains all Infrastructure as Code (IaC) templates, scripts, and configurations for the Secure Code AI Development Workshop.

## Resource Structure

### Common Resources
- [common/](common/) - Shared resources used across all modules
  - `bicep/` - Main infrastructure templates
  - `scripts/` - Workshop deployment scripts  
  - `templates/` - Common configuration templates
  - `workflows/` - Shared GitHub Actions workflows

### Module-Specific Resources

Each module has its own resource directory with:

| Module | Directory | Key Resources |
|--------|-----------|---------------|
| Module 01 | [module-01-shift-left/](module-01-shift-left/) | Pre-commit hooks, security policies |
| Module 02 | [module-02-ghas/](module-02-ghas/) | GHAS setup scripts, scanning configs |
| Module 03 | [module-03-environment-setup/](module-03-environment-setup/) | Environment setup scripts, VS Code configs |
| Module 04 | [module-04-copilot/](module-04-copilot/) | Copilot prompts, secure code templates |
| Module 05 | [module-05-container/](module-05-container/) | Dockerfiles, container security configs |
| Module 06 | [module-06-agentic/](module-06-agentic/) | AI agent templates, automation workflows |
| Module 07 | [module-07-multicloud/](module-07-multicloud/) | Multi-cloud Bicep templates, policies |
| Module 08 | [module-08-sentinel/](module-08-sentinel/) | Sentinel rules, KQL queries, playbooks |
| Module 09 | [module-09-dashboards/](module-09-dashboards/) | Dashboard templates, monitoring configs |
| Module 10 | [module-10-advanced/](module-10-advanced/) | Zero-trust templates, advanced patterns |

## Quick Access

### 🚀 Deployment Scripts
- [Deploy Complete Workshop](common/scripts/deploy-workshop.sh)
- [Setup Security Environment](module-03-environment-setup/scripts/setup-security-env.sh)
- [Pre-commit Security Setup](module-01-shift-left/scripts/pre-commit-security.sh)

### 🏗️ Infrastructure Templates
- [Main Infrastructure](common/bicep/main.bicep)
- [Security Environment](module-03-environment-setup/bicep/security-environment.bicep)
- [Multi-Cloud Security](module-07-multicloud/bicep/multicloud-security.bicep)
- [Zero-Trust Architecture](module-10-advanced/templates/zero-trust-architecture.yaml)

### 🔄 CI/CD Workflows
- [Secure CI/CD Pipeline](common/workflows/secure-pipeline.yml)
- [Security Scanning](module-03-environment-setup/workflows/security-scan.yml)
- [Container Security](module-05-container/workflows/container-security.yml)

### 📋 Configuration Templates
- [VS Code Settings](module-03-environment-setup/templates/vscode-settings.json)
- [Copilot Prompts](module-04-copilot/templates/copilot-prompts.md)
- [Security Dashboard](module-09-dashboards/templates/security-dashboard.json)

## Usage

1. **For Automated Deployment**:
   ```bash
   cd common/scripts
   ./deploy-workshop.sh
   ```

2. **For Manual Setup**:
   - Navigate to specific module resource directory
   - Follow the README in each subdirectory
   - Run scripts or deploy templates as needed

3. **For Custom Implementations**:
   - Copy templates to your project
   - Modify parameters as needed
   - Deploy using Azure CLI or GitHub Actions

## Resource Types

- **Scripts** (`.sh`, `.ps1`) - Automation and setup scripts
- **Bicep** (`.bicep`) - Azure infrastructure templates
- **YAML** (`.yml`, `.yaml`) - Workflows and Kubernetes configs
- **JSON** (`.json`) - Configuration files and dashboards
- **Markdown** (`.md`) - Documentation and prompt libraries

---

[← Back to Modules](../modules/) | [Back to Home →](../README.md) 