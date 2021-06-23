targetScope = 'subscription'

// PARAMETERS
param resourceGroupName string
param resourceGrouplocation string
param tagOwnerValue string

// OUTPUTS
output resourceGroupName string = rg.name
output resourceGroupID string = rg.id

// RESOURCES

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: resourceGrouplocation
  tags: {
    Owner: tagOwnerValue
  }
}

// resource rg2 'Microsoft.Resources/resourceGroups@2020-06-01' = {
//   name: 'testRG'
//   location: resourceGrouplocation
//   // tags: {
//   //   Owner: tagOwnerValue
//   // }
// }
