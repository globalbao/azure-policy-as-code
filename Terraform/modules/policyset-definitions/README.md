# AzureRM PolicySet Definitions - Terraform child module

Get in touch :octocat:

* Twitter: [@coder_au](https://twitter.com/coder_au)
* LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/)
* Web: [jloudon.com](https://jloudon.com)
* GitHub: [@JesseLoudon](https://github.com/jesseloudon)

Learning resources :books:

* [https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html](https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html)
* [https://docs.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure)

## Module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Resources (main.tf)

| Resource Type | Resource name | Deployment Count
|:--------------|:--------------|:----------------
| azurerm_policy_set_definition | `monitoring_governance` | 1
| azurerm_policy_set_definition | `tag_governance` | 1
| azurerm_policy_set_definition | `iam_governance` | 1
| azurerm_policy_set_definition | `security_governance` | 1
| azurerm_policy_set_definition | `data_protection_governance` | 1

## Input variables (variables.tf)

| Name | Description | Type | Default Value
|:------|:-------------|:------|:---------
| `policyset_definition_category` | The category to use for all PolicySet definitions | `string` | "Custom"
| `custom_policies_monitoring_governance` | List of custom policy definitions for the monitoring_governance policyset| `list(map(string))` | null
| `custom_policies_tag_governance` | List of custom policy definitions for the tag_governance policyset | `list(map(string))` | null
| `custom_policies_iam_governance` | List of custom policy definitions for the iam_governance policyset | `list(map(string))` | null
| `builtin_policies_iam_governance` | List of policy definitions (display names) for the iam_governance policyset | `list` |"Audit usage of custom RBAC rules","Custom subscription owner roles should not exist","Deprecated accounts should be removed from your subscription","Deprecated accounts with owner permissions should be removed from your subscription","External accounts with write permissions should be removed from your subscription","External accounts with read permissions should be removed from your subscription","External accounts with owner permissions should be removed from your subscription","MFA should be enabled accounts with write permissions on your subscription","MFA should be enabled on accounts with owner permissions on your subscription","MFA should be enabled on accounts with read permissions on your subscription","There should be more than one owner assigned to your subscription"
| `builtin_policies_security_governance` | List of policy definitions (display names) for the security_governance policyset | `list` | "Internet-facing virtual machines should be protected with Network Security Groups","Subnets should be associated with a Network Security Group","Gateway subnets should not be configured with a network security group","Storage accounts should restrict network access","Secure transfer to storage accounts should be enabled","Storage accounts should allow access from trusted Microsoft services","RDP access from the Internet should be blocked","SSH access from the Internet should be blocked","Disk encryption should be applied on virtual machines","Automation account variables should be encrypted","Azure subscriptions should have a log profile for Activity Log","Email notification to subscription owner for high severity alerts should be enabled","Subscriptions should have a contact email address for security issues","Enable Azure Security Center on your subscription"
| `builtin_policies_data_protection_governance` | List of policy definitions (display names) for the data_protection_governance policyset | `list` | "Azure Backup should be enabled for Virtual Machines","Long-term geo-redundant backup should be enabled for Azure SQL Databases","Audit virtual machines without disaster recovery configured","Key vaults should have purge protection enabled","Key vaults should have soft delete enabled"

## Output variables (outputs.tf)

| Name | Description | Value
|:-------|:-----------|:----------
| `monitoring_governance_policyset_id` | The policy set definition id for monitoring_governance | azurerm_policy_set_definition.monitoring_governance.id
| `tag_governance_policyset_id` | The policy set definition id for tag_governance | azurerm_policy_set_definition.tag_governance.id
| `iam_governance_policyset_id` | The policy set definition id for iam_governance | azurerm_policy_set_definition.iam_governance.id
| `security_governance_policyset_id` | The policy set definition id for security_governance | azurerm_policy_set_definition.security_governance.id
| `data_protection_governance_policyset_id` | The policy set definition id for data_protection_governance | azurerm_policy_set_definition.data_protection_governance.id
