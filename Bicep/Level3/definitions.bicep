targetScope = 'subscription'

// PARAMETERS
param policySource string
param policyCategory string
param mandatoryTag1Key string
param mandatoryTag1Value string

// VARIABLES

// OUTPUTS
output policyID string = policy.id

// RESOURCES
resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  //level2
  name: 'addTagToRG'
  properties: {
    displayName: 'Add tag to resource group'
    policyType: 'Custom'
    mode: 'All'
    description: 'Adds the mandatory tag key when any resource group missing this tag is created or updated. Existing resource groups can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed.'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'Mandatory Tag ${mandatoryTag1Key}'
          description: 'Name of the tag, such as ${mandatoryTag1Key}'
        }
        defaultValue: 'BicepTagName'
      }
      tagValue: {
        type: 'String'
        metadata: {
          displayName: 'Tag Value ${mandatoryTag1Value}'
          description: 'Value of the tag, such as ${mandatoryTag1Value}'
        }
        defaultValue: 'tempvalue'
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
        effect: 'modify'
        details: {
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          operations: [
            {
              operation: 'add'
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              value: '[parameters(\'tagValue\')]'
            }
          ]
        }
      }
    }
  }
}
