targetScope = 'resourceGroup'

// PARAMETERS
param actionGroupName string
param actionGroupEnabled bool
param actionGroupShortName string
param actionGroupEmailName string
param actionGroupEmail string
param actionGroupAlertSchema bool

// RESOURCES
resource actionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  location: 'global'
  name: actionGroupName
  properties: {
    enabled: actionGroupEnabled
    groupShortName: actionGroupShortName
    emailReceivers: [
      {
        name: actionGroupEmailName
        emailAddress: actionGroupEmail
        useCommonAlertSchema: actionGroupAlertSchema
      }
    ]
  }
}


// OUTPUTS
output actionGroupID string = actionGroup.id
output actionGroupName string = actionGroup.name
