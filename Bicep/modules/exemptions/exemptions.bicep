// PARAMETERS
param policySource string = 'Bicep'
param mandatoryTag2Key string
param assignmentID string

// VARIABLES

// OUTPUTS

// RESOURCES
resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: 'exemption1'
  properties: {
    policyAssignmentId: assignmentID
    policyDefinitionReferenceIds: [
      'requireTagToRG_${mandatoryTag2Key}'
    ]
    exemptionCategory: 'Mitigated'
    //expiresOn: '2022-12-05'
    displayName: 'Exempt resource from requireTagToRG_${mandatoryTag2Key}'
    description: 'Exempts resource from requireTagToRG_${mandatoryTag2Key} until expiry date'
    metadata: {
      version: '0.1.0'
      source: policySource
    }
  }
}
