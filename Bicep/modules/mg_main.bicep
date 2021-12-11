targetScope = 'managementGroup'

// PARAMETERS
@description('Name of new Resource Group created for supporting resources e.g. "Action Group".')
param resourceGroupName string = 'ActionGroupRG'

@description('Location of new Resource Group e.g. "australiaeast".')
param resourceGrouplocation string = 'australiaeast'

@description('Resource name of action group.')
param actionGroupName string = 'Operations'

@description('Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param actionGroupEnabled bool = true

@description('The short name of the action group.')
param actionGroupShortName string = 'ops'

@description('The name of the email receiver.')
param actionGroupEmailName string = 'jloudon'

@description('The email address of this receiver.')
param actionGroupEmail string = 'testemail@mail.com'

@description('Indicates whether to use common alert schema.')
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
param logAnalytics string = ''
param effect string = 'Modify'
param appGatewayAlerts object = {}
param vmBackup object = {}

// RESOURCE GROUPS MODULE
module rg './other-resources/resourceGroups.bicep' = {
  name: 'resourceGroups'
  scope: subscription(subscriptionId)
  params: {
    resourceGroupName: resourceGroupName
    resourceGrouplocation: resourceGrouplocation
  }
}

// ACTION GROUPS MODULE
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

// POLICY DEFINITIONS MODULE
module mg_definitions './definitions/mg_definitions.bicep' = {
  name: 'mg_definitions'
}

// POLICYSET DEFINITIONS MODULE
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
  }
}

// POLICY ASSIGNMENTS MODULE
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
    tagNames: tagNames
    tagValue: tagValue
    tagValuesToIgnore: tagValuesToIgnore
    effect: effect
    appGatewayAlerts: appGatewayAlerts
    logAnalytics: logAnalytics
    vmBackup: vmBackup
  }
}

// POLICY EXEMPTIONS MODULE
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

// POLICY REMEDIATIONS MODULE
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

// OUTPUTS 
output resourceNamesForCleanup array = [ // outputs here can be consumed by an .azcli script to delete deployed resources
  rg.outputs.resourceGroupName
  ag.outputs.actionGroupName
  mg_definitions.outputs.customPolicyIds
  mg_initiatives.outputs.customInitiativeIds
  mg_assignments.outputs.policyAssignmentIds
  mg_assignments.outputs.roleAssignmentIds
]
