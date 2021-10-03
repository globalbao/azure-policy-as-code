 targetScope = 'subscription'

// VARIABLES
var deploy_diagSettings_keyVault = json(loadTextContent('./custom/deploy_diagSettings_keyVault.json'))
var audit_resourceLocks = json(loadTextContent('./custom/audit_resourceLocks.json'))
var audit_roleAssignments = json(loadTextContent('./custom/audit_roleAssignments.json'))
var add_tag_to_rg = json(loadTextContent('./custom/add_tag_to_rg.json'))
var inherit_all_rg_tags = json(loadTextContent('./custom/inherit_all_rg_tags.json'))
var inherit_rg_tag = json(loadTextContent('./custom/inherit_rg_tag.json'))
var inherit_rg_tag_overwrite_existing = json(loadTextContent('./custom/inherit_rg_tag_overwrite_existing.json'))
var deploy_alert_appGateway_clientRtt = json(loadTextContent('./custom/deploy_alert_appGateway_clientRtt.json'))
var deploy_alert_appGateway_cpuUtilization = json(loadTextContent('./custom/deploy_alert_appGateway_cpuUtilization.json'))
var deploy_alert_appGateway_failedRequests = json(loadTextContent('./custom/deploy_alert_appGateway_failedRequests.json'))
var deploy_alert_appGateway_healthyHostCount = json(loadTextContent('./custom/deploy_alert_appGateway_healthyHostCount.json'))
var deploy_alert_appGateway_totalRequests = json(loadTextContent('./custom/deploy_alert_appGateway_totalRequests.json'))
var deploy_alert_appGateway_unhealthyHostCount = json(loadTextContent('./custom/deploy_alert_appGateway_unhealthyHostCount.json'))

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

resource deployAlertAppGatewayClientRtt 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_alert_appGateway_clientRtt'
  properties: deploy_alert_appGateway_clientRtt.properties
}

resource deployAlertAppGatewayCpuUtilization 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_alert_appGateway_cpuUtilization'
  properties: deploy_alert_appGateway_cpuUtilization.properties
}

resource deployAlertAppGatewayFailedRequests 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_alert_appGateway_failedRequests'
  properties: deploy_alert_appGateway_failedRequests.properties
}

resource deployAlertAppGatewayHealthyHostCount 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_alert_appGateway_healthyHostCount'
  properties: deploy_alert_appGateway_healthyHostCount.properties
}

resource deployAlertAppGatewayTotalRequests 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_alert_appGateway_totalRequests'
  properties: deploy_alert_appGateway_totalRequests.properties
}

resource deployAlertAppGatewayUnhealthyHostCount 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'deploy_alert_appGateway_unhealthyHostCount'
  properties: deploy_alert_appGateway_unhealthyHostCount.properties
}

output customPolicyIds array = [
    deployDiagSettingsKeyVault.id
    auditResourcelocks.id
    auditRoleAssignments.id
    addTagToRG.id
    inheritAllRgTags.id
    inheritRgTag.id
    inheritRgTagOverwriteExisting.id
    deployAlertAppGatewayClientRtt.id
    deployAlertAppGatewayCpuUtilization.id
    deployAlertAppGatewayFailedRequests.id
    deployAlertAppGatewayHealthyHostCount.id
    deployAlertAppGatewayTotalRequests.id
    deployAlertAppGatewayUnhealthyHostCount.id
]

output customPolicyNames array = [
    deployDiagSettingsKeyVault.properties.displayName
    auditResourcelocks.properties.displayName
    auditRoleAssignments.properties.displayName
    addTagToRG.properties.displayName
    inheritAllRgTags.properties.displayName
    inheritRgTag.properties.displayName
    inheritRgTagOverwriteExisting.properties.displayName
    deployAlertAppGatewayClientRtt.properties.displayName
    deployAlertAppGatewayCpuUtilization.properties.displayName
    deployAlertAppGatewayFailedRequests.properties.displayName
    deployAlertAppGatewayHealthyHostCount.properties.displayName
    deployAlertAppGatewayTotalRequests.properties.displayName
    deployAlertAppGatewayUnhealthyHostCount.properties.displayName
]
