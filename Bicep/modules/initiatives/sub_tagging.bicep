targetScope = 'subscription'

// PARAMETERS
param policySource string = 'Bicep'
param policyCategory string = 'Custom'
param customPolicyIds array
param customPolicyNames array

// CUSTOM POLICYSETS
resource tagging_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'tagging_initiative'
  properties: {
    policyType: 'Custom'
    displayName: 'Tagging Governance Initiative - Sub Scope'
    description: 'Tagging Governance Initiative Sub Scope via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '1.0.0'
    }
    parameters: {
      tagName1: {
        type: 'String'
        metadata: {
          displayName: 'Tag Name1'
          description: 'Name of the tag, such as "CostCenter"'
        }
        defaultValue: 'CostCenter'
      }
      tagName2: {
        type: 'String'
        metadata: {
          displayName: 'Tag Name2'
          description: 'Name of the tag, such as "Application"'
        }
        defaultValue: 'Application'
      }
      tagName3: {
        type: 'String'
        metadata: {
          displayName: 'Tag Name3'
          description: 'Name of the tag, such as "Environment"'
        }
        defaultValue: 'Environment'
      }
      tagValue: {
        type: 'String'
        metadata: {
          displayName: 'Tag Value'
          description: 'Value of the tag e.g. "TBC"'
        }
        defaultValue: 'TBC'
      }
      tagValuesToIgnore: {
        type: 'Array'
        metadata: {
          displayName: 'Tag values to ignore for inheritance'
          description: 'A list of tag values to ignore when evaluating tag inheritance from the RG'
        }
        defaultValue: []
      }
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'Audit'
          'Modify'
          'Disabled'
        ]
        defaultValue: 'Modify'
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: customPolicyIds[3] //policy to add tagName1 to RGs
        policyDefinitionReferenceId: 'tagName1-${customPolicyNames[3]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName1\')]'
          }
          tagValue: {
            value: '[parameters(\'tagValue\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[3] //policy to add tagName2 to RGs
        policyDefinitionReferenceId: 'tagName2-${customPolicyNames[3]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName2\')]'
          }
          tagValue: {
            value: '[parameters(\'tagValue\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[3] //policy to add tagName3 to RGs
        policyDefinitionReferenceId: 'tagName3-${customPolicyNames[3]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName3\')]'
          }
          tagValue: {
            value: '[parameters(\'tagValue\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[6] //policy to inherit tagName1 from RGs & overwrite existing
        policyDefinitionReferenceId: 'tagName1-${customPolicyNames[6]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName1\')]'
          }
          tagValuesToIgnore: {
            value: '[parameters(\'tagValuesToIgnore\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[6] //policy to inherit tagName2 from RGs & overwrite existing
        policyDefinitionReferenceId: 'tagName2-${customPolicyNames[6]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName2\')]'
          }
          tagValuesToIgnore: {
            value: '[parameters(\'tagValuesToIgnore\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[6] //policy to inherit tagName3 from RGs & overwrite existing
        policyDefinitionReferenceId: 'tagName3-${customPolicyNames[6]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName3\')]'
          }
          tagValuesToIgnore: {
            value: '[parameters(\'tagValuesToIgnore\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[5] //policy to inherit tagName1 from RGs when no tag exists
        policyDefinitionReferenceId: 'tagName1-${customPolicyNames[5]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName1\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[5] //policy to inherit tagName2 from RGs when no tag exists
        policyDefinitionReferenceId: 'tagName2-${customPolicyNames[5]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName2\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[5] //policy to inherit tagName3 from RGs when no tag exists
        policyDefinitionReferenceId: 'tagName3-${customPolicyNames[5]}'
        parameters: {
          tagName: {
            value: '[parameters(\'tagName3\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
    ]
  }
}

// OUTPUTS
output customInitiativeId string = tagging_initiative.id
