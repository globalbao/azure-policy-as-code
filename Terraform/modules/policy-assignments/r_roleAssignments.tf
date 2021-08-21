resource "azurerm_role_assignment" "monitoring_governance" {
  scope                            = data.azurerm_subscription.current.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_subscription_policy_assignment.monitoring_governance.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "tag_governance" {
  scope                            = data.azurerm_subscription.current.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_subscription_policy_assignment.tag_governance.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "security_governance" {
  scope                            = data.azurerm_subscription.current.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_subscription_policy_assignment.security_governance.identity[0].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "logging_governance" {
  scope                            = data.azurerm_subscription.current.id
  role_definition_name             = "Contributor"
  principal_id                     = azurerm_subscription_policy_assignment.logging_governance.identity[0].principal_id
  skip_service_principal_aad_check = true
}