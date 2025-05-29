# Workshop Resources

This directory contains all the infrastructure as code templates, scripts, and workflows needed to successfully deploy and run the Secure Code AI Workshop.

## 📁 Directory Structure

```
resources/
├── common/                     # Common resources used across all modules
│   ├── bicep/                 # Bicep templates for Azure infrastructure
│   ├── scripts/               # Deployment and utility scripts
│   └── workflows/             # GitHub Actions workflows
├── module-01-shift-left/      # Module 1 specific resources
├── module-02-ghas/            # Module 2 specific resources
├── module-04-copilot/         # Module 4 specific resources
├── module-05-container/       # Module 5 specific resources
├── module-06-agentic/         # Module 6 specific resources
├── module-07-multicloud/      # Module 7 specific resources
├── module-08-sentinel/        # Module 8 specific resources
├── module-09-dashboards/      # Module 9 specific resources
└── module-10-advanced/        # Module 10 specific resources
```

## 🚀 Quick Start

### Deploy Complete Workshop Infrastructure

```bash
# Clone the repository
git clone https://github.com/paulasilvatech/Secure-Code-AI-Dev.git
cd Secure-Code-AI-Dev

# Run the deployment script
./resources/common/scripts/deploy-workshop.sh
```

This script will:
- Check prerequisites (Azure CLI, Bicep)
- Create a resource group
- Deploy all necessary Azure resources
- Configure post-deployment settings
- Generate a deployment summary

### Prerequisites

- Azure subscription with appropriate permissions
- Azure CLI installed and authenticated (`az login`)
- Bash shell (Linux, macOS, or WSL on Windows)
- GitHub account with admin access to repositories

## 📋 Common Resources

### Bicep Templates

| File | Description |
|------|-------------|
| `common/bicep/main.bicep` | Main infrastructure template that deploys all workshop resources |
| `common/bicep/sentinel.bicep` | Microsoft Sentinel configuration and data connectors |
| `common/bicep/github-integration.bicep` | GitHub webhook integration with Azure Functions |

### Scripts

| File | Description |
|------|-------------|
| `common/scripts/deploy-workshop.sh` | Main deployment script for the entire workshop |
| `common/scripts/setup-github-secrets.sh` | Configure GitHub repository secrets |
| `common/scripts/validate-deployment.sh` | Validate deployment and check resource health |

### Workflows

| File | Description |
|------|-------------|
| `common/workflows/secure-pipeline.yml` | Secure CI/CD pipeline with GHAS integration |
| `common/workflows/container-security.yml` | Container scanning and deployment workflow |
| `common/workflows/sentinel-integration.yml` | GitHub to Sentinel alert forwarding |

## 🔧 Module-Specific Resources

### Module 1: Shift-Left Security
- Pre-commit hooks for security checks
- Git configuration templates
- Security policy templates

### Module 2: GitHub Advanced Security
- GHAS configuration scripts
- CodeQL custom queries
- Dependabot configuration examples

### Module 4: Copilot Security
- Copilot configuration for secure coding
- Security-focused prompts library
- Autofix templates

### Module 5: Container Security
- Secure Dockerfile templates
- Container scanning policies
- Kubernetes security manifests

### Module 6: Agentic AI
- Security agent deployment templates
- Event-driven automation workflows
- Self-healing configuration

### Module 7: Multi-Cloud Security
- Cross-cloud deployment templates
- Multi-cloud security policies
- Unified monitoring configuration

### Module 8: Sentinel Integration
- KQL query library
- Sentinel workbooks
- Alert rules and playbooks

### Module 9: Security Dashboards
- Dashboard templates
- Visualization queries
- Report generation scripts

### Module 10: Advanced Scenarios
- Zero Trust implementation
- Compliance automation
- Enterprise scale templates

## 💡 Usage Examples

### Deploy Individual Components

```bash
# Deploy only Sentinel
az deployment group create \
  --resource-group rg-workshop \
  --template-file resources/common/bicep/sentinel.bicep \
  --parameters workspaceName=law-workshop location=eastus

# Deploy GitHub integration
az deployment group create \
  --resource-group rg-workshop \
  --template-file resources/common/bicep/github-integration.bicep \
  --parameters keyVaultName=kv-workshop workspaceName=law-workshop
```

### Run Module-Specific Setup

```bash
# Module 2 - Setup GHAS
./resources/module-02-ghas/scripts/setup-ghas.sh

# Module 5 - Deploy container security
./resources/module-05-container/scripts/deploy-container-security.sh
```

## 🔐 Security Considerations

All templates and scripts follow security best practices:
- No hardcoded secrets or credentials
- RBAC with least privilege principle
- Network isolation and security groups
- Encryption at rest and in transit
- Managed identities for service authentication

## 📝 Customization

### Modify Deployment Parameters

Edit the parameters in `deploy-workshop.sh` or create a custom parameters file:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workshopName": {
      "value": "my-custom-workshop"
    },
    "location": {
      "value": "westus2"
    },
    "enableGHAS": {
      "value": true
    },
    "enableDefender": {
      "value": true
    }
  }
}
```

### Scale Resources

Modify the SKUs and sizes in the Bicep templates:

```bicep
// In main.bicep
resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-01-01' = {
  // ...
  properties: {
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 3  // Increase node count
        vmSize: 'Standard_DS3_v2'  // Larger VM size
        // ...
      }
    ]
  }
}
```

## 🆘 Troubleshooting

### Common Issues

1. **Deployment fails with permissions error**
   - Ensure you have Owner or Contributor role on the subscription
   - Check that your service principal has necessary permissions

2. **Resource names already exist**
   - The templates use unique suffixes, but you can customize the base names
   - Delete existing resources or use a different workshop name

3. **Region not available**
   - Some services might not be available in all regions
   - Try using `eastus`, `westus2`, or `westeurope`

### Validation Script

Run the validation script to check deployment health:

```bash
./resources/common/scripts/validate-deployment.sh
```

## 📚 Additional Resources

- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Microsoft Sentinel Documentation](https://docs.microsoft.com/en-us/azure/sentinel/)

## 🤝 Contributing

To add new resources:

1. Create the appropriate directory structure
2. Follow the naming conventions
3. Include documentation in your templates
4. Test the deployment thoroughly
5. Update this README with your additions

## 📄 License

All resources in this directory are part of the Secure Code AI Workshop and are licensed under the MIT License. 