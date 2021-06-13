targetScope = 'subscription'

// PARAMETERS
param resourceGroupName string
param resourceGrouplocation string
param actionGroupName string
param actionGroupID string
param actionGroupEnabled bool
param actionGroupShortName string
param actionGroupEmailName string
param actionGroupEmail string
param actionGroupAlertSchema bool
param assignmentEnforcementMode string
param assignmentIdentityLocation string
param dcrResourceID string
param policySource string
param policyCategory string
param mandatoryTag1Key string
param mandatoryTag1Value string

// RESOURCES
output policyID1 string = policy1.outputs.policyID
output policyID2 string = policy2.outputs.policyID
output policyID3 string = policy3.outputs.policyID

// RESOURCES
module policy1 './azmonitor-metricalert-and-actiongroup.bicep' = {
  name: 'azmonitor-metricalert-and-actiongroup'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    actionGroupName: actionGroupName
    actionGroupRG: resourceGroupName
    actionGroupID: actionGroupID
  }
}

module policy2 './azmonitor-agent-and-dcr-association.bicep' = {
  name: 'azmonitor-agent-and-dcr-association'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    dcrResourceID: dcrResourceID
  }
}

module policy3 './add-tag-to-rg.bicep' = {
  name: 'add-tag-to-rg'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    mandatoryTag1Key: mandatoryTag1Key
    mandatoryTag1Value: mandatoryTag1Value
  }
}
