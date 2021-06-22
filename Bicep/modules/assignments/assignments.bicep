targetScope = 'subscription'

// PARAMETERS
param policySource string = 'Bicep'
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param monitoringGovernanceID string
param tagGovernanceID string
param mandatoryTag2Key string

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
        message: '***DENIED*** Missing Mandatory tag. ***DENIED***'
      }
      {
        message: '***DENIED*** Missing ${mandatoryTag2Key} tag. Please update your resource to include the ${mandatoryTag2Key} tag. ***DENIED***'
        policyDefinitionReferenceId: 'requireTagToRG_${mandatoryTag2Key}'
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
