# AzureRM Policy Assignments - Terraform child module

Get in touch :octocat:

* Twitter: [@coder_au](https://twitter.com/coder_au)
* LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/)
* Web: [jloudon.com](https://jloudon.com)
* GitHub: [@JesseLoudon](https://github.com/jesseloudon)

Learning resources :books:

* [https://www.terraform.io/docs/providers/azurerm/r/policy_assignment.html](https://www.terraform.io/docs/providers/azurerm/r/policy_assignment.html)
* [https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)

## Terraform child module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Terraform resources (main.tf)

| Resource Type | Resource name | Deployment Count
|:--------------|:--------------|:----------------
| azurerm_subscription_policy_assignment | `monitoring_governance` | 1
| azurerm_subscription_policy_assignment | `tag_governance` | 1
| azurerm_subscription_policy_assignment | `iam_governance` | 1
| azurerm_subscription_policy_assignment | `security_governance` | 1
| azurerm_subscription_policy_assignment | `data_protection_governance` | 1

## Terraform input variables (variables.tf)

| Name | Description | Type | Default Value
|:------|:-------------|:------|:---------
| `monitoring_governance_policyset_id` | The policy set definition id for monitoring_governance | `string` | null
| `tag_governance_policyset_id` | The policy set definition id for tag_governance | `string` | null
| `iam_governance_policyset_id` | The policy set definition id for iam_governance | `string` | null
| `security_governance_policyset_id` | The policy set definition id for security_governance | `string` | null
| `data_protection_governance_policyset_id` | The policy set definition id for data_protection_governance | `string` | null

## Terraform output variables (outputs.tf)

| Name | Description | Value
|:-------|:-----------|:----------
| `monitoring_governance_assignment_id` | The policy assignment id for monitoring_governance | azurerm_subscription_policy_assignment.monitoring_governance.id
| `monitoring_governance_assignment_identity` | The policy assignment identity for monitoring_governance | azurerm_subscription_policy_assignment.monitoring_governance.identity
| `tag_governance_assignment_id` | The policy assignment id for tag_governance | azurerm_subscription_policy_assignment.tag_governance.id
| `tag_governance_assignment_identity` | The policy assignment identity for tag_governance | azurerm_subscription_policy_assignment.tag_governance.identity
| `iam_governance_assignment_id` | The policy assignment id for iam_governance | azurerm_subscription_policy_assignment.iam_governance.id
| `security_governance_assignment_id` | The policy assignment id for security_governance | azurerm_subscription_policy_assignment.security_governance.id
| `security_governance_assignment_identity` | The policy assignment identity for security_governance | azurerm_subscription_policy_assignment.security_governance.identity
| `data_protection_governance_assignment_id` | The policy assignment id for data_protection_governance | azurerm_subscription_policy_assignment.data_protection_governance.id
