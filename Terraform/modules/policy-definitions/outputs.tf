output "expressRouteCircuit_arpAvailability_policy_id" {
  value       = azurerm_policy_definition.expressRouteCircuit_arpAvailability.id
  description = "The policy definition id for expressRouteCircuit_arpAvailability"
}

output "expressRouteCircuit_bgpAvailability_policy_id" {
  value       = azurerm_policy_definition.expressRouteCircuit_bgpAvailability.id
  description = "The policy definition id for expressRouteCircuit_bgpAvailability"
}

output "expressRouteCircuit_bitsInPerSecond_policy_id" {
  value       = azurerm_policy_definition.expressRouteCircuit_bitsInPerSecond.id
  description = "The policy definition id for expressRouteCircuit_bitsInPerSecond"
}

output "expressRouteCircuit_bitsOutPerSecond_policy_id" {
  value       = azurerm_policy_definition.expressRouteCircuit_bitsOutPerSecond.id
  description = "The policy definition id for expressRouteCircuit_bitsOutPerSecond"
}

output "expressRouteCircuitPeer_bitsInPerSecond_policy_id" {
  value       = azurerm_policy_definition.expressRouteCircuitPeer_bitsInPerSecond.id
  description = "The policy definition id for expressRouteCircuitPeer_bitsInPerSecond"
}

output "expressRouteCircuitPeer_bitsOutPerSecond_policy_id" {
  value       = azurerm_policy_definition.expressRouteCircuitPeer_bitsOutPerSecond.id
  description = "The policy definition id for expressRouteCircuitPeer_bitsOutPerSecond"
}

output "expressRouteGateway_bitsInPerSecond_policy_id" {
  value       = azurerm_policy_definition.expressRouteGateway_bitsInPerSecond.id
  description = "The policy definition id for expressRouteGateway_bitsInPerSecond"
}

output "expressRouteGateway_bitsOutPerSecond_policy_id" {
  value       = azurerm_policy_definition.expressRouteGateway_bitsOutPerSecond.id
  description = "The policy definition id for expressRouteGateway_bitsOutPerSecond"
}

output "sqlServerDB_storagePercent_policy_id" {
  value       = azurerm_policy_definition.sqlServerDB_storagePercent.id
  description = "The policy definition id for sqlServerDB_storagePercent"
}

output "sqlServerDB_deadlock_policy_id" {
  value       = azurerm_policy_definition.sqlServerDB_deadlock.id
  description = "The policy definition id for sqlServerDB_deadlock"
}

output "sqlServerDB_cpuPercent_policy_id" {
  value       = azurerm_policy_definition.sqlServerDB_cpuPercent.id
  description = "The policy definition id for sqlServerDB_cpuPercent"
}

output "sqlServerDB_connectionFailed_policy_id" {
  value       = azurerm_policy_definition.sqlServerDB_connectionFailed.id
  description = "The policy definition id for sqlServerDB_connectionFailed"
}

output "sqlServerDB_blockedByFirewall_policy_id" {
  value       = azurerm_policy_definition.sqlServerDB_blockedByFirewall.id
  description = "The policy definition id for sqlServerDB_blockedByFirewall"
}

output "sqlManagedInstances_ioRequests_policy_id" {
  value       = azurerm_policy_definition.sqlManagedInstances_ioRequests.id
  description = "The policy definition id for sqlManagedInstances_ioRequests"
}

output "sqlManagedInstances_avgCPUPercent_policy_id" {
  value       = azurerm_policy_definition.sqlManagedInstances_avgCPUPercent.id
  description = "The policy definition id for sqlManagedInstances_avgCPUPercent"
}

output "appGateway_healthyHostCount_policy_id" {
  value       = azurerm_policy_definition.appGateway_healthyHostCount.id
  description = "The policy definition id for appGateway_healthyHostCount"
}

output "appGateway_unhealthyHostCount_policy_id" {
  value       = azurerm_policy_definition.appGateway_unhealthyHostCount.id
  description = "The policy definition id for appGateway_unhealthyHostCount"
}

output "appGateway_failedRequests_policy_id" {
  value       = azurerm_policy_definition.appGateway_failedRequests.id
  description = "The policy definition id for appGateway_failedRequests"
}

output "appGateway_totalRequests_policy_id" {
  value       = azurerm_policy_definition.appGateway_totalRequests.id
  description = "The policy definition id for appGateway_totalRequests"
}

output "appGateway_clientRTT_policy_id" {
  value       = azurerm_policy_definition.appGateway_clientRTT.id
  description = "The policy definition id for appGateway_clientRTT"
}

