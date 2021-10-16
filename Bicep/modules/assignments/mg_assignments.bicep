targetScope = 'managementGroup'

// PARAMETERS
param policySource string = 'Bicep'
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param customInitiativeIds array
param tagNames array
param tagValue string
param tagValuesToIgnore array
param effect string

// POLICY ASSIGNMENTS
resource tagging_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'tagging_assignment'
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Tag Governance Assignment - MG Scope'
    description: 'Tag Governance Assignment MG Scope via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '1.0.0'
    }
    policyDefinitionId: customInitiativeIds[1]
    parameters: {
      tagName1: {
        value: tagNames[0]
      }
      tagName2: {
        value: tagNames[1]
      }
      tagName3: {
        value: tagNames[2]
      }
      tagValue: {
        value: tagValue
      }
      tagValuesToIgnore: {
        value: tagValuesToIgnore
      }
      effect: {
        value: effect
      }
    }
  }
}

resource iam_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'iam_assignment'
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'IAM Governance Assignment - MG Scope'
    description: 'Identity & Access Management Governance Assignment MG Scope via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '1.0.0'
    }
    policyDefinitionId: customInitiativeIds[0]
  }
}

// ROLE ASSIGNMENTS - required for policy assignment managed identity to have required permissions to assignment scope
resource tagging_roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(tagging_assignment.name, tagging_assignment.type)
  properties: {
    principalId: tagging_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor RBAC role for deployIfNotExists/modify effects
  }
}

// OUTPUTS
output policyAssignmentIds array = [
  tagging_assignment.id
  iam_assignment.id
]

output roleAssignmentIds array = [
  tagging_roleassignment.id
]
