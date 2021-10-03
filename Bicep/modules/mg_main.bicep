targetScope = 'managementGroup'

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
param subscriptionId string = ''
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
param managementGroupId string = ''

// OUTPUTS 
output resourceNamesForCleanup array = [ // outputs here can be consumed by an .azcli script to delete deployed resources
  rg.outputs.resourceGroupName
  ag.outputs.actionGroupName
  mg_definitions.outputs.customPolicyIds
  mg_initiatives.outputs.customInitiativeIds
  mg_assignments.outputs.policyAssignmentIds
  mg_assignments.outputs.roleAssignmentIds
]

// RESOURCES
module rg './other-resources/resourceGroups.bicep' = {
  name: 'resourceGroups'
  scope: subscription(subscriptionId)
  params: {
    resourceGroupName: resourceGroupName
    resourceGrouplocation: resourceGrouplocation
  }
}

module ag './other-resources/actionGroups.bicep' = {
  name: 'actionGroups'
  scope: resourceGroup(subscriptionId, resourceGroupName)
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

module mg_definitions './definitions/mg_definitions.bicep' = {
  name: 'mg_definitions'
}


module mg_initiatives './initiatives/mg_initiatives.bicep' = {
  name: 'mg_initiatives'
  dependsOn: [
    mg_definitions
  ]
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: mg_definitions.outputs.customPolicyIds
    customPolicyNames: mg_definitions.outputs.customPolicyNames
    managementGroupId: managementGroupId
  }
}

module mg_assignments './assignments/mg_assignments.bicep' = {
  name: 'mg_assignments'
  dependsOn: [
    mg_initiatives
  ]
  params: {
    policySource: policySource
    assignmentIdentityLocation: assignmentIdentityLocation
    assignmentEnforcementMode: assignmentEnforcementMode
    customInitiativeIds: mg_initiatives.outputs.customInitiativeIds
    managementGroupId: managementGroupId
    tagNames: tagNames
    tagValue: tagValue
    tagValuesToIgnore: tagValuesToIgnore
    effect: effect
  }
}

module exemptions './exemptions/exemptions.bicep' = if (exemptionTrigger == true) {
  scope: resourceGroup(subscriptionId, exemptionResourceGroupName)
  name: 'exemptions'
  params: {
    policySource: policySource
    exemptionPolicyAssignmentId: mg_assignments.outputs.policyAssignmentIds[0] //tagging_assignment
    exemptionPolicyDefinitionReferenceIds: exemptionPolicyDefinitionReferenceIds
    exemptionCategory: exemptionCategory
    exemptionDisplayName: exemptionDisplayName
    exemptionDescription: exemptionDescription
    exemptionExpiryDate: exemptionExpiryDate
  }
}

module mg_remediations './remediations/mg_remediations.bicep' = if (remediationTrigger == true) {
  name: 'mg_remediations'
  dependsOn: [
    mg_initiatives
  ]
  params: {
    remediationPolicyAssignmentId: mg_assignments.outputs.policyAssignmentIds[0] //tagging_assignment
    remediationPolicyDefinitionReferenceId: remedationPolicyDefinitionReferenceId
    remediationDiscoveryMode: remediationDiscoveryMode
  }
}
