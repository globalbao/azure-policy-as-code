# AzureRM Policy Definitions - Terraform child module

Get in touch :octocat:

* Twitter: [@coder_au](https://twitter.com/coder_au)
* LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/)
* Web: [jloudon.com](https://jloudon.com)
* GitHub: [@JesseLoudon](https://github.com/jesseloudon)

Learning resources :books:

* [https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html](https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html)
* [https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)

## Terraform child module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Terraform resources (main.tf)

| Resource Type             | Resource name                              | Deployment Count
|:--------------------------|:-------------------------------------------|:------
| azurerm_policy_definition | `addTagToRG`                               | 6
| azurerm_policy_definition | `inheritTagFromRG`                         | 6
| azurerm_policy_definition | `inheritTagFromRGOverwriteExisting`        | 6
| azurerm_policy_definition | `bulkInheritTagsFromRG`                    | 1
| azurerm_policy_definition | `auditRoleAssignmentType_user`             | 1
| azurerm_policy_definition | `appGateway_{metricName}`                  | 6
| azurerm_policy_definition | `azureFirewall_{metricName}`               | 1
| azurerm_policy_definition | `sqlManagedInstances_{metricName}`         | 2
| azurerm_policy_definition | `sqlServerDB_{metricName}`                 | 5
| azurerm_policy_definition | `loadBalancer_{metricName}`                | 2
| azurerm_policy_definition | `websvrfarm_{metricName}`                  | 2
| azurerm_policy_definition | `website_{metricName}`                     | 6
| azurerm_policy_definition | `websiteSlot_{metricName}`                 | 6
| azurerm_policy_definition | `expressRoute_{metricName}`                | 8


## Terraform input variables (variables.tf)

| Name            | Description | Type | Default Value
|:----------------|:------------|:-----|:---------
| `mandatory_tag_keys`| List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkInheritTagsFromRG' | `list` | "Application", "CostCentre", "Environment", "ManagedBy", "Owner", "Support"
| `mandatory_tag_value` | Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkInheritTagsFromRG' | `string` | "TBC"
| `policy_definition_category` | The category to use for all Policy Definitions | `string` | "Custom"
| `azure_monitor_action_group_name` | The name of the Azure Monitor Action Group | `string` | "AlertOperationsGroup"
| `azure_monitor_action_group_rg_name` | Resource Group containing the Azure Monitor Action Group | `string` | "AzMonitorAlertGroups"

## Terraform output variables (outputs.tf)

Most resources created in this module have a corresponding single output variable for the `policy definition id` which is required to map a custom policy into a policyset/initiative.

Some resources created using `count` have their `id `output in a single variable as per below.

| Name                     | Description             | Value
|:-------------------------|:------------------------|:----------
| `addTagToRG_policy_ids` | The policy definition ids for addTagToRG policies | azurerm_policy_definition.addTagToRG.*.id
| `inheritTagFromRG_policy_ids` | The policy definition ids for inheritTagFromRG policies | azurerm_policy_definition.inheritTagFromRG.*.id
| `inheritTagFromRGOverwriteExisting_policy_ids` | The policy definition ids for inheritTagFromRGOverwriteExisting policies | azurerm_policy_definition.inheritTagFromRGOverwriteExisting.*.id