@description('The name of the Log Analytics workspace')
param workspaceName string

@description('The location for resources')
param location string

@description('Tags to apply to resources')
param tags object

// Get existing Log Analytics Workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}

// Enable Microsoft Sentinel on the workspace
resource sentinel 'Microsoft.SecurityInsights/onboardingStates@2023-12-01-preview' = {
  name: 'default'
  scope: workspace
  properties: {}
}

// Security Insights Settings
resource securityInsightsSetting 'Microsoft.SecurityInsights/settings@2023-12-01-preview' = {
  name: 'EntityAnalytics'
  scope: workspace
  kind: 'EntityAnalytics'
  properties: {
    entityProviders: [
      'AzureActiveDirectory'
    ]
  }
  dependsOn: [
    sentinel
  ]
}

// GitHub Data Connector
resource githubDataConnector 'Microsoft.SecurityInsights/dataConnectors@2023-12-01-preview' = {
  name: guid('github-connector', workspace.id)
  scope: workspace
  kind: 'APIPolling'
  properties: {
    connectorUiConfig: {
      title: 'GitHub Advanced Security'
      publisher: 'Microsoft'
      descriptionMarkdown: 'Connect GitHub Advanced Security alerts to Microsoft Sentinel'
      graphQueriesTableName: 'GitHubSecurityAlerts_CL'
      instructionSteps: [
        {
          title: 'Connect GitHub to Microsoft Sentinel'
          description: 'Configure GitHub webhook to send security alerts'
        }
      ]
      permissions: {
        resourceProvider: [
          {
            provider: 'Microsoft.OperationalInsights/workspaces'
            permissionsDisplayText: 'read and write permissions'
            providerDisplayName: 'Workspace'
            requiredPermissions: {
              write: true
              read: true
              delete: true
            }
          }
        ]
      }
    }
    pollingFrequency: 'OnceAMinute'
    dataType: {
      name: 'GitHubSecurityAlerts'
    }
  }
  dependsOn: [
    sentinel
  ]
}

// Azure Activity Data Connector
resource azureActivityConnector 'Microsoft.SecurityInsights/dataConnectors@2023-12-01-preview' = {
  name: guid('azure-activity', workspace.id)
  scope: workspace
  kind: 'AzureActivity'
  properties: {
    linkedResourceId: '/subscriptions/${subscription().subscriptionId}/providers/microsoft.insights/eventtypes/management'
  }
  dependsOn: [
    sentinel
  ]
}

// Azure AD Data Connector
resource azureADConnector 'Microsoft.SecurityInsights/dataConnectors@2023-12-01-preview' = {
  name: guid('azure-ad', workspace.id)
  scope: workspace
  kind: 'AzureActiveDirectory'
  properties: {
    tenantId: subscription().tenantId
    dataTypes: {
      alerts: {
        state: 'Enabled'
      }
    }
  }
  dependsOn: [
    sentinel
  ]
}

// Microsoft Defender for Cloud Data Connector
resource defenderConnector 'Microsoft.SecurityInsights/dataConnectors@2023-12-01-preview' = {
  name: guid('defender-cloud', workspace.id)
  scope: workspace
  kind: 'MicrosoftDefenderAdvancedThreatProtection'
  properties: {
    tenantId: subscription().tenantId
    dataTypes: {
      alerts: {
        state: 'Enabled'
      }
    }
  }
  dependsOn: [
    sentinel
  ]
}

// Threat Intelligence Platforms connector
resource threatIntelligenceConnector 'Microsoft.SecurityInsights/dataConnectors@2023-12-01-preview' = {
  name: guid('threat-intelligence', workspace.id)
  scope: workspace
  kind: 'ThreatIntelligence'
  properties: {
    tenantId: subscription().tenantId
    dataTypes: {
      indicators: {
        state: 'Enabled'
      }
    }
  }
  dependsOn: [
    sentinel
  ]
}

// Analytics Rules for GitHub Security
resource githubSecurityRule 'Microsoft.SecurityInsights/alertRules@2023-12-01-preview' = {
  name: guid('github-critical-alerts', workspace.id)
  scope: workspace
  kind: 'Scheduled'
  properties: {
    displayName: 'Critical Security Alerts from GitHub'
    description: 'Triggers when critical security vulnerabilities are detected in GitHub repositories'
    enabled: true
    query: '''
    GitHubSecurityAlerts_CL
    | where Severity == "critical" or Severity == "high"
    | where State == "open"
    | project TimeGenerated, Repository, AlertName, Severity, AlertUrl
    '''
    queryFrequency: 'PT5M'
    queryPeriod: 'PT5M'
    severity: 'High'
    suppressionDuration: 'PT1H'
    suppressionEnabled: false
    triggerOperator: 'GreaterThan'
    triggerThreshold: 0
    eventGroupingSettings: {
      aggregationKind: 'SingleAlert'
    }
    alertRuleTemplateName: null
    templateVersion: null
  }
  dependsOn: [
    sentinel
  ]
}

// Container Security Analytics Rule
resource containerSecurityRule 'Microsoft.SecurityInsights/alertRules@2023-12-01-preview' = {
  name: guid('container-security-alerts', workspace.id)
  scope: workspace
  kind: 'Scheduled'
  properties: {
    displayName: 'Suspicious Container Activity'
    description: 'Detects suspicious activities in containers'
    enabled: true
    query: '''
    ContainerLog
    | where TimeGenerated > ago(5m)
    | where ContainerName !in ("omsagent", "omsagent-rs")
    | where LogEntry contains "error" or LogEntry contains "failed" or LogEntry contains "denied"
    | project TimeGenerated, ContainerName, LogEntry, Computer
    '''
    queryFrequency: 'PT5M'
    queryPeriod: 'PT5M'
    severity: 'Medium'
    suppressionDuration: 'PT1H'
    suppressionEnabled: false
    triggerOperator: 'GreaterThan'
    triggerThreshold: 5
    eventGroupingSettings: {
      aggregationKind: 'AlertPerResult'
    }
    alertRuleTemplateName: null
    templateVersion: null
  }
  dependsOn: [
    sentinel
  ]
}

// Watchlist for Security Teams
resource securityTeamWatchlist 'Microsoft.SecurityInsights/watchlists@2023-12-01-preview' = {
  name: 'SecurityTeamContacts'
  scope: workspace
  properties: {
    displayName: 'Security Team Contacts'
    description: 'List of security team members for incident assignment'
    provider: 'Microsoft'
    source: 'Local file'
    itemsSearchKey: 'Email'
    contentType: 'text/csv'
    numberOfLinesToSkip: 0
  }
  dependsOn: [
    sentinel
  ]
}

// Outputs
output sentinelEnabled bool = true
output workspaceId string = workspace.id 
