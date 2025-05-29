targetScope = 'subscription'

@description('Policy name')
param policyName string

@description('Policy display name')
param policyDisplayName string

@description('Policy description')
param policyDescription string

resource compliancePolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: policyName
  properties: {
    displayName: policyDisplayName
    description: policyDescription
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Security'
      version: '1.0.0'
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            in: [
              'Microsoft.Storage/storageAccounts'
              'Microsoft.KeyVault/vaults'
              'Microsoft.Compute/virtualMachines'
            ]
          }
          {
            field: 'tags[\'MultiCloud\']'
            exists: 'true'
          }
        ]
      }
      then: {
        effect: 'audit'
        details: {
          type: 'Microsoft.Security/complianceResults'
          evaluationDelay: 'AfterProvisioning'
        }
      }
    }
  }
}

output policyId string = compliancePolicy.id 
