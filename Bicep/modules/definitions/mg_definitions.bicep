targetScope = 'managementGroup'

// VARIABLES
var deploy_diagSettings_keyVault = json(loadTextContent('./custom/deploy_diagSettings_keyVault.json'))
var audit_resourceLocks = json(loadTextContent('./custom/audit_resourceLocks.json'))
var audit_roleAssignments = json(loadTextContent('./custom/audit_roleAssignments.json'))
var add_tag_to_rg = json(loadTextContent('./custom/add_tag_to_rg.json'))
var inherit_all_rg_tags = json(loadTextContent('./custom/inherit_all_rg_tags.json'))
var inherit_rg_tag = json(loadTextContent('./custom/inherit_rg_tag.json'))
var inherit_rg_tag_overwrite_existing = json(loadTextContent('./custom/inherit_rg_tag_overwrite_existing.json'))
var deploy_alert_appGateway = json(loadTextContent('./custom/deploy_alert_appGateway.json'))
var assign_aadGroup_to_rg = json(loadTextContent('./custom/assign_aadGroup_to_rg.json'))
var modify_storageAccount_vnet_integration = json(loadTextContent('./custom/modify_storageAccount_vnet_integration.json'))

// CUSTOM DEFINITIONS
resource deployDiagSettingsKeyVault 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_diagSettings_keyVault'
  properties: deploy_diagSettings_keyVault.properties
}

resource auditResourcelocks 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'audit_resourceLocks'
  properties: audit_resourceLocks.properties
}

resource auditRoleAssignments 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'audit_roleAssignments'
  properties: audit_roleAssignments.properties
}

resource addTagToRG 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'add_tag_to_rg'
  properties: add_tag_to_rg.properties
}

resource inheritAllRgTags 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'inherit_all_rg_tag'
  properties: inherit_all_rg_tags.properties
}

resource inheritRgTag 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'inherit_rg_tag'
  properties: inherit_rg_tag.properties
}

resource inheritRgTagOverwriteExisting 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'inherit_rg_tag_overwrite_existing'
  properties: inherit_rg_tag_overwrite_existing.properties
}

resource deployAlertAppGateway 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_alert_appGateway'
  properties: deploy_alert_appGateway.properties
}

resource assignAadGroupToRg 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'assign_aadGroup_to_rg'
  properties: assign_aadGroup_to_rg.properties
}

resource modifyStorageAccountVnetIntegration 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'modify_storageAccount_vnet_integration'
  properties: modify_storageAccount_vnet_integration.properties
}

// OUTPUTS
output customPolicyIds array = [
  deployDiagSettingsKeyVault.id
  auditResourcelocks.id
  auditRoleAssignments.id
  addTagToRG.id
  inheritAllRgTags.id
  inheritRgTag.id
  inheritRgTagOverwriteExisting.id
  deployAlertAppGateway.id
  assignAadGroupToRg.id
  modifyStorageAccountVnetIntegration.id
]

output customPolicyNames array = [
  deployDiagSettingsKeyVault.properties.displayName
  auditResourcelocks.properties.displayName
  auditRoleAssignments.properties.displayName
  addTagToRG.properties.displayName
  inheritAllRgTags.properties.displayName
  inheritRgTag.properties.displayName
  inheritRgTagOverwriteExisting.properties.displayName
  deployAlertAppGateway.properties.displayName
  assignAadGroupToRg.properties.displayName
  modifyStorageAccountVnetIntegration.properties.displayName
]
