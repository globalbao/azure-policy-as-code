targetScope = 'subscription'

// PARAMETERS
param resourceGroupName string
param actionGroupName string
param actionGroupID string
param dcrResourceID string
param policySource string
param policyCategory string
param mandatoryTag1Key string
param mandatoryTag1Value string
param mandatoryTag2Key string

// OUTPUTS
output tagGovernancePolicies array = [
  {
    id: policy2.outputs.policyID
    name: policy2.outputs.policyName
  }
  {
    id: policy3.outputs.policyID
    name: policy3.outputs.policyName
  }
]

output monitoringGovernancePolicies array = [
  {
    id: policy0.outputs.policyID
    name: policy0.outputs.policyName
  }
  {
    id: policy1.outputs.policyID
    name: policy1.outputs.policyName
  }
]

// RESOURCES
module policy0 './azmonitor-metricalert-and-actiongroup.bicep' = {
  name: 'azmonitor-metricalert-and-actiongroup'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    actionGroupName: actionGroupName
    actionGroupRG: resourceGroupName
    actionGroupID: actionGroupID
  }
}

module policy1 './azmonitor-agent-and-dcr-association.bicep' = {
  name: 'azmonitor-agent-and-dcr-association'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    dcrResourceID: dcrResourceID
  }
}

module policy2 './add-tag-to-rg.bicep' = {
  name: 'add-tag-to-rg'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    mandatoryTag1Key: mandatoryTag1Key
    mandatoryTag1Value: mandatoryTag1Value
  }
}

module policy3 './require-tag-to-rg.bicep' = {
  name: 'require-tag-to-rg'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    mandatoryTag2Key: mandatoryTag2Key
  }
}
