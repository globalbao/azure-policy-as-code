output "monitoring_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.monitoring_governance.id
  description = "The policy assignment id for monitoring_governance"
}

output "monitoring_governance_assignment_identity" {
  value       = azurerm_subscription_policy_assignment.monitoring_governance.identity
  description = "The policy assignment identity for monitoring_governance"
}

output "tag_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.tag_governance.id
  description = "The policy assignment id for tag_governance"
}

output "tag_governance_assignment_identity" {
  value       = azurerm_subscription_policy_assignment.tag_governance.identity
  description = "The policy assignment identity for tag_governance"
}

output "iam_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.iam_governance.id
  description = "The policy assignment id for iam_governance"
}

output "security_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.security_governance.id
  description = "The policy assignment id for security_governance"
}

output "security_governance_assignment_identity" {
  value       = azurerm_subscription_policy_assignment.security_governance.identity
  description = "The policy assignment identity for security_governance"
}

output "data_protection_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.data_protection_governance.id
  description = "The policy assignment id for data_protection_governance"
}

output "logging_governance_assignment_id" {
  value       = azurerm_subscription_policy_assignment.logging_governance.id
  description = "The policy assignment id for logging_governance_prod"
}

output "logging_governance_assignment_identity" {
  value       = azurerm_subscription_policy_assignment.logging_governance.identity
  description = "The policy assignment identity for logging_governance"
}