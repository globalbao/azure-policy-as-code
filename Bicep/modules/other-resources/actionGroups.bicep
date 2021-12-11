targetScope = 'resourceGroup'

// PARAMETERS
@description('The resource name')
param actionGroupName string

@description('Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param actionGroupEnabled bool

@description('The short name of the action group.')
param actionGroupShortName string

@description('The name of the email receiver.')
param actionGroupEmailName string

@description('The email address of this receiver.')
param actionGroupEmail string

@description('Indicates whether to use common alert schema.')
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
