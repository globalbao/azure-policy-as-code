# Terraform Pattern: Using a data source to lookup built-in policy definition ids based on a variable list of display names

## Requirements

* We need to create a policyset (initiative) referencing existing policy definition ids for built-in policies.
* We need to avoid hardcoding built-in policy definition ids into our terraform code.
* We want retrieve the existing policy definition ids by looking up the display names for each built-in policy definition.

## Steps

1. Define a variable list containing the display names of built-in policy definitions
2. Define a data source to azurerm_policy_definition referencing the variable list
3. Reference each data source value within the policyset policy_definitions resource block

## 1 - Define a variable list containing the display names of built-in policy definitions

First, define a variable list containing the display names of existing built-in policy definitions that you want to include in a policyset.

```hcl
variable "security_policyset_definitions" {
  type        = list
  description = "List of policy definitions (display names) for the security_governance policyset"
  default = [
    "Internet-facing virtual machines should be protected with network security groups",
    "Subnets should be associated with a Network Security Group",
    "Gateway subnets should not be configured with a network security group",
    "Storage accounts should restrict network access",
    "Secure transfer to storage accounts should be enabled",
    "Access through Internet facing endpoint should be restricted",
    "Storage accounts should allow access from trusted Microsoft services",
    "RDP access from the Internet should be blocked",
    "SSH access from the Internet should be blocked",
    "Disk encryption should be applied on virtual machines",
    "Automation account variables should be encrypted",
    "Azure subscriptions should have a log profile for Activity Log",
    "Email notification to subscription owner for high severity alerts should be enabled",
    "A security contact email address should be provided for your subscription",
    "Enable Azure Security Center on your subscription"
  ]
}
```

## 2 - Define a data source to azurerm_policy_definition referencing the variable list

Next, define a data source to azurerm_policy_definition and use `count = length(var.variableName)` to iterate the data source lookup based on the number of values in your variable list.

Then, use `display_name = var.variableName[count.index]` to lookup policy definitions based on the display names definined in your variable list.

```hcl
data "azurerm_policy_definition" "security_policyset_definitions" {
  count        = length(var.security_policyset_definitions)
  display_name = var.security_policyset_definitions[count.index]
}
```

## 3 - Reference each data source value within the policyset policy_definitions resource block

Finally, within the policyset resource block, reference each policydefinitionId from the data source using `${data.dataSource.dataSourceName.*.id[X]}`

The example below is for if you have 15 policy definitions contained in your variable list.

```hcl
resource "azurerm_policy_set_definition" "security_governance" {

  name         = "security_governance"
  policy_type  = "Custom"
  display_name = "Security Governance"
  description  = "Contains common Security Governance policies"

  metadata = jsonencode(
    {
    "category": "${var.policyset_definition_category}"
    }
)

  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[0]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[1]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[2]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[3]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[4]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[5]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[6]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[7]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[8]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[9]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[10]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[11]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[12]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[13]}"
        },
        {
            "policyDefinitionId": "${data.azurerm_policy_definition.security_policyset_definitions.*.id[14]}"
        }
    ]
POLICY_DEFINITIONS
}
```

### Home
[azure-policy-as-code](https://globalbao.github.io/terraform-azurerm-policy/)
