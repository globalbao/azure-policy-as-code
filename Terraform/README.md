# Azure-Policy-As-Code/Terraform

Get in touch :octocat:

* Twitter: [@coder_au](https://twitter.com/coder_au)
* LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/)
* Web: [jloudon.com](https://jloudon.com)
* GitHub: [@JesseLoudon](https://github.com/jesseloudon)

Learning resources :books:
* [https://www.terraform.io/docs/providers/azurerm/index.html](https://www.terraform.io/docs/providers/azurerm/index.html)
* [https://docs.microsoft.com/en-us/azure/governance/policy/overview](https://docs.microsoft.com/en-us/azure/governance/policy/overview)

## Blogs that might interest you :pencil:

* [Using GitHub Actions and Terraform for IaC Automation](https://jloudon.com/cloud/Using-GitHub-Actions-and-Terraform-for-IaC-Automation/)
* [Azure Policy as Code with Terraform Part 1](https://jloudon.com/cloud/Azure-Policy-as-Code-with-Terraform-Part-1/)
* [Azure Policy as Code with Terraform Part 2](https://jloudon.com/cloud/Azure-Policy-as-Code-with-Terraform-Part-2/)
* [Cloud Governance with Azure Policy Part 1](https://jloudon.com/cloud/Cloud-Governance-with-Azure-Policy-Part-1/)
* [Cloud Governance with Azure Policy Part 2](https://jloudon.com/cloud/Cloud-Governance-with-Azure-Policy-Part-2/)

## Terraform parent module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

![ModuleLayout](https://github.com/globalbao/terraform-azurerm-policy/blob/master/images/terraform-azurepolicy-modulelayout.png?raw=true)

## Terraform resources (main.tf)

|Module                  | Resource Type                 | Resource name                          | Deployment Count
|:-----------------------|:------------------------------|:---------------------------------------|:-----
| policy_definitions     | azurerm_policy_definition     | `addTagToRG`                             | 6
| policy_definitions     | azurerm_policy_definition     | `inheritTagFromRG`                       | 6
| policy_definitions     | azurerm_policy_definition     | `inheritTagFromRGOverwriteExisting`      | 6
| policy_definitions     | azurerm_policy_definition     | `bulkInheritTagsFromRG`                  | 1
| policy_definitions     | azurerm_policy_definition     | `auditRoleAssignmentType_user`           | 1
| policy_definitions     | azurerm_policy_definition     | `appGateway_{metricName}`                | 6
| policy_definitions     | azurerm_policy_definition     | `azureFirewall_{metricName}`             | 1
| policy_definitions     | azurerm_policy_definition     | `sqlManagedInstances_{metricName}`       | 2
| policy_definitions     | azurerm_policy_definition     | `sqlServerDB_{metricName}`               | 5
| policy_definitions     | azurerm_policy_definition     | `loadBalancer_{metricName}`              | 2
| policy_definitions     | azurerm_policy_definition     | `websvrfarm_{metricName}`                | 2
| policy_definitions     | azurerm_policy_definition     | `website_{metricName}`                   | 6
| policy_definitions     | azurerm_policy_definition     | `websiteSlot_{metricName}`               | 6
| policy_definitions     | azurerm_policy_definition     | `expressRoute_{metricName}`              | 8
| policyset_definitions  | azurerm_policy_set_definition | `monitoring_governance`                  | 1
| policyset_definitions  | azurerm_policy_set_definition | `tag_governance`                         | 1
| policyset_definitions  | azurerm_policy_set_definition | `iam_governance`                         | 1
| policyset_definitions  | azurerm_policy_set_definition | `security_governance`                    | 1
| policyset_definitions  | azurerm_policy_set_definition | `data_protection_governance`             | 1
| policy_assignments     | azurerm_subscription_policy_assignment     | `monitoring_governance`                  | 1
| policy_assignments     | azurerm_subscription_policy_assignment     | `tag_governance`                         | 1
| policy_assignments     | azurerm_subscription_policy_assignment     | `iam_governance`                         | 1
| policy_assignments     | azurerm_subscription_policy_assignment     | `security_governance`                    | 1
| policy_assignments     | azurerm_subscription_policy_assignment     | `data_protection_governance`             | 1


## Terraform input variables (variables.tf)

* Usable if you have setup an Azure service principal for authentication as per example usage instructions below.

| Name               | Description                           | Type     | Default Value
|:-------------------|:--------------------------------------|:---------|:--------------
| `subscription_id`  | Your Azure Subscription ID            | `string` | null
| `client_id`        | Your Azure Service Principal appId    | `string` | null
| `client_secret`    | Your Azure Service Principal Password | `string` | null
| `tenant_id`        | Your Azure Tenant ID                  | `string` | null

## Terraform output variables (outputs.tf)

| Name           | Description        | Value
|:---------------|:-------------------|:----------
| `monitoring_governance_assignment_id`       | The policy assignment id for monitoring_governance          | module.policy_assignments.monitoring_governance_assignment_id
| `monitoring_governance_assignment_identity` | The policy assignment identity for monitoring_governance    | module.policy_assignments.monitoring_governance_assignment_identity
| `tag_governance_assignment_id`              | The policy assignment id for tag_governance                 | module.policy_assignments.tag_governance_assignment_id
| `tag_governance_assignment_identity`        | The policy assignment identity for tag_governance           | module.policy_assignments.tag_governance_assignment_identity
| `iam_governance_assignment_id`              | The policy assignment id for iam_governance                 | module.policy_assignments.iam_governance_assignment_id
| `security_governance_assignment_id`         | The policy assignment id for security_governance            | module.policy_assignments.security_governance_assignment_id
| `security_governance_assignment_identity`   | The policy assignment identity for security_governance      | module.policy_assignments.security_governance_assignment_identity
| `data_protection_governance_assignment_id`  | The policy assignment id for data_protection_governance     | module.policy_assignments.data_protection_governance_assignment_id

## Usage Examples

### Modifying this repo

* If changes are made to `.tf` files it's best practice to use terraform fmt/validate.

```terraform
terraform fmt -recursive
terraform validate
```

### Parent module usage to call child modules

```terraform
terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.33.0"
    }
  }
}

provider "azurerm" {
/*   
  skip_provider_registration = true
  tenant_id       = "your tenant id"
  subscription_id = "your subscription id"
  client_id       = "your service principal appId"
  client_secret   = "your service principal password" 
*/
  features {}
}

module "policy_assignments" {
  source = "./modules/policy-assignments"

  monitoring_governance_policyset_id      = module.policyset_definitions.monitoring_governance_policyset_id
  tag_governance_policyset_id             = module.policyset_definitions.tag_governance_policyset_id
  iam_governance_policyset_id             = module.policyset_definitions.iam_governance_policyset_id
  security_governance_policyset_id        = module.policyset_definitions.security_governance_policyset_id
  data_protection_governance_policyset_id = module.policyset_definitions.data_protection_governance_policyset_id
}

module "policy_definitions" {
  source = "./modules/policy-definitions"

}

module "policyset_definitions" {
  source = "./modules/policyset-definitions"

  custom_policies_monitoring_governance = [
    {
      policyID = module.policy_definitions.expressRouteGateway_bitsOutPerSecond_policy_id
    },
    {
      policyID = module.policy_definitions.expressRouteGateway_bitsInPerSecond_policy_id
    },
    {
      policyID = module.policy_definitions.expressRouteCircuitPeer_bitsOutPerSecond_policy_id
    },
    {
      policyID = module.policy_definitions.expressRouteCircuitPeer_bitsInPerSecond_policy_id
    },
    {
      policyID = module.policy_definitions.expressRouteCircuit_bitsOutPerSecond_policy_id
    },
    {
      policyID = module.policy_definitions.expressRouteCircuit_bitsInPerSecond_policy_id
    },
    {
      policyID = module.policy_definitions.expressRouteCircuit_bgpAvailability_policy_id
    },
    {
      policyID = module.policy_definitions.expressRouteCircuit_arpAvailability_policy_id
    },
    {
      policyID = module.policy_definitions.sqlServerDB_storagePercent_policy_id
    },
    {
      policyID = module.policy_definitions.sqlServerDB_deadlock_policy_id
    },
    {
      policyID = module.policy_definitions.sqlServerDB_cpuPercent_policy_id
    },
    {
      policyID = module.policy_definitions.sqlServerDB_connectionFailed_policy_id
    },
    {
      policyID = module.policy_definitions.sqlServerDB_blockedByFirewall_policy_id
    },
    {
      policyID = module.policy_definitions.sqlManagedInstances_ioRequests_policy_id
    },
    {
      policyID = module.policy_definitions.sqlManagedInstances_avgCPUPercent_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_failedRequests_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_healthyHostCount_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_unhealthyHostCount_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_totalRequests_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_cpuUtilization_policy_id
    },
    {
      policyID = module.policy_definitions.appGateway_clientRTT_policy_id
    },
    {
      policyID = module.policy_definitions.websvrfarm_cpuPercentage_policy_id
    },
    {
      policyID = module.policy_definitions.websvrfarm_memoryPercentage_policy_id
    },
    {
      policyID = module.policy_definitions.website_averageMemoryWorkingSet_policy_id
    },
    {
      policyID = module.policy_definitions.website_averageResponseTime_policy_id
    },
    {
      policyID = module.policy_definitions.website_cpuTime_policy_id
    },
    {
      policyID = module.policy_definitions.website_healthCheckStatus_policy_id
    },
    {
      policyID = module.policy_definitions.website_http5xx_policy_id
    },
    {
      policyID = module.policy_definitions.website_requestsInApplicationQueue_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_averageMemoryWorkingSet_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_averageResponseTime_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_cpuTime_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_healthCheckStatus_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_http5xx_policy_id
    },
    {
      policyID = module.policy_definitions.websiteSlot_requestsInApplicationQueue_policy_id
    },
    {
      policyID = module.policy_definitions.azureFirewall_health_policy_id
    },
    {
      policyID = module.policy_definitions.loadBalancer_dipAvailability_policy_id
    },
    {
      policyID = module.policy_definitions.loadBalancer_vipAvailability_policy_id
    }
  ]

  custom_policies_tag_governance = [
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.addTagToRG_policy_ids[5]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRG_policy_ids[5]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[0]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[1]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[2]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[3]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[4]
    },
    {
      policyID = module.policy_definitions.inheritTagFromRGOverwriteExisting_policy_ids[5]
    },
    {
      policyID = module.policy_definitions.bulkInheritTagsFromRG_policy_id
    }
  ]

  custom_policies_iam_governance = [
    {
      policyID = module.policy_definitions.auditRoleAssignmentType_user_policy_id
    },
    {
      policyID = module.policy_definitions.auditLockOnNetworking_policy_id
    }
  ]
}

```

### Terraform plan & apply

* Assumes current working directory is .\terraform-azurerm-policy
* This will plan/apply changes to your Azure subscription

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
```

```terraform
terraform init
terraform plan
terraform apply
```

### Azure authentication with a service principal and least privilege

* You can setup a new Azure [service principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) to your subscription for Terraform to use.
* Assign the ["Resource Policy Contributor"](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#resource-policy-contributor) built-in role for least amount of privileges required for the resources in this module.
* For the SPN to manage role assignments (required for policy assignments containing deployIfNotExists/modify policies) you can assign the ["User Access Administrator"](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#user-access-administrator) built-in role.

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
az ad sp create-for-rbac --name "Terraform-AzureRM-Policy" --role="Resource Policy Contributor" --scopes="/subscriptions/XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"

#optional
az ad sp create-for-rbac --name "Terraform-AzureRM-Policy" --role="User Access Administrator" --scopes="/subscriptions/XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
```

* Store your Azure service principal credentials as per below in a .tfvars file e.g. `subscriptionName1.tfvars` to call when using terraform plan/apply.
* Update existing main.tf and variables.tf in the parent root module of this repo to remove `#` comments that've been set for tenant_id, subscription_id, client_id, client_secret.

```
tenant_id       = "your tenant id"
subscription_id = "your subscription id"
client_id       = "your service principal appId"
client_secret   = "your service principal password"
```

### Create multiple terraform workspaces

* You can create multiple workspaces if you need to maintain multiple .tfstate files.
* Note: the workspace folder paths must exist prior to running terraform workspace cmds below.

```terraform
terraform workspace new subscriptionName1 ".\workspaces\subscriptionName1"
terraform workspace new subscriptionName2 ".\workspaces\subscriptionName2"
terraform workspace list
```

### Terraform plan & apply using a workspace and .tfvars

* Assumes current working directory is ".\terraform-azurerm-policy" and you are using an Azure service principal for AuthN.

```terraform
terraform init
terraform workspace list
terraform workspace select subscriptionName1
terraform workspace show
terraform plan -var-file=".\workspaces\subscriptionName1\subscriptionName1.tfvars"
terraform apply -var-file=".\workspaces\subscriptionName1\subscriptionName1.tfvars"
```

### Delete all created terraform resources

* Delete/remove all created terraform resources

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
```

```terraform
terraform init
terraform destroy
```

### Delete all created terraform resources using a workspace and .tfvars

```terraform
terraform init
terraform workspace list
terraform workspace select subscriptionName1
terraform workspace show
terraform destroy -var-file=".\workspaces\subscriptionName1\subscriptionName1.tfvars"
```

### Delete your Azure service principal if not needed

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
az ad sp delete --id "<appId>"
```
