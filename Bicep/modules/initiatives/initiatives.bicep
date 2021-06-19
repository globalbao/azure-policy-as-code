targetScope = 'subscription'

// PARAMETERS   
param policySource string = 'Bicep'
param policyCategory string = 'Custom'
param monitoringGovernancePolicyIDs array
param tagGovernancePolicyIDs array
// VARIABLES

// OUTPUTS
output initiativeIDs array = [
  monitoringGovernance.id
  tagGovernance.id
]

output initiativeNames array = [
  monitoringGovernance.name
  tagGovernance.name
]

// RESOURCES

resource monitoringGovernance 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'monitoringGovernance'
  properties: {
    policyType: 'Custom'
    displayName: 'Monitoring Governance Initiative'
    description: 'Monitoring Governance Initiative via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {}
    policyDefinitions: [for (policy, index) in monitoringGovernancePolicyIDs: {
      policyDefinitionId: '${policy}'
    }]
  }
}

resource tagGovernance 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'tagGovernance'
  properties: {
    policyType: 'Custom'
    displayName: 'Tag Governance Initiative'
    description: 'Tag Governance Initiative via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {}
    policyDefinitions: [for (policy, index) in tagGovernancePolicyIDs: {
      policyDefinitionId: '${policy}'
    }]
  }
}
