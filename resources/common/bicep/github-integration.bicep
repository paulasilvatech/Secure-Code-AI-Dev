@description('The name of the Key Vault')
param keyVaultName string

@description('The name of the Log Analytics workspace')
param workspaceName string

@description('The location for resources')
param location string

@description('Tags to apply to resources')
param tags object

// Get existing resources
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}

// Function App for GitHub Webhook Processing
var functionAppName = 'func-github-webhook-${uniqueString(resourceGroup().id)}'
var hostingPlanName = 'asp-github-webhook-${uniqueString(resourceGroup().id)}'
var functionStorageName = 'stfunc${uniqueString(resourceGroup().id)}'

// Storage Account for Function App
resource functionStorage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: functionStorageName
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
  }
}

// App Service Plan for Function App
resource hostingPlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: hostingPlanName
  location: location
  tags: tags
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  properties: {
    reserved: true
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2023-01-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.9'
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionStorage.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${functionStorage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${functionStorage.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'WORKSPACE_ID'
          value: workspace.properties.customerId
        }
        {
          name: 'WORKSPACE_KEY'
          value: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=workspace-key)'
        }
        {
          name: 'GITHUB_WEBHOOK_SECRET'
          value: '@Microsoft.KeyVault(VaultName=${keyVault.name};SecretName=github-webhook-secret)'
        }
      ]
      cors: {
        allowedOrigins: [
          'https://github.com'
        ]
      }
    }
    httpsOnly: true
  }
}

// Key Vault access for Function App
resource keyVaultAccessPolicy 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, functionApp.id, 'Key Vault Secrets User')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: functionApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// Log Analytics Contributor role for Function App
resource logAnalyticsRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(workspace.id, functionApp.id, 'Log Analytics Contributor')
  scope: workspace
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
    principalId: functionApp.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

// Logic App for GitHub Integration Orchestration
var logicAppName = 'logic-github-integration-${uniqueString(resourceGroup().id)}'

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
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
      parameters: {}
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {
              type: 'object'
              properties: {
                action: {
                  type: 'string'
                }
                repository: {
                  type: 'object'
                }
                alert: {
                  type: 'object'
                }
              }
            }
          }
        }
      }
      actions: {
        Parse_GitHub_Event: {
          type: 'ParseJson'
          inputs: {
            content: '@triggerBody()'
            schema: {
              type: 'object'
              properties: {
                action: {
                  type: 'string'
                }
                repository: {
                  type: 'object'
                  properties: {
                    full_name: {
                      type: 'string'
                    }
                  }
                }
                alert: {
                  type: 'object'
                  properties: {
                    severity: {
                      type: 'string'
                    }
                    rule: {
                      type: 'object'
                    }
                  }
                }
              }
            }
          }
        }
        Send_to_Sentinel: {
          type: 'Http'
          inputs: {
            method: 'POST'
            uri: 'https://${functionApp.properties.defaultHostName}/api/github-to-sentinel'
            body: '@body(\'Parse_GitHub_Event\')'
            authentication: {
              type: 'ManagedServiceIdentity'
            }
          }
          runAfter: {
            Parse_GitHub_Event: [
              'Succeeded'
            ]
          }
        }
      }
    }
  }
}

// API Connection for GitHub
resource githubConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: 'github-connection'
  location: location
  tags: tags
  properties: {
    displayName: 'GitHub Connection'
    api: {
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis', location, 'github')
    }
    parameterValues: {}
  }
}

// Custom Table in Log Analytics for GitHub Alerts
resource githubAlertsTable 'Microsoft.OperationalInsights/workspaces/tables@2022-10-01' = {
  parent: workspace
  name: 'GitHubSecurityAlerts_CL'
  properties: {
    schema: {
      name: 'GitHubSecurityAlerts_CL'
      columns: [
        {
          name: 'TimeGenerated'
          type: 'DateTime'
        }
        {
          name: 'Repository'
          type: 'String'
        }
        {
          name: 'AlertName'
          type: 'String'
        }
        {
          name: 'AlertType'
          type: 'String'
        }
        {
          name: 'Severity'
          type: 'String'
        }
        {
          name: 'State'
          type: 'String'
        }
        {
          name: 'AlertUrl'
          type: 'String'
        }
        {
          name: 'DismissedReason'
          type: 'String'
        }
        {
          name: 'DismissedBy'
          type: 'String'
        }
        {
          name: 'CreatedAt'
          type: 'DateTime'
        }
        {
          name: 'UpdatedAt'
          type: 'DateTime'
        }
      ]
    }
    retentionInDays: 90
  }
}

// Outputs
output functionAppName string = functionApp.name
output functionAppUrl string = 'https://${functionApp.properties.defaultHostName}'
output webhookUrl string = 'https://${functionApp.properties.defaultHostName}/api/github-webhook'
output logicAppUrl string = 'https://management.azure.com${logicApp.id}/triggers/manual/paths/invoke' 
