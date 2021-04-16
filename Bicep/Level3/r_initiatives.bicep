targetScope = 'subscription'

// PARAMETERS
param policySource string
param policyCategory string
param mandatoryTag1Key string
param mandatoryTag1Value string
param customPolicyID string //level3

// VARIABLES
var initiative1Name = 'Initiative1'
var initiative2Name = 'Initiative2'

// OUTPUTS
output initiative1ID string = initiative1.id
output initiative2ID string = initiative2.id

// RESOURCES
resource initiative1 'Microsoft.Authorization/policySetDefinitions@2019-09-01' = {
  name: initiative1Name
  properties: {
    policyType: 'Custom'
    displayName: initiative1Name
    description: '${initiative1Name} via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {
      listOfAllowedLocations: {
        type: 'Array'
        metadata: ({
          description: 'The List of Allowed Locations for Resource Groups and Resources.'
          strongtype: 'location'
          displayName: 'Allowed Locations'
        })
      }
      listOfAllowedSKUs: {
        type: 'Array'
        metadata: any({
          description: 'The List of Allowed SKUs for Virtual Machines.'
          strongtype: 'vmSKUs'
          displayName: 'Allowed Virtual Machine Size SKUs'
        })
      }
    }
    policyDefinitions: [
      {
        //Allowed locations for resource groups
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'listOfAllowedLocations\')]'
          }
        }
      }
      {
        //Allowed locations
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'listOfAllowedLocations\')]'
          }
        }
      }
      {
        //Allowed virtual machine size SKUs
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
        parameters: {
          listOfAllowedSKUs: {
            value: '[parameters(\'listOfAllowedSKUs\')]'
          }
        }
      }
      {
        //Audit virtual machines without disaster recovery configured
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56'
        parameters: {}
      }
    ]
  }
}

resource initiative2 'Microsoft.Authorization/policySetDefinitions@2019-09-01' = {
  //level2
  name: initiative2Name
  properties: {
    policyType: 'Custom'
    displayName: initiative2Name
    description: '${initiative2Name} via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '0.1.0'
    }
    parameters: {
      tagName: {
        type: 'String'
        metadata: ({
          displayName: 'Mandatory Tag ${mandatoryTag1Key}'
          description: 'Name of the tag, such as ${mandatoryTag1Key}'
        })
      }
      tagValue: {
        type: 'String'
        metadata: ({
          displayName: 'Tag Value ${mandatoryTag1Value}'
          description: 'Value of the tag, such as ${mandatoryTag1Value}'
        })
      }
    }
    policyDefinitions: [
      {
        //Add tag to resource group
        policyDefinitionId: customPolicyID //level3
        parameters: {
          tagName: {
            value: '[parameters(\'tagName\')]'
          }
          tagValue: {
            value: '[parameters(\'tagValue\')]'
          }
        }
      }
    ]
  }
}
