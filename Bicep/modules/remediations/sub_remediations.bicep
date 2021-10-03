targetScope = 'subscription'

// PARAMETERS
param remediationPolicyAssignmentId string
param remediationPolicyDefinitionReferenceId string

@allowed([
  'ExistingNonCompliant'
  'ReEvaluateCompliance'
])
param remediationDiscoveryMode string = 'ExistingNonCompliant'

// RESOURCES
resource sub_remediation 'Microsoft.PolicyInsights/remediations@2019-07-01' = {
  name: 'sub_remediation'
  properties: {
    policyAssignmentId: remediationPolicyAssignmentId
    policyDefinitionReferenceId: remediationPolicyDefinitionReferenceId
    resourceDiscoveryMode: remediationDiscoveryMode
  }
}
