targetScope = 'subscription'

// PARAMETERS
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param customPolicyIds array
param customPolicyNames array

// POLICYSET MODULES
module tagging_initiative './sub_tagging.bicep' = {
  name: 'tagging_initiative'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: customPolicyIds
    customPolicyNames: customPolicyNames
  }
}

module iam_initiative './sub_iam.bicep' = {
  name: 'iam_initiative'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: customPolicyIds
    customPolicyNames: customPolicyNames
  }
}

module monitoring_initiative './sub_monitoring.bicep' = {
  name: 'monitoring_initiative'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: customPolicyIds
    customPolicyNames: customPolicyNames
  }
}

module kv_initiative './sub_keyvault.bicep' = {
  name: 'kv_initiative'
  params: {
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: customPolicyIds
    customPolicyNames: customPolicyNames
  }
}

module dp_initiative './sub_data_protection.bicep' = {
  name: 'dp_initiative'
  params: {
    policySource: policySource
    policyCategory: policyCategory
  }
}

// OUTPUTS
output customInitiativeIds array = [
  iam_initiative.outputs.customInitiativeId
  tagging_initiative.outputs.customInitiativeId
  monitoring_initiative.outputs.customInitiativeId
  kv_initiative.outputs.customInitiativeId
  dp_initiative.outputs.customInitiativeId
]
