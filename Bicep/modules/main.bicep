targetScope = 'subscription'

// PARAMETERS
param resourceGroupName string = 'BicepExampleRG'
param resourceGrouplocation string = 'australiaeast'
param actionGroupName string = 'BicepExampleAG'
param actionGroupEnabled bool = true
param actionGroupShortName string = 'bicepag'
param actionGroupEmailName string = 'jloudon'
param actionGroupEmail string = 'testemail@mail.com'
param actionGroupAlertSchema bool = true
param assignmentEnforcementMode string = 'Default'
param assignmentIdentityLocation string = 'australiaeast'
param dcrResourceID string = '0123456789'
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param nonComplianceMessageContactEmail string = 'testemail@mail.com'
param mandatoryTag1Key string = 'CostCentre'
param mandatoryTag1Value string = '123456'

// OUTPUTS

// outputs here can be consumed by an .azcli script to delete deployed resources
output resourceNamesForCleanup array = [
  rg.outputs.resourceGroupName
  initiatives.outputs.initiativeNames
  assignments.outputs.assignmentNames
  assignments.outputs.roleAssignmentIDs
  definitions.outputs.policyNames
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

module definitions './definitions/definitions.bicep' = {
  name: 'definitions'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    resourceGroupName: resourceGroupName
    actionGroupName: ag.outputs.actionGroupName
    actionGroupID: ag.outputs.actionGroupID
    dcrResourceID: dcrResourceID
    mandatoryTag1Key: mandatoryTag1Key
    mandatoryTag1Value: mandatoryTag1Value
  }
}

module initiatives './initiatives/initiatives.bicep' = {
  name: 'initiatives'
  dependsOn: [
    definitions
  ]
  params: {
    policySource: policySource
    policyCategory: policyCategory
    monitoringGovernancePolicyIDs: [
      definitions.outputs.policyIDs[0]
      definitions.outputs.policyIDs[1]
    ]
    tagGovernancePolicyIDs: [
      definitions.outputs.policyIDs[2]
    ]
  }
}

module assignments './assignments/assignments.bicep' = {
  name: 'assignments'
  dependsOn: [
    initiatives
  ]
  params: {
    policySource: policySource
    assignmentIdentityLocation: assignmentIdentityLocation
    assignmentEnforcementMode: assignmentEnforcementMode
    nonComplianceMessageContactEmail: nonComplianceMessageContactEmail
    monitoringGovernanceID: initiatives.outputs.initiativeIDs[0]
    tagGovernanceID: initiatives.outputs.initiativeIDs[1]
  }
}
