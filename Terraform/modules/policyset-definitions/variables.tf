variable "log_analytics_id" {
  type        = string
  description = "Resource ID for the OMS workspace - used for log governance policies"
  default     = "/subscriptions/xxxxxxxx/resourcegroups/xxxxxxxx/providers/microsoft.operationalinsights/workspaces/xxxxxxxx"
}

variable "policyset_definition_category" {
  type        = string
  description = "The category to use for all PolicySet defintions"
  default     = "Custom"
}

variable "custom_policies_monitoring_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the monitoring_governance policyset"
  default     = []
}

variable "custom_policies_tag_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the tag_governance policyset"
  default     = []
}

variable "custom_policies_iam_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the iam_governance policyset"
  default     = []
}

variable "custom_policies_sentinel_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the sentinel_governance policyset"
  default     = []
}

variable "custom_policies_logging_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the logging_governance policyset"
  default     = []
}

variable "builtin_policies_iam_governance" {
  type        = list(any)
  description = "List of built-in policy definitions (display names) for the iam_governance policyset"
  default = [
    "Audit usage of custom RBAC rules",
    "Custom subscription owner roles should not exist",
    "Deprecated accounts should be removed from your subscription",
    "Deprecated accounts with owner permissions should be removed from your subscription",
    "External accounts with write permissions should be removed from your subscription",
    "External accounts with read permissions should be removed from your subscription",
    "External accounts with owner permissions should be removed from your subscription",
    "MFA should be enabled accounts with write permissions on your subscription",
    "MFA should be enabled on accounts with owner permissions on your subscription",
    "MFA should be enabled on accounts with read permissions on your subscription",
    "There should be more than one owner assigned to your subscription"
  ]
}

variable "builtin_policies_security_governance" {
  type        = list(any)
  description = "List of policy definitions (display names) for the security_governance policyset"
  default = [
    "Internet-facing virtual machines should be protected with network security groups",
    "Subnets should be associated with a Network Security Group",
    "Gateway subnets should not be configured with a network security group",
    "Storage accounts should restrict network access",
    "Secure transfer to storage accounts should be enabled",
    "Storage accounts should allow access from trusted Microsoft services",
    "Automation account variables should be encrypted",
    "Azure subscriptions should have a log profile for Activity Log",
    "Email notification to subscription owner for high severity alerts should be enabled",
    "Subscriptions should have a contact email address for security issues",
    "Enable Azure Security Center on your subscription"
  ]
}

variable "builtin_policies_data_protection_governance" {
  type        = list(any)
  description = "List of policy definitions (display names) for the data_protection_governance policyset"
  default = [
    "Azure Backup should be enabled for Virtual Machines",
    "Long-term geo-redundant backup should be enabled for Azure SQL Databases",
    "Audit virtual machines without disaster recovery configured",
    "Key vaults should have purge protection enabled",
    "Key vaults should have soft delete enabled"
  ]
}

variable "builtin_policies_logging_governance" {
  type        = list(any)
  description = "List of policy definitions (display names) for the logging_governance policyset"
  default = [
    "Deploy - Configure diagnostic settings for Azure Key Vault to Log Analytics workspace",
    "Configure diagnostic settings for storage accounts to Log Analytics workspace",
    "Deploy - Configure diagnostic settings for Azure Kubernetes Service to Log Analytics workspace",
    "Deploy - Configure diagnostic settings for SQL Databases to Log Analytics workspace"
  ]
}

data "azurerm_policy_definition" "builtin_policies_iam_governance" {
  count        = length(var.builtin_policies_iam_governance)
  display_name = var.builtin_policies_iam_governance[count.index]
}

data "azurerm_policy_definition" "builtin_policies_security_governance" {
  count        = length(var.builtin_policies_security_governance)
  display_name = var.builtin_policies_security_governance[count.index]
}

data "azurerm_policy_definition" "builtin_policies_data_protection_governance" {
  count        = length(var.builtin_policies_data_protection_governance)
  display_name = var.builtin_policies_data_protection_governance[count.index]
}

data "azurerm_policy_definition" "builtin_policies_logging_governance" {
  count        = length(var.builtin_policies_logging_governance)
  display_name = var.builtin_policies_logging_governance[count.index]
}