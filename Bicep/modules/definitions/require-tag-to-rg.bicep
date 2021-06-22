targetScope = 'subscription'

// PARAMETERS
param policySource string = 'Bicep'
param policyCategory string = 'Custom'
param mandatoryTag2Key string

// VARIABLES

// OUTPUTS
output policyID string = policy.id
output policyName string = policy.name
output policyDisplayName string = policy.properties.displayName

// RESOURCES
resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'requireTagToRG_${mandatoryTag2Key}'
  properties: {
    displayName: 'Add tag ${mandatoryTag2Key} to resource group'
    policyType: 'Custom'
    mode: 'All'
    description: 'Requires a mandatory tag key when any resource group missing this tag is created or updated.'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Mandatory Tag ${mandatoryTag2Key}'
          description: 'Name of the tag, such as ${mandatoryTag2Key}'
        }
        defaultValue: mandatoryTag2Key
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Resources/subscriptions/resourceGroups'
          }
          {
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            exists: 'false'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
