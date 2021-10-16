targetScope = 'managementGroup'

// PARAMETERS
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param customPolicyIds array
param customPolicyNames array

// POLICYSET MODULES
module tagging_initiative './mg_tagging.bicep' = {
  name: 'tagging_initiative'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: customPolicyIds
    customPolicyNames: customPolicyNames
  }
}

module iam_initiative './mg_iam.bicep' = {
  name: 'iam_initiative'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: customPolicyIds
    customPolicyNames: customPolicyNames
  }
}

// OUTPUTS
output customInitiativeIds array = [
  iam_initiative.outputs.customInitiativeId
  tagging_initiative.outputs.customInitiativeId
]

