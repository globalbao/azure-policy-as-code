variable "mandatory_tag_keys" {
  type        = list(any)
  description = "List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG'"
  default = [
    "Application",
    "CostCentre",
    "Environment",
    "ManagedBy",
    "Owner",
    "Support"
  ]

}

variable "mandatory_tag_value" {
  type        = string
  description = "Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG'"
  default     = "TBC"
}

variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}

variable "azure_monitor_action_group_name" {
  type        = string
  description = "The name of the Azure Monitor Action Group"
  default     = "AlertOperationsGroup"
}

variable "azure_monitor_action_group_rg_name" {
  type        = string
  description = "Resource Group containing the Azure Monitor Action Group"
  default     = "AzMonitorAlertGroups"
}