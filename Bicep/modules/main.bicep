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
param policySource string = 'bicep-policy-examples'
param policyCategory string = 'Custom'
param nonComplianceMessageContactEmail string = 'testemail@mail.com'
param mandatoryTag1Key string = 'CostCentre'
param mandatoryTag1Value string = '123456'


// RESOURCES
module rg './other-resources/resourceGroups.bicep' = {
  name: 'resourceGroups'
  params: {
    resourceGroupName: resourceGroupName
    resourceGrouplocation: resourceGrouplocation
  }
}

module ag './other-resources/actionGroups.bicep' = {
  dependsOn: [
    rg
  ]
  scope: resourceGroup(resourceGroupName)
  name: 'actionGroups'
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
    resourceGrouplocation: resourceGrouplocation
    actionGroupName: ag.outputs.actionGroupName
    actionGroupID: ag.outputs.actionGroupID
    actionGroupEnabled: actionGroupEnabled
    actionGroupShortName: actionGroupShortName
    actionGroupEmailName: actionGroupEmailName
    actionGroupEmail: actionGroupEmail
    actionGroupAlertSchema: actionGroupAlertSchema
    assignmentEnforcementMode: assignmentEnforcementMode
    assignmentIdentityLocation: assignmentIdentityLocation
    dcrResourceID: dcrResourceID
    mandatoryTag1Key: mandatoryTag1Key
    mandatoryTag1Value: mandatoryTag1Value
  }
}

module initiatives './initiatives/initiatives.bicep' = {
  name: 'initiatives'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    monitoringGovernancePolicyIDs: [
      definitions.outputs.policyID1
      definitions.outputs.policyID2
    ]
    tagGovernancePolicyIDs: [
      definitions.outputs.policyID3
    ]
  }
}

module assignments './assignments/assignments.bicep' = {
  name: 'assignments'
  params: {
    policySource: policySource
    assignmentIdentityLocation: assignmentIdentityLocation
    assignmentEnforcementMode: assignmentEnforcementMode
    nonComplianceMessageContactEmail: nonComplianceMessageContactEmail
    monitoringGovernanceID: initiatives.outputs.monitoringGovernanceID
    tagGovernanceID: initiatives.outputs.tagGovernanceID
  }
}
