resource "azurerm_subscription_policy_assignment" "monitoring_governance" {
  name                 = "monitoring_governance"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = var.monitoring_governance_policyset_id
  description          = "Assignment of the Monitoring Governance initiative to subscription."
  display_name         = "Monitoring Governance"
  location             = "australiaeast"
  identity { type = "SystemAssigned" }
}

resource "azurerm_subscription_policy_assignment" "tag_governance" {
  name                 = "tag_governance"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = var.tag_governance_policyset_id
  description          = "Assignment of the Tag Governance initiative to subscription."
  display_name         = "Tag Governance"
  location             = "australiaeast"
  identity { type = "SystemAssigned" }
}

resource "azurerm_subscription_policy_assignment" "iam_governance" {
  name                 = "iam_governance"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = var.iam_governance_policyset_id
  description          = "Assignment of the IAM Governance initiative to subscription."
  display_name         = "Identity and Access Management Governance"
}

resource "azurerm_subscription_policy_assignment" "security_governance" {
  name                 = "security_governance"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = var.security_governance_policyset_id
  description          = "Assignment of the Security Governance initiative to subscription."
  display_name         = "Security Governance"
  location             = "australiaeast"
  identity { type = "SystemAssigned" }
}

resource "azurerm_subscription_policy_assignment" "data_protection_governance" {
  name                 = "data_protection_governance"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = var.data_protection_governance_policyset_id
  description          = "Assignment of the Data Protection Governance initiative to subscription."
  display_name         = "Data Protection Governance"
}

resource "azurerm_resource_group_policy_assignment" "logging_governance_dev" {
  name                 = "logging_governance_dev"
  resource_group_id    = "/subscriptions/42482d91-3f4f-4012-8e45-78bf7ad4d60c/resourceGroups/DevelopmentInfrastructure"
  policy_definition_id = var.logging_governance_dev_policyset_id
  description          = "Assignment of the Logging Governance for Development initiative to RG."
  display_name         = "Logging Governance for Development"
  location             = "australiaeast"
  identity { type = "SystemAssigned" }
}

resource "azurerm_subscription_policy_assignment" "logging_governance_prod" {
  name                 = "logging_governance_prod"
  subscription_id      = data.azurerm_subscription.current.id
  not_scopes           = ["/subscriptions/42482d91-3f4f-4012-8e45-78bf7ad4d60c/resourceGroups/DevelopmentInfrastructure"]
  policy_definition_id = var.logging_governance_prod_policyset_id
  description          = "Assignment of the Logging Governance for Production initiative to subscription."
  display_name         = "Logging Governance for Production"
  location             = "australiaeast"
  identity { type = "SystemAssigned" }
}