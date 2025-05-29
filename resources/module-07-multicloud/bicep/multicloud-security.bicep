@description('Multi-cloud security infrastructure template')
param environment string = 'production'

@description('Primary cloud provider')
@allowed(['azure', 'aws', 'gcp'])
param primaryCloud string = 'azure'

@description('Location for Azure resources')
param location string = resourceGroup().location

@description('Enable cross-cloud security monitoring')
param enableCrossCloudMonitoring bool = true

@description('Tags for all resources')
param tags object = {
  Environment: environment
  Purpose: 'MultiCloudSecurity'
  ManagedBy: 'SecureCodeWorkshop'
}

// Variables
var workspaceName = 'law-multicloud-${uniqueString(resourceGroup().id)}'
var vaultName = 'kv-mc-${uniqueString(resourceGroup().id)}'
var storageAccountName = 'stmc${uniqueString(resourceGroup().id)}'

// Centralized Log Analytics Workspace for multi-cloud logs
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

// Key Vault for multi-cloud secrets
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'premium'
    }
    tenantId: subscription().tenantId
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
    enablePurgeProtection: true
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}

// Storage Account for multi-cloud audit logs
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_GRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      defaultAction: 'Deny'
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

// Container for AWS CloudTrail logs
resource awsLogsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${storageAccount.name}/default/aws-cloudtrail-logs'
  properties: {
    publicAccess: 'None'
  }
}

// Container for GCP audit logs
resource gcpLogsContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${storageAccount.name}/default/gcp-audit-logs'
  properties: {
    publicAccess: 'None'
  }
}

// Data Factory for ETL of multi-cloud logs
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: 'adf-multicloud-${uniqueString(resourceGroup().id)}'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    globalParameters: {
      environment: {
        type: 'String'
        value: environment
      }
    }
  }
}

// Event Hub for real-time security events
resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: 'eh-multicloud-${uniqueString(resourceGroup().id)}'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 2
  }
  properties: {
    isAutoInflateEnabled: true
    maximumThroughputUnits: 10
    kafkaEnabled: true
  }
}

resource securityEventsHub 'Microsoft.EventHub/namespaces/eventhubs@2022-10-01-preview' = {
  parent: eventHubNamespace
  name: 'security-events'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

// Logic App for cross-cloud incident response
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'logic-multicloud-incident-${uniqueString(resourceGroup().id)}'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      triggers: {
        'When_a_security_alert_is_triggered': {
          type: 'ApiConnectionWebhook'
          inputs: {
            body: {
              callback: '@{listCallbackUrl()}'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            path: '/subscribe'
          }
        }
      }
      actions: {
        'Parse_Security_Alert': {
          type: 'ParseJson'
          inputs: {
            content: '@triggerBody()'
            schema: {}
          }
        }
        'Check_Cloud_Provider': {
          type: 'Switch'
          expression: '@body(\'Parse_Security_Alert\')?[\'CloudProvider\']'
          cases: {
            'AWS': {
              actions: {
                'Handle_AWS_Alert': {
                  type: 'Http'
                  inputs: {
                    method: 'POST'
                    uri: 'https://api.aws.com/security/respond'
                    body: '@body(\'Parse_Security_Alert\')'
                  }
                }
              }
            }
            'GCP': {
              actions: {
                'Handle_GCP_Alert': {
                  type: 'Http'
                  inputs: {
                    method: 'POST'
                    uri: 'https://api.gcp.com/security/respond'
                    body: '@body(\'Parse_Security_Alert\')'
                  }
                }
              }
            }
          }
          default: {
            actions: {
              'Handle_Azure_Alert': {
                type: 'Http'
                inputs: {
                  method: 'POST'
                  uri: 'https://management.azure.com/security/respond'
                  body: '@body(\'Parse_Security_Alert\')'
                }
              }
            }
          }
        }
      }
    }
  }
}

// Azure Policy for multi-cloud compliance
module compliancePolicy 'multicloud-policy.bicep' = {
  name: 'multi-cloud-security-compliance'
  scope: subscription()
  params: {
    policyName: 'multi-cloud-security-compliance'
    policyDisplayName: 'Multi-Cloud Security Compliance'
    policyDescription: 'Ensures resources comply with multi-cloud security standards'
  }
}

// Monitoring Dashboard
resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: 'dashboard-multicloud-security'
  location: location
  tags: tags
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    content: '## Multi-Cloud Security Dashboard\n\n### Cloud Providers\n- **Azure**: Primary\n- **AWS**: Connected\n- **GCP**: Connected\n\n### Security Metrics\n- Total Alerts: Live\n- Compliance Score: Live\n- Incident Response Time: Live'
                  }
                }
              }
            }
          }
        ]
      }
    ]
  }
}

// Outputs for cross-cloud integration
output workspaceId string = logAnalyticsWorkspace.id
output workspaceKey string = listKeys(logAnalyticsWorkspace.id, '2022-10-01').primarySharedKey
output keyVaultUri string = keyVault.properties.vaultUri
output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, '2023-01-01').keys[0].value}'
output eventHubConnectionString string = listKeys('${eventHubNamespace.id}/authorizationRules/RootManageSharedAccessKey', '2022-10-01-preview').primaryConnectionString
output dataFactoryName string = dataFactory.name 
