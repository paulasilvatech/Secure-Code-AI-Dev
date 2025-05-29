# 🔧 Troubleshooting Guide

## Table of Contents

1. [Common Setup Issues](#common-setup-issues)
2. [Azure Issues](#azure-issues)
3. [GitHub Issues](#github-issues)
4. [Container Issues](#container-issues)
5. [Kubernetes Issues](#kubernetes-issues)
6. [Sentinel Issues](#sentinel-issues)
7. [Network Issues](#network-issues)
8. [Authentication Issues](#authentication-issues)

## Common Setup Issues

### Issue: Azure CLI Installation Fails

**Symptoms:**
```
curl: (7) Failed to connect to aka.ms port 443
```

**Solution:**
```bash
# Alternative installation method
wget -O - https://aka.ms/InstallAzureCLIDeb | sudo bash

# Or manual installation
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli
```

### Issue: Docker Permission Denied

**Symptoms:**
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Restart Docker service
sudo systemctl restart docker

# Verify
docker run hello-world
```

### Issue: Node.js Version Incompatible

**Symptoms:**
```
Error: Node.js version 12.x is not supported
```

**Solution:**
```bash
# Install Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# Install and use Node.js 16
nvm install 16
nvm use 16
nvm alias default 16
```

## Azure Issues

### Issue: Subscription Not Found

**Symptoms:**
```
The subscription 'xxx' could not be found
```

**Solution:**
```bash
# List all subscriptions
az account list --output table

# Set correct subscription
az account set --subscription "SUBSCRIPTION_NAME_OR_ID"

# Verify
az account show
```

### Issue: Resource Provider Not Registered

**Symptoms:**
```
The subscription is not registered to use namespace 'Microsoft.ContainerService'
```

**Solution:**
```bash
# Register required providers
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.SecurityInsights
az provider register --namespace Microsoft.Security

# Check registration status
az provider show --namespace Microsoft.ContainerService --query registrationState
```

### Issue: Insufficient Permissions

**Symptoms:**
```
AuthorizationFailed: The client does not have authorization
```

**Solution:**
```bash
# Check current role assignments
az role assignment list --assignee $(az account show --query user.name -o tsv)

# Request Owner or Contributor role from subscription admin
# Or create resources in a resource group where you have permissions
```

## GitHub Issues

### Issue: GHAS Not Available

**Symptoms:**
```
GitHub Advanced Security is not available for this repository
```

**Solution:**
1. Ensure repository is public OR
2. Enable GHAS trial:
   - Go to Settings → Security & analysis
   - Click "Enable" next to GitHub Advanced Security
   - Start 30-day trial

### Issue: GitHub Actions Workflow Fails

**Symptoms:**
```
Error: Credentials could not be loaded
```

**Solution:**
```yaml
# Check secrets are properly set
# In repository Settings → Secrets and variables → Actions

# Required secrets:
AZURE_CREDENTIALS
AZURE_SUBSCRIPTION_ID
ACR_LOGIN_SERVER
ACR_USERNAME
ACR_PASSWORD

# Generate Azure credentials:
az ad sp create-for-rbac --name "github-actions" \
  --role contributor \
  --scopes /subscriptions/$(az account show --query id -o tsv) \
  --json-auth
```

### Issue: CodeQL Analysis Timeout

**Symptoms:**
```
The job running on runner GitHub Actions has exceeded the maximum execution time of 360 minutes
```

**Solution:**
```yaml
# Optimize CodeQL workflow
- name: Initialize CodeQL
  uses: github/codeql-action/init@v2
  with:
    languages: ${{ matrix.language }}
    queries: security-and-quality  # Instead of security-extended
    
# Add timeout
jobs:
  analyze:
    timeout-minutes: 120  # Adjust as needed
```

## Container Issues

### Issue: ACR Push Fails

**Symptoms:**
```
unauthorized: authentication required
```

**Solution:**
```bash
# Login to ACR
az acr login --name $ACR_NAME

# If that fails, use admin credentials
az acr update --name $ACR_NAME --admin-enabled true
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)
docker login $ACR_NAME.azurecr.io -u $ACR_NAME -p $ACR_PASSWORD
```

### Issue: Container Build Fails

**Symptoms:**
```
ERROR: failed to solve: failed to fetch anonymous token
```

**Solution:**
```dockerfile
# Use specific versions instead of latest
FROM node:16-alpine3.15  # Instead of node:alpine

# Add --no-cache flag
RUN apk add --no-cache python3 make g++

# Use multi-stage builds to reduce size
FROM node:16-alpine AS builder
# Build stage
FROM node:16-alpine
# Runtime stage
```

## Kubernetes Issues

### Issue: kubectl Connection Refused

**Symptoms:**
```
The connection to the server localhost:8080 was refused
```

**Solution:**
```bash
# Get AKS credentials
az aks get-credentials \
  --resource-group rg-secure-code-workshop \
  --name aks-secure-workshop

# Verify context
kubectl config current-context

# Test connection
kubectl get nodes
```

### Issue: Pod Stuck in Pending

**Symptoms:**
```
Pod status shows "Pending" indefinitely
```

**Solution:**
```bash
# Check pod events
kubectl describe pod POD_NAME

# Common causes:
# 1. Insufficient resources
kubectl get nodes -o custom-columns=NAME:.metadata.name,CPU:.status.allocatable.cpu,MEMORY:.status.allocatable.memory

# 2. Image pull errors
kubectl get events --field-selector reason=Failed

# 3. PVC not bound
kubectl get pvc
```

## Sentinel Issues

### Issue: Data Not Appearing in Sentinel

**Symptoms:**
```
No data in Log Analytics workspace
```

**Solution:**
```kusto
// Check data ingestion
union withsource=TableName *
| where TimeGenerated > ago(1h)
| summarize Count=count() by TableName
| order by Count desc

// Check specific connector
AzureActivity
| where TimeGenerated > ago(24h)
| take 10

// Verify data collection rules
resources
| where type == "microsoft.insights/datacollectionrules"
| project name, location, properties
```

### Issue: Analytics Rules Not Triggering

**Symptoms:**
```
No incidents created despite matching events
```

**Solution:**
1. Check rule configuration:
   - Frequency and time window
   - Query syntax
   - Threshold settings

2. Test query directly:
```kusto
// Your detection query here
| where TimeGenerated > ago(1h)
```

3. Check rule status:
   - Analytics → Active rules
   - Look for errors or warnings

## Network Issues

### Issue: Cross-Cloud Connectivity Fails

**Symptoms:**
```
Cannot connect from Azure to AWS/GCP resources
```

**Solution:**
```bash
# Check VPN connection status
az network vpn-connection show \
  --name vpn-azure-to-aws \
  --resource-group rg-secure-code-workshop

# Verify network security groups
az network nsg rule list \
  --nsg-name nsg-secure-workshop \
  --resource-group rg-secure-code-workshop \
  --output table

# Test connectivity
# From Azure VM
nslookup aws-endpoint.region.amazonaws.com
telnet aws-endpoint.region.amazonaws.com 443
```

### Issue: Container Registry Unreachable

**Symptoms:**
```
dial tcp: lookup acr.azurecr.io: no such host
```

**Solution:**
```bash
# Check DNS resolution
nslookup $ACR_NAME.azurecr.io

# If using private endpoint
az network private-endpoint dns-zone-group create \
  --endpoint-name pe-acr \
  --name default \
  --private-dns-zone privatelink.azurecr.io \
  --resource-group rg-secure-code-workshop \
  --zone-name privatelink.azurecr.io
```

## Authentication Issues

### Issue: Token Expired During Workshop

**Symptoms:**
```
AADSTS700024: Client assertion is not within its valid time range
```

**Solution:**
```bash
# Refresh Azure token
az account get-access-token --resource https://management.azure.com/

# Re-authenticate if needed
az login

# For service principals
az login --service-principal \
  --username $SP_APP_ID \
  --password $SP_PASSWORD \
  --tenant $TENANT_ID
```

### Issue: GitHub Token Insufficient Permissions

**Symptoms:**
```
Resource not accessible by integration
```

**Solution:**
1. Check token permissions:
   - Go to Settings → Developer settings → Personal access tokens
   - Ensure token has required scopes:
     - `repo` (full control)
     - `workflow` (update workflows)
     - `admin:org` (for org-level operations)

2. For GitHub Apps:
   - Check app permissions in repository settings
   - Ensure app is installed on the repository

## Quick Fixes Reference

### Reset Everything
```bash
# Clean Docker
docker system prune -a -f

# Reset Kubernetes context
kubectl config unset current-context

# Clear Azure CLI cache
az cache purge
az account clear

# Remove GitHub CLI auth
gh auth logout
```

### Verify All Components
```bash
# Run comprehensive check
./scripts/verify-workshop-setup.sh --verbose

# Manual checks
az --version
docker --version
kubectl version --client
gh --version
node --version
```

## Getting Help

If you're still experiencing issues:

1. **Check Logs:**
   ```bash
   # Azure CLI logs
   cat ~/.azure/logs/*
   
   # Docker logs
   docker logs CONTAINER_ID
   
   # Kubernetes logs
   kubectl logs POD_NAME
   ```

2. **Enable Debug Mode:**
   ```bash
   # Azure CLI debug
   export AZURE_CORE_COLLECT_TELEMETRY=0
   export AZURE_LOG_LEVEL=DEBUG
   
   # Kubernetes verbose
   kubectl get pods -v=8
   ```

3. **Community Support:**
   - Workshop Discussions: [GitHub Discussions](https://github.com/YOUR-USERNAME/secure-code-ai-workshop/discussions)
   - Stack Overflow: Tag with `secure-code-ai-workshop`
   - Microsoft Q&A: [Azure Security](https://docs.microsoft.com/answers/topics/azure-security.html)

4. **Report Issues:**
   - [Workshop Issues](https://github.com/YOUR-USERNAME/secure-code-ai-workshop/issues)
   - Include:
     - Error message
     - Steps to reproduce
     - Environment details
     - Relevant logs

---

**Remember:** Most issues can be resolved by:
1. Checking prerequisites are installed correctly
2. Ensuring you're authenticated properly
3. Verifying network connectivity
4. Having sufficient permissions

Happy troubleshooting! 🔧

---

## 🧭 Navigation

| Previous | Up | Next |
|----------|----|----- |
| [🛡️ Security FAQ](workshop-faq.md) | [📚 Documentation](../README.md#-documentation) | [🚀 Quick Start](QUICK_START.md) |

**Quick Links**: [🚀 Workshop Overview](secure-code-ai-workshop.md) • [📦 Products](products-overview.md) • [📋 All Modules](../modules/)
