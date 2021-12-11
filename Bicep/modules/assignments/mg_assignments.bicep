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
param appGatewayAlerts object
param logAnalytics string
param vmBackup object

// POLICY ASSIGNMENTS
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
    policyDefinitionId: customInitiativeIds[0] // maps to iam_initiative in mg_initiatives.bicep
  }
}

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
    policyDefinitionId: customInitiativeIds[1] // maps to tagging_initiative in mg_initiatives.bicep
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

resource monitoring_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'monitoring_assignment'
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Application Gateway Monitoring Governance Assignment - MG Scope'
    description: 'Application Gateway Monitoring Governance Assignment MG Scope via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '1.0.0'
    }
    policyDefinitionId: customInitiativeIds[2] // maps to monitoring_initiative in mg_initiatives.bicep
    parameters: {
      metricName: {
        value: appGatewayAlerts.clientRtt.metricName
      }
      operator: {
        value: appGatewayAlerts.clientRtt.operator
      }
      timeAggregation: {
        value: appGatewayAlerts.clientRtt.timeAggregation
      }
      dimensions: {
        value: appGatewayAlerts.clientRtt.dimensions
      }
      description: {
        value: appGatewayAlerts.clientRtt.description
      }
      actionGroupName: {
        value: appGatewayAlerts.clientRtt.actionGroupName
      }
      actionGroupRG: {
        value: appGatewayAlerts.clientRtt.actionGroupRG
      }
    }
  }
}

resource kv_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'kv_assignment'
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'KeyVault Governance Assignment - MG Scope'
    description: 'KeyVault Governance Assignment MG Scope via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '1.0.0'
    }
    policyDefinitionId: customInitiativeIds[3] // maps to kv_initiative in mg_initiatives.bicep
    parameters: {
      logAnalytics: {
        value: logAnalytics
      }
      effect: {
        value: 'Audit'
      }
    }
  }
}

resource dp_assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'dp_assignment'
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Data Protection Governance Assignment - MG Scope'
    description: 'Data Protection Governance Assignment MG Scope via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '1.0.0'
    }
    policyDefinitionId: customInitiativeIds[4] // maps to dp_initiative in mg_initiatives.bicep
    parameters: {
      vaultLocation: {
        value: vmBackup.ConfigureBackupOnVirtualMachinesWithAGivenTagToAnExistingRecoveryServicesVaultInTheSameLocation.vaultLocation
      }
      inclusionTagName: {
        value: vmBackup.ConfigureBackupOnVirtualMachinesWithAGivenTagToAnExistingRecoveryServicesVaultInTheSameLocation.inclusionTagName
      }
      inclusionTagValue: {
        value: vmBackup.ConfigureBackupOnVirtualMachinesWithAGivenTagToAnExistingRecoveryServicesVaultInTheSameLocation.inclusionTagValue
      }
      backupPolicyId: {
        value: vmBackup.ConfigureBackupOnVirtualMachinesWithAGivenTagToAnExistingRecoveryServicesVaultInTheSameLocation.backupPolicyId
      }
      effect2: {
        value: vmBackup.ConfigureBackupOnVirtualMachinesWithAGivenTagToAnExistingRecoveryServicesVaultInTheSameLocation.effect
      }
    }
  }
}

// ROLE ASSIGNMENTS - required for policy assignment managed identity to have permissions to assignment scope
resource tagging_roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(tagging_assignment.name, tagging_assignment.type)
  properties: {
    principalId: tagging_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor role for deployIfNotExists/modify effects
  }
}

resource monitoring_roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(monitoring_assignment.name, monitoring_assignment.type)
  properties: {
    principalId: monitoring_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor role for deployIfNotExists/modify effects
  }
}

resource dp_roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(dp_assignment.name, dp_assignment.type)
  properties: {
    principalId: dp_assignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor role for deployIfNotExists/modify effects
  }
}

// OUTPUTS
output policyAssignmentIds array = [
  iam_assignment.id
  tagging_assignment.id
  monitoring_assignment.id
  kv_assignment.id
  dp_assignment.id
]

output roleAssignmentIds array = [
  tagging_roleassignment.id
  monitoring_roleassignment.id
  dp_roleassignment.id
]
