// PARAMETERS
param policySource string = 'Bicep'
param exemptionPolicyAssignmentId string
param exemptionPolicyDefinitionReferenceIds array
param exemptionCategory string = 'Mitigated'
param exemptionExpiryDate string
param exemptionDisplayName string
param exemptionDescription string

// RESOURCES
resource exemption_1 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: 'exemption_1'
  properties: {
    policyAssignmentId: exemptionPolicyAssignmentId
    policyDefinitionReferenceIds: [
      exemptionPolicyDefinitionReferenceIds[0]
    ]
    exemptionCategory: exemptionCategory
    expiresOn: exemptionExpiryDate
    displayName: exemptionDisplayName
    description: exemptionDescription
    metadata: {
      version: '1.0.0'
      source: policySource
    }
  }
}

// OUTPUTS
output exemptionIds array = [
  exemption_1.id
]
