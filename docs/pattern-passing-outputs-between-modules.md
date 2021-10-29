# Terraform Pattern: Passing outputs between modules for custom policy definitions created using count

## Problem Statement

* We need to create policysets (initiatives) referencing custom policy definition ids from custom policy definitions created in our code.
* Both resources above are in seperate child modules so we need to pass outputs between modules using output variables and input variables.

## Steps

1. Define an output variable for policy definition ids referencing the resource block that uses count
2. Define input variables for each policy definition id to be referenced in a policyset resource
3. Reference each input variable in the policyset resource block
4. Map the policy definition id input variable to the policy definition id output variable

## 1 - Define an output variable for policy definition ids referencing the resource block that uses count

First, define an output variable for policy definitions.

All resources created by a resource block that uses `count = length(var.variableName)` can be referenced using `${resourceProvider.resourceType.resourceName.*.output}`.

This output variable should be defined in the same module where the `policy definition` resource is created.

```hcl
output "addTagToRG_policy_ids" {
  value       = "${azurerm_policy_definition.addTagToRG.*.id}"
  description = "The policy definition ids for addTagToRG policies"
}
```

## 2 - Define input variables for each policy definition id to be referenced in a policyset resource

Next, within your policyset module, define an input variable e.g. `addTagToRG_policy_id_0` for each policy definition resource created by the policy definition resource block that uses count.

```hcl
variable "addTagToRG_policy_id_0" {
  type        = string
  description = "The policy definition id '0' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_1" {
  type        = string
  description = "The policy definition id '1' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_2" {
  type        = string
  description = "The policy definition id '2' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_3" {
  type        = string
  description = "The policy definition id '3' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_4" {
  type        = string
  description = "The policy definition id '4' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_5" {
  type        = string
  description = "The policy definition id '5' from the 'addTagToRG_policy_ids' output"
}
```

## 3 - Reference each input variable in the policyset resource block

Then, within your policyset resource block, for each policy definition id reference each input variable created above using `${var.variableName}`

```hcl
resource "azurerm_policy_set_definition" "tag_governance" {
  name         = "tag_governance"
  policy_type  = "Custom"
  display_name = "Tag Governance"
  description  = "Contains common Tag Governance policies"
  metadata = jsonencode(
    {
    "category": "${var.policyset_definition_category}"
    }
)
  policy_definitions = <<POLICY_DEFINITIONS
    [
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_0}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_1}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_2}"
        },     
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_3}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_4}"
        },
        {
            "policyDefinitionId": "${var.addTagToRG_policy_id_5}"
        }
    ]
POLICY_DEFINITIONS
}
```

## 4 - Map the policy definition id input variable to the policy definition id output variable

Finally, from the parent module file which calls the child modules, map each input variable to the output variable using `inputVariableName = "${module.moduleName.outputVariableName[X]}"`

```hcl
module "policyset_definitions" {
  source = "./modules/policyset-definitions"

  addTagToRG_policy_id_0 = "${module.policy_definitions.addTagToRG_policy_ids[0]}"
  addTagToRG_policy_id_1 = "${module.policy_definitions.addTagToRG_policy_ids[1]}"
  addTagToRG_policy_id_2 = "${module.policy_definitions.addTagToRG_policy_ids[2]}"
  addTagToRG_policy_id_3 = "${module.policy_definitions.addTagToRG_policy_ids[3]}"
  addTagToRG_policy_id_4 = "${module.policy_definitions.addTagToRG_policy_ids[4]}"
  addTagToRG_policy_id_5 = "${module.policy_definitions.addTagToRG_policy_ids[5]}"
}
```

### Home
[azure-policy-as-code](https://globalbao.github.io/azure-policy-as-code/)
