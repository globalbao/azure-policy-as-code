targetScope = 'subscription'

// PARAMETERS
param policySource string
param policyCategory string
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param listOfAllowedLocations array
param listOfAllowedSKUs array
param mandatoryTag1Key string
param mandatoryTag1Value string
param initiative1ID string //level3
param initiative2ID string //level3
param nonComplianceMessageContactEmail string //level3

// VARIABLES
var assignment1Name = 'Initiative1'
var assignment2Name = 'Initiative2'

// OUTPUTS
output assignment1ID string = assignment1.id
output assignment2ID string = assignment2.id

// RESOURCES
resource assignment1 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: assignment1Name
  properties: {
    displayName: assignment1Name
    description: '${assignment1Name} via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '0.1.0'
    }
    policyDefinitionId: initiative1ID //level3
    parameters: {
      listOfAllowedLocations: {
        value: listOfAllowedLocations
      }
      listOfAllowedSKUs: {
        value: listOfAllowedSKUs
      }
    }
    nonComplianceMessages: [
      {
        message: 'Your Resource deployment is not compliant with the ${assignment1Name} policy. Please contact ${nonComplianceMessageContactEmail}'
      }
    ]
  }
}

resource assignment2 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  //level2
  name: assignment2Name
  location: assignmentIdentityLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: assignment2Name
    description: '${assignment2Name} via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: '0.1.0'
    }
    policyDefinitionId: initiative2ID //level3
    parameters: {
      tagName: {
        value: mandatoryTag1Key
      }
      tagValue: {
        value: mandatoryTag1Value
      }
    }
    nonComplianceMessages: [ //level3
      {
        message: 'Your Resource deployment is not compliant with the ${assignment1Name} policy. Please contact ${nonComplianceMessageContactEmail}'
      }
      {
        message: 'The mandatory tag key ${mandatoryTag1Key} is missing from your resource. Please add it or contact ${nonComplianceMessageContactEmail}'
        policyDefinitionReferenceId: 'Add tag to resource group'
      }
    ]
  }
}
