@description('The name of the workshop environment')
@minLength(3)
@maxLength(24)
param workshopName string = 'secure-code-ai-workshop'

@description('The location for all resources')
param location string = resourceGroup().location

@description('The administrator username for VMs')
@secure()
param adminUsername string

@description('The administrator password for VMs')
@secure()
param adminPassword string

@description('The Azure AD tenant ID')
param tenantId string = subscription().tenantId

@description('The Azure AD object ID of the user running the workshop')
param userObjectId string

@description('Enable GitHub Advanced Security features')
param enableGHAS bool = true

@description('Enable Microsoft Defender for Cloud')
param enableDefender bool = true

@description('Tags to apply to all resources')
param tags object = {
  Environment: 'Workshop'
  Purpose: 'SecureCodeAI'
  Owner: 'Workshop User'
}

// Variables
var uniqueSuffix = uniqueString(resourceGroup().id, workshopName)
var workspaceName = 'law-${workshopName}-${uniqueSuffix}'
var keyVaultName = 'kv-${take(workshopName, 14)}-${uniqueSuffix}'
var acrName = 'acr${replace(workshopName, '-', '')}${uniqueSuffix}'
var aksName = 'aks-${workshopName}'
var appInsightsName = 'ai-${workshopName}-${uniqueSuffix}'
var storageAccountName = 'st${replace(workshopName, '-', '')}${uniqueSuffix}'

// Log Analytics Workspace
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantId
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
    enablePurgeProtection: true
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// Key Vault Administrator Role Assignment
resource keyVaultAdminRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, userObjectId, 'Key Vault Administrator')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00482a5a-887f-4fb3-b363-3b7fe8e74483')
    principalId: userObjectId
    principalType: 'User'
  }
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: 'Premium'
  }
  properties: {
    adminUserEnabled: false
    networkRuleSet: {
      defaultAction: 'Allow'
    }
    policies: {
      quarantinePolicy: {
        status: 'enabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'enabled'
      }
      retentionPolicy: {
        days: 30
        status: 'enabled'
      }
    }
    encryption: {
      status: 'enabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    zoneRedundancy: 'Disabled'
  }
}

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-${workshopName}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'aks-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'app-subnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'data-subnet'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
}

// AKS Cluster
resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-01-01' = {
  name: aksName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: aksName
    kubernetesVersion: '1.28.3'
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidr: '10.1.0.0/24'
      dnsServiceIP: '10.1.0.10'
    }
    agentPoolProfiles: [
      {
        name: 'systempool'
        count: 2
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: vnet.properties.subnets[0].id
      }
      {
        name: 'userpool'
        count: 3
        vmSize: 'Standard_DS3_v2'
        osType: 'Linux'
        mode: 'User'
        vnetSubnetID: vnet.properties.subnets[0].id
      }
    ]
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: 'true'
          rotationPollInterval: '2m'
        }
      }
      azurepolicy: {
        enabled: true
      }
      omsAgent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspace.id
        }
      }
    }
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.id
        securityMonitoring: {
          enabled: enableDefender
        }
      }
    }
  }
}

// Role assignment for AKS to pull images from ACR
resource acrPullRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.id, aksCluster.id, 'AcrPull')
  scope: containerRegistry
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: aksCluster.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
  }
}

// Microsoft Sentinel
module sentinel 'sentinel.bicep' = if (enableDefender) {
  name: 'sentinelDeployment'
  params: {
    workspaceName: workspaceName
    location: location
    tags: tags
  }
}

// GitHub connector and policies
module githubIntegration 'github-integration.bicep' = if (enableGHAS) {
  name: 'githubIntegration'
  params: {
    keyVaultName: keyVault.name
    workspaceName: workspaceName
    location: location
    tags: tags
  }
}

// Outputs
output workshopResourceGroup string = resourceGroup().name
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
output keyVaultName string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
output containerRegistryName string = containerRegistry.name
output containerRegistryLoginServer string = containerRegistry.properties.loginServer
output aksClusterName string = aksCluster.name
output appInsightsName string = appInsights.name
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
output appInsightsConnectionString string = appInsights.properties.ConnectionString
output storageAccountName string = storageAccount.name 
