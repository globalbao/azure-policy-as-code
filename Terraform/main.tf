terraform {
  backend "remote" {}
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 2.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

module "policy_assignments" {
  source = "./modules/policy-assignments"

  monitoring_governance_policyset_id      = module.policyset_definitions.monitoring_governance_policyset_id
  tag_governance_policyset_id             = module.policyset_definitions.tag_governance_policyset_id
  iam_governance_policyset_id             = module.policyset_definitions.iam_governance_policyset_id
  security_governance_policyset_id        = module.policyset_definitions.security_governance_policyset_id
  data_protection_governance_policyset_id = module.policyset_definitions.data_protection_governance_policyset_id
  logging_governance_dev_policyset_id     = module.policyset_definitions.logging_governance_dev_policyset_id
  logging_governance_prod_policyset_id    = module.policyset_definitions.logging_governance_prod_policyset_id
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


module "policy_exemptions" {
  source  = "globalbao/policy-exemptions/azurerm"
  version = "0.1.0"
  policyExemptions = {
    exemption1 = {
      deploymentMode     = "Incremental"
      name               = "logging_governance_prod"
      displayName        = "logging_governance_prod exemption for CriticalInfrastructure RG"
      description        = "logging_governance_prod exemption waives compliance on the CriticalInfrastructure RG"
      resourceGroupName  = "CriticalInfrastructure"
      policyAssignmentId = "/subscriptions/42482d91-3f4f-4012-8e45-78bf7ad4d60c/providers/Microsoft.Authorization/policyAssignments/logging_governance_prod"
      policyDefinitionReferenceIds = [
        "Configure Linux virtual machines with Azure Monitor Agent",
        "(linuxSecurityLogs)Configure Association to link Linux virtual machines to Data Collection Rule",
        "(linuxPerformanceLogs)Configure Association to link Linux virtual machines to Data Collection Rule",
        "Configure Windows virtual machines with Azure Monitor Agent",
        "(windowsSecurityLogs)Configure Association to link Windows virtual machines to Data Collection Rule",
        "(windowsPerformanceLogs)Configure Association to link Windows virtual machines to Data Collection Rule"
      ]
      exemptionCategory = "Waiver"
      expiresOn         = "2022-01-30"
      metadata = {
        "requestedBy" : "Critical Infra Team",
        "approvedBy" : "JesseLoudon",
        "approvedOn" : "2021-08-19",
        "ticketRef" : "SR-123456"
      }
    }
  }
}