#!/bin/bash

# Secure Code AI Workshop - Infrastructure Deployment Script
# This script deploys all necessary Azure resources for the workshop

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    print_message $YELLOW "Checking prerequisites..."
    
    # Check Azure CLI
    if ! command -v az &> /dev/null; then
        print_message $RED "Azure CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if logged in to Azure
    if ! az account show &> /dev/null; then
        print_message $RED "Not logged in to Azure. Please run 'az login' first."
        exit 1
    fi
    
    # Check if bicep is installed
    if ! az bicep version &> /dev/null; then
        print_message $YELLOW "Installing Bicep..."
        az bicep install
    fi
    
    print_message $GREEN "Prerequisites check completed!"
}

# Function to get user input
get_deployment_parameters() {
    print_message $YELLOW "Getting deployment parameters..."
    
    # Get subscription
    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    print_message $GREEN "Using subscription: $SUBSCRIPTION_ID"
    
    # Get or create resource group
    read -p "Enter resource group name (default: rg-secure-code-workshop): " RESOURCE_GROUP
    RESOURCE_GROUP=${RESOURCE_GROUP:-rg-secure-code-workshop}
    
    # Get location
    read -p "Enter Azure region (default: eastus): " LOCATION
    LOCATION=${LOCATION:-eastus}
    
    # Get workshop name
    read -p "Enter workshop name (default: secure-code-ai-workshop): " WORKSHOP_NAME
    WORKSHOP_NAME=${WORKSHOP_NAME:-secure-code-ai-workshop}
    
    # Get admin credentials
    read -p "Enter admin username: " ADMIN_USERNAME
    read -s -p "Enter admin password: " ADMIN_PASSWORD
    echo
    
    # Get user object ID
    USER_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)
    print_message $GREEN "User Object ID: $USER_OBJECT_ID"
}

# Function to create resource group
create_resource_group() {
    print_message $YELLOW "Creating resource group..."
    
    if az group exists --name $RESOURCE_GROUP; then
        print_message $YELLOW "Resource group $RESOURCE_GROUP already exists."
    else
        az group create --name $RESOURCE_GROUP --location $LOCATION
        print_message $GREEN "Resource group $RESOURCE_GROUP created!"
    fi
}

# Function to deploy infrastructure
deploy_infrastructure() {
    print_message $YELLOW "Deploying workshop infrastructure..."
    
    # Get the directory of this script
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    BICEP_DIR="$(dirname "$SCRIPT_DIR")/bicep"
    
    # Create parameters file
    cat > "${SCRIPT_DIR}/parameters.json" <<EOF
{
    "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workshopName": {
            "value": "${WORKSHOP_NAME}"
        },
        "adminUsername": {
            "value": "${ADMIN_USERNAME}"
        },
        "adminPassword": {
            "value": "${ADMIN_PASSWORD}"
        },
        "userObjectId": {
            "value": "${USER_OBJECT_ID}"
        },
        "enableGHAS": {
            "value": true
        },
        "enableDefender": {
            "value": true
        }
    }
}
EOF
    
    # Deploy the main template
    DEPLOYMENT_NAME="workshop-deployment-$(date +%Y%m%d%H%M%S)"
    
    az deployment group create \
        --name $DEPLOYMENT_NAME \
        --resource-group $RESOURCE_GROUP \
        --template-file "${BICEP_DIR}/main.bicep" \
        --parameters @"${SCRIPT_DIR}/parameters.json"
    
    # Clean up parameters file
    rm -f "${SCRIPT_DIR}/parameters.json"
    
    print_message $GREEN "Infrastructure deployment completed!"
}

# Function to configure post-deployment
configure_post_deployment() {
    print_message $YELLOW "Configuring post-deployment settings..."
    
    # Get deployment outputs
    OUTPUTS=$(az deployment group show \
        --name $DEPLOYMENT_NAME \
        --resource-group $RESOURCE_GROUP \
        --query properties.outputs)
    
    # Extract important values
    WORKSPACE_NAME=$(echo $OUTPUTS | jq -r '.logAnalyticsWorkspaceName.value')
    KEY_VAULT_NAME=$(echo $OUTPUTS | jq -r '.keyVaultName.value')
    ACR_NAME=$(echo $OUTPUTS | jq -r '.containerRegistryName.value')
    AKS_NAME=$(echo $OUTPUTS | jq -r '.aksClusterName.value')
    
    # Get AKS credentials
    print_message $YELLOW "Getting AKS credentials..."
    az aks get-credentials \
        --resource-group $RESOURCE_GROUP \
        --name $AKS_NAME \
        --overwrite-existing
    
    # Store workspace key in Key Vault
    print_message $YELLOW "Storing secrets in Key Vault..."
    WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys \
        --resource-group $RESOURCE_GROUP \
        --workspace-name $WORKSPACE_NAME \
        --query primarySharedKey -o tsv)
    
    az keyvault secret set \
        --vault-name $KEY_VAULT_NAME \
        --name "workspace-key" \
        --value "$WORKSPACE_KEY"
    
    # Generate GitHub webhook secret
    GITHUB_WEBHOOK_SECRET=$(openssl rand -hex 32)
    az keyvault secret set \
        --vault-name $KEY_VAULT_NAME \
        --name "github-webhook-secret" \
        --value "$GITHUB_WEBHOOK_SECRET"
    
    print_message $GREEN "Post-deployment configuration completed!"
}

# Function to create output file
create_output_file() {
    print_message $YELLOW "Creating deployment output file..."
    
    OUTPUT_FILE="${SCRIPT_DIR}/deployment-output.txt"
    
    cat > $OUTPUT_FILE <<EOF
Secure Code AI Workshop - Deployment Summary
==========================================

Deployment Date: $(date)
Subscription ID: $SUBSCRIPTION_ID
Resource Group: $RESOURCE_GROUP
Location: $LOCATION

Resources Created:
- Log Analytics Workspace: $WORKSPACE_NAME
- Key Vault: $KEY_VAULT_NAME
- Container Registry: $ACR_NAME
- AKS Cluster: $AKS_NAME

GitHub Webhook Configuration:
- Webhook URL: $(echo $OUTPUTS | jq -r '.webhookUrl.value // "Not available"')
- Webhook Secret: Stored in Key Vault as 'github-webhook-secret'

Next Steps:
1. Configure GitHub repository webhooks using the webhook URL above
2. Enable GitHub Advanced Security on your repositories
3. Configure Microsoft Defender for Cloud policies
4. Follow the workshop modules starting with Module 01

For more information, see the workshop documentation.
EOF
    
    print_message $GREEN "Deployment summary saved to: $OUTPUT_FILE"
}

# Function to display summary
display_summary() {
    print_message $GREEN "\n============================================"
    print_message $GREEN "Workshop Infrastructure Deployment Complete!"
    print_message $GREEN "============================================\n"
    
    cat $OUTPUT_FILE
}

# Main execution
main() {
    print_message $GREEN "Secure Code AI Workshop - Infrastructure Deployment"
    print_message $GREEN "=================================================\n"
    
    check_prerequisites
    get_deployment_parameters
    create_resource_group
    deploy_infrastructure
    configure_post_deployment
    create_output_file
    display_summary
    
    print_message $GREEN "\nDeployment completed successfully! 🎉"
}

# Run main function
main "$@" 