output "appGateway_cpuUtilization_policy_id" {
  value       = azurerm_policy_definition.appGateway_cpuUtilization.id
  description = "The policy definition id for appGateway_cpuUtilization"
}

output "websvrfarm_cpuPercentage_policy_id" {
  value       = azurerm_policy_definition.websvrfarm_cpuPercentage.id
  description = "The policy definition id for websvrfarm_cpuPercentage"
}

output "websvrfarm_memoryPercentage_policy_id" {
  value       = azurerm_policy_definition.websvrfarm_memoryPercentage.id
  description = "The policy definition id for websvrfarm_memoryPercentage"
}

output "website_averageMemoryWorkingSet_policy_id" {
  value       = azurerm_policy_definition.website_averageMemoryWorkingSet.id
  description = "The policy definition id for website_averageMemoryWorkingSet"
}

output "website_averageResponseTime_policy_id" {
  value       = azurerm_policy_definition.website_averageResponseTime.id
  description = "The policy definition id for website_averageResponseTime"
}

output "website_cpuTime_policy_id" {
  value       = azurerm_policy_definition.website_cpuTime.id
  description = "The policy definition id for website_cpuTime"
}

output "website_healthCheckStatus_policy_id" {
  value       = azurerm_policy_definition.website_healthCheckStatus.id
  description = "The policy definition id for website_healthCheckStatus"
}

output "website_http5xx_policy_id" {
  value       = azurerm_policy_definition.website_http5xx.id
  description = "The policy definition id for website_http5xx"
}

output "website_requestsInApplicationQueue_policy_id" {
  value       = azurerm_policy_definition.website_requestsInApplicationQueue.id
  description = "The policy definition id for website_requestsInApplicationQueue"
}

output "websiteSlot_averageMemoryWorkingSet_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_averageMemoryWorkingSet.id
  description = "The policy definition id for websiteSlot_averageMemoryWorkingSet"
}

output "websiteSlot_averageResponseTime_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_averageResponseTime.id
  description = "The policy definition id for websiteSlot_averageResponseTime"
}

output "websiteSlot_cpuTime_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_cpuTime.id
  description = "The policy definition id for websiteSlot_cpuTime"
}

output "websiteSlot_healthCheckStatus_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_healthCheckStatus.id
  description = "The policy definition id for websiteSlot_healthCheckStatus"
}

output "websiteSlot_http5xx_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_http5xx.id
  description = "The policy definition id for websiteSlot_http5xx"
}

output "websiteSlot_requestsInApplicationQueue_policy_id" {
  value       = azurerm_policy_definition.websiteSlot_requestsInApplicationQueue.id
  description = "The policy definition id for websiteSlot_requestsInApplicationQueue"
}

output "azureFirewall_health_policy_id" {
  value       = azurerm_policy_definition.azureFirewall_health.id
  description = "The policy definition id for azureFirewall_health"
}

output "loadBalancer_dipAvailability_policy_id" {
  value       = azurerm_policy_definition.loadBalancer_dipAvailability.id
  description = "The policy definition id for loadBalancer_dipAvailability"
}

output "loadBalancer_vipAvailability_policy_id" {
  value       = azurerm_policy_definition.loadBalancer_vipAvailability.id
  description = "The policy definition id for loadBalancer_vipAvailability"
}

output "addTagToRG_policy_ids" {
  value       = azurerm_policy_definition.addTagToRG.*.id
  description = "The policy definition ids for addTagToRG policies"
}

output "inheritTagFromRG_policy_ids" {
  value       = azurerm_policy_definition.inheritTagFromRG.*.id
  description = "The policy definition ids for inheritTagFromRG policies"
}

output "inheritTagFromRGOverwriteExisting_policy_ids" {
  value       = azurerm_policy_definition.inheritTagFromRGOverwriteExisting.*.id
  description = "The policy definition ids for inheritTagFromRGOverwriteExisting policies"
}

output "bulkInheritTagsFromRG_policy_id" {
  value       = azurerm_policy_definition.bulkInheritTagsFromRG.id
  description = "The policy definition id for bulkInheritTagsFromRG"
}

output "auditRoleAssignmentType_user_policy_id" {
  value       = azurerm_policy_definition.auditRoleAssignmentType_user.id
  description = "The policy definition id for auditRoleAssignmentType_user"
}

output "auditLockOnNetworking_policy_id" {
  value       = azurerm_policy_definition.auditLockOnNetworking.id
  description = "The policy definition id for auditLockOnNetworking"
}