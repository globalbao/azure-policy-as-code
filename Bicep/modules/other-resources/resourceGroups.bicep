targetScope = 'subscription'

// PARAMETERS
param resourceGroupName string
param resourceGrouplocation string

// RESOURCES
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: resourceGrouplocation
  tags: {}
}

// OUTPUTS
output resourceGroupName string = rg.name
output resourceGroupId string = rg.id
