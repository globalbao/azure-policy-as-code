targetScope = 'subscription'

// PARAMETERS
param resourceGroupName string = 'ActionGroupRG'
param resourceGrouplocation string = 'australiaeast'
param actionGroupName string = 'Operations'
param actionGroupEnabled bool = true
param actionGroupShortName string = 'ops'
param actionGroupEmailName string = 'jloudon'
param actionGroupEmail string = 'testemail@mail.com'
param actionGroupAlertSchema bool = true
param assignmentEnforcementMode string = 'Default'
param assignmentIdentityLocation string = 'australiaeast'
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param tagNames array = []
param tagValue string = ''
param tagValuesToIgnore array = []
param remediationTrigger bool = false
param remediationDiscoveryMode string = 'ExistingNonCompliant'
param remedationPolicyDefinitionReferenceId string = ''
param exemptionTrigger bool = false
param exemptionPolicyDefinitionReferenceIds array = []
param exemptionResourceGroupName string = ''
param exemptionCategory string = ''
param exemptionDisplayName string = ''
param exemptionDescription string = ''
param exemptionExpiryDate string = ''
param effect string = 'Modify'

// OUTPUTS 
output resourceNamesForCleanup array = [ // outputs here can be consumed by an .azcli script to delete deployed resources
  rg.outputs.resourceGroupName
  ag.outputs.actionGroupName
  sub_definitions.outputs.customPolicyIds
  sub_initiatives.outputs.customInitiativeIds
  sub_assignments.outputs.policyAssignmentIds
  sub_assignments.outputs.roleAssignmentIds
]

// RESOURCES
module rg './other-resources/resourceGroups.bicep' = {
  name: 'resourceGroups'
  params: {
    resourceGroupName: resourceGroupName
    resourceGrouplocation: resourceGrouplocation
  }
}

module ag './other-resources/actionGroups.bicep' = {
  name: 'actionGroups'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
  params: {
    actionGroupName: actionGroupName
    actionGroupEnabled: actionGroupEnabled
    actionGroupShortName: actionGroupShortName
    actionGroupEmailName: actionGroupEmailName
    actionGroupEmail: actionGroupEmail
    actionGroupAlertSchema: actionGroupAlertSchema
  }
}

module sub_definitions './definitions/sub_definitions.bicep' = {
  name: 'sub_definitions'
}


module sub_initiatives './initiatives/sub_initiatives.bicep' = {
  name: 'sub_initiatives'
  dependsOn: [
    sub_definitions
  ]
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: sub_definitions.outputs.customPolicyIds
    customPolicyNames: sub_definitions.outputs.customPolicyNames
  }
}

module sub_assignments './assignments/sub_assignments.bicep' = {
  name: 'sub_assignments'
  dependsOn: [
    sub_initiatives
  ]
  params: {
    policySource: policySource
    assignmentIdentityLocation: assignmentIdentityLocation
    assignmentEnforcementMode: assignmentEnforcementMode
    customInitiativeIds: sub_initiatives.outputs.customInitiativeIds
    tagNames: tagNames
    tagValue: tagValue
    tagValuesToIgnore: tagValuesToIgnore
    effect: effect
  }
}

module exemptions './exemptions/exemptions.bicep' = if (exemptionTrigger == true) {
  scope: resourceGroup(exemptionResourceGroupName)
  name: 'exemptions'
  params: {
    policySource: policySource
    exemptionPolicyAssignmentId: sub_assignments.outputs.policyAssignmentIds[0] //tagging_assignment
    exemptionPolicyDefinitionReferenceIds: exemptionPolicyDefinitionReferenceIds
    exemptionCategory: exemptionCategory
    exemptionDisplayName: exemptionDisplayName
    exemptionDescription: exemptionDescription
    exemptionExpiryDate: exemptionExpiryDate
  }
}

module sub_remediations './remediations/sub_remediations.bicep' = if (remediationTrigger == true) {
  name: 'sub_remediations'
  dependsOn: [
    sub_initiatives
  ]
  params: {
    remediationPolicyAssignmentId: sub_assignments.outputs.policyAssignmentIds[0] //tagging_assignment
    remediationPolicyDefinitionReferenceId: remedationPolicyDefinitionReferenceId
    remediationDiscoveryMode: remediationDiscoveryMode
  }
}
