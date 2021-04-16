targetScope = 'subscription'

// PARAMETERS
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param assignmentEnforcementMode string = 'Default'
param assignmentIdentityLocation string = 'australiaeast'
param mandatoryTag1Key string = 'BicepTagName'
param mandatoryTag1Value string = 'tempvalue'
param listOfAllowedLocations array = [
  'australiaeast'
  'australiasoutheast'
]
param listOfAllowedSKUs array = [
  'Standard_B1ls'
  'Standard_B1ms'
  'Standard_B1s'
  'Standard_B2ms'
  'Standard_B2s'
  'Standard_B4ms'
  'Standard_B4s'
]

// RESOURCES
module definitions './definitions.bicep' = {
  name: 'definitions'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    mandatoryTag1Key: mandatoryTag1Key
    mandatoryTag1Value: mandatoryTag1Value
  }
}

module initiatives './initiatives.bicep' = {
  name: 'initiatives'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    mandatoryTag1Key: mandatoryTag1Key
    mandatoryTag1Value: mandatoryTag1Value
    customPolicyID: definitions.outputs.policyID
  }
}

module assignments './assignments.bicep' = {
  name: 'assignments'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    assignmentIdentityLocation: assignmentIdentityLocation
    assignmentEnforcementMode: assignmentEnforcementMode
    listOfAllowedLocations: listOfAllowedLocations
    listOfAllowedSKUs: listOfAllowedSKUs
    mandatoryTag1Key: mandatoryTag1Key
    mandatoryTag1Value: mandatoryTag1Value
    initiative1ID: initiatives.outputs.initiative1ID
    initiative2ID: initiatives.outputs.initiative2ID
  }
}
