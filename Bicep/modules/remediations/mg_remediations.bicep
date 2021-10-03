targetScope = 'managementGroup'

// PARAMETERS
param remediationPolicyAssignmentId string
param remediationPolicyDefinitionReferenceId string

@allowed([
  'ExistingNonCompliant'
  'ReEvaluateCompliance'
])
param remediationDiscoveryMode string = 'ExistingNonCompliant'

// RESOURCES
resource mg_remediation 'Microsoft.PolicyInsights/remediations@2019-07-01' = {
  name: 'mg_remediation'
  properties: {
    policyAssignmentId: remediationPolicyAssignmentId
    policyDefinitionReferenceId: remediationPolicyDefinitionReferenceId
    resourceDiscoveryMode: remediationDiscoveryMode
  }
}
