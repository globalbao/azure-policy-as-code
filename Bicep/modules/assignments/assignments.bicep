targetScope = 'subscription'

// PARAMETERS
param policySource string = 'Bicep'
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param nonComplianceMessageContactEmail string
param monitoringGovernanceID string
param tagGovernanceID string

// OUTPUTS
output assignmentNames array = [
  monitoringGovernanceAssignment.name
  tagGovernanceAssignment.name
]

output roleAssignmentIDs array = [
  monitoringGovernanceRoleAssignment.id
  tagGovernanceRoleAssignment.id
]

// RESOURCES
resource monitoringGovernanceAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'monitoringGovernanceAssignment'
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Monitoring Governance Assignment'
    description: 'Monitoring Governance Assignment via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '0.1.0'
    }
    policyDefinitionId: monitoringGovernanceID
    nonComplianceMessages: [
      {
        message: 'Your Resource deployment is not compliant with the Monitoring Governance Assignment/Initiative policy. Please contact ${nonComplianceMessageContactEmail}'
      }
    ]
  }
}

resource tagGovernanceAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'tagGovernanceAssignment'
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Tag Governance Assignment'
    description: 'Tag Governance Assignment via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '0.1.0'
    }
    policyDefinitionId: tagGovernanceID
    nonComplianceMessages: [
      {
        message: 'Your Resource deployment is not compliant with the Tag Governance Assignment/Initiative policy. Please contact ${nonComplianceMessageContactEmail}'
      }
    ]
  }
}

resource monitoringGovernanceRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(monitoringGovernanceAssignment.name, monitoringGovernanceAssignment.type, subscription().subscriptionId)
  properties: {
    principalId: monitoringGovernanceAssignment.identity.principalId
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor RBAC role for deployIfNotExists/modify effects
  }
}

resource tagGovernanceRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(tagGovernanceAssignment.name, tagGovernanceAssignment.type, subscription().subscriptionId)
  properties: {
    principalId: tagGovernanceAssignment.identity.principalId
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor RBAC role for deployIfNotExists/modify effects
  }
}
