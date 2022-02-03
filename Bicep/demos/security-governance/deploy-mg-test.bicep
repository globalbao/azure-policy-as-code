targetScope = 'managementGroup'

resource AzSecBenchmarkAssign 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'AzSecBenchmark'
  location: 'AustraliaEast'
  properties: {
    displayName: 'Azure Security Benchmark - Microsoft Reactor 2022 - MG Scope'
    description: 'Applies Azure Security Benchmark policies at Management Group scope'
    enforcementMode: 'Default'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
    nonComplianceMessages: [
      {
        message: 'Denied by Azure Security Benchmark @ Microsoft Reactor 2022 contact Jesse Loudon for more information'
      }
    ]
  }
}

resource SecGovDemoAssign 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'SecGovDemoAssign'
  location: 'AustraliaEast'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Security Governance Demo - Microsoft Reactor 2022 - MG Scope'
    description: 'Applies baseline security governance at Management Group scope'
    enforcementMode: 'Default'
    policyDefinitionId: SecGovDemoDef.id
    nonComplianceMessages: [
      {
        message: 'Denied by Security Governance Demo @ Microsoft Reactor 2022 contact Jesse Loudon for more information'
      }
    ]
  }
}

resource SecGovDemoDef 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'SecGovDemoDef'
  properties: {
    displayName: 'Security Governance Demo - Microsoft Reactor 2022'
    policyType: 'Custom'
    description: 'Applies baseline security governance'
    metadata: {
      version: '0.1.0'
      category: 'Custom'
      source: 'globalbao/azure-policy-as-code'
    }
    policyDefinitions: [
      {
        policyDefinitionId: '/providers/Microsoft.Management/managementGroups/TEST/providers/Microsoft.Authorization/policyDefinitions/audit_roleAssignments'
        policyDefinitionReferenceId: 'Audit role assignments'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/9297c21d-2ed6-4474-b48f-163f75654ce3'
        policyDefinitionReferenceId: 'MFA should be enabled accounts with write permissions on your subscription'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/aa633080-8b72-40c4-a2d7-d00c03e80bed'
        policyDefinitionReferenceId: 'MFA should be enabled on accounts with owner permissions on your subscription'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e3576e28-8b17-4677-84c3-db2990658d64'
        policyDefinitionReferenceId: 'MFA should be enabled on accounts with read permissions on your subscription'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e3576e28-8b17-4677-84c3-db2990658d64'
        policyDefinitionReferenceId: 'All network ports should be restricted on network security groups associated to your virtual machine'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e1cd26a-5090-4fdb-9d6a-84a90335e22d'
        policyDefinitionReferenceId: 'AUE - Configure network security groups to use specific workspace for traffic analytics'
        parameters: {
          nsgRegion: {
            value: 'australiaeast'
          }
          storageId: {
            value: '/subscriptions/5bf747d8-aeef-42a9-9263-07379c144d5a/resourceGroups/secgovdemoaue/providers/Microsoft.Storage/storageAccounts/secgovdemoauetest'
          }
          workspaceResourceId: {
            value: '/subscriptions/5bf747d8-aeef-42a9-9263-07379c144d5a/resourceGroups/secgovdemoaue/providers/Microsoft.OperationalInsights/workspaces/secgovdemoaue'
          }
          workspaceRegion: {
            value: 'australiaeast'
          }
          workspaceId: {
            value: 'dbdc3853-90df-4cb4-8e5d-274cf783a0d6'
          }
          networkWatcherRG: {
            value: 'NetworkWatcherRG'
          }
          networkWatcherName: {
            value: 'NetworkWatcher_australiaeast'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e1cd26a-5090-4fdb-9d6a-84a90335e22d'
        policyDefinitionReferenceId: 'AUS - Configure network security groups to use specific workspace for traffic analytics'
        parameters: {
          nsgRegion: {
            value: 'australiasoutheast'
          }
          storageId: {
            value: '/subscriptions/5bf747d8-aeef-42a9-9263-07379c144d5a/resourceGroups/secgovdemoaus/providers/Microsoft.Storage/storageAccounts/secgovdemoausdev'
          }
          workspaceResourceId: {
            value: '/subscriptions/5bf747d8-aeef-42a9-9263-07379c144d5a/resourceGroups/secgovdemoaus/providers/Microsoft.OperationalInsights/workspaces/secgovdemoaus'
          }
          workspaceRegion: {
            value: 'australiasoutheast'
          }
          workspaceId: {
            value: '4e9c33d6-109a-49aa-9f53-88abd746cc44'
          }
          networkWatcherRG: {
            value: 'NetworkWatcherRG'
          }
          networkWatcherName: {
            value: 'NetworkWatcher_australiasoutheast'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e71308d3-144b-4262-b144-efdc3cc90517'
        policyDefinitionReferenceId: 'Subnets should be associated with a Network Security Group'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/f6de0be7-9a8a-4b8a-b349-43cf02d22f7c'
        policyDefinitionReferenceId: 'Internet-facing virtual machines should be protected with network security groups'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/bb91dfba-c30d-4263-9add-9c2384e659a6'
        policyDefinitionReferenceId: 'Non-internet-facing virtual machines should be protected with network security groups'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751'
        policyDefinitionReferenceId: '[Preview]: Storage account public access should be disallowed'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/2a1a9cdf-e04d-429a-8416-3bfb72a1b26f'
        policyDefinitionReferenceId: 'Storage accounts should restrict network access using virtual network rules'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/ca91455f-eace-4f96-be59-e6e2c35b4816'
        policyDefinitionReferenceId: 'Managed disks should be double encrypted with both platform-managed and customer-managed keys'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/3657f5a0-770e-44a3-b44e-9431ba1e9735'
        policyDefinitionReferenceId: 'Automation account variables should be encrypted'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
        policyDefinitionReferenceId: 'Deploy SQL DB transparent data encryption'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/17k78e20-9358-41c9-923c-fb736d382a12'
        policyDefinitionReferenceId: 'Transparent Data Encryption on SQL databases should be enabled '
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0961003e-5a0a-4549-abde-af6a37f2724d'
        policyDefinitionReferenceId: 'Virtual machines should encrypt temp disks, caches, and data flows between Compute and Storage resources'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114'
        policyDefinitionReferenceId: 'Network interfaces should not have public IPs'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/752154a7-1e0f-45c6-a880-ac75a7e4f648'
        policyDefinitionReferenceId: 'Public IP addresses should have resource logs enabled for Azure DDoS Protection Standard'
        parameters: {
          profileName: {
            value: 'secgovdemo'
          }
          logAnalytics: {
            value: 'dbdc3853-90df-4cb4-8e5d-274cf783a0d6'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
        policyDefinitionReferenceId: 'Virtual networks should be protected by Azure DDoS Protection Standard'
        parameters: {
          effect: {
            value: 'Audit'
          }
          ddosPlan: {
            value: '/subscriptions/5bf747d8-aeef-42a9-9263-07379c144d5a/resourceGroups/secgovdemoaus/providers/Microsoft.Network/ddosProtectionPlans/secgovdemoaus'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/32e6bbec-16b6-44c2-be37-c5b672d103cf'
        policyDefinitionReferenceId: 'Azure SQL Database should have the minimal TLS version of 1.2'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8793640-60f7-487c-b5c3-1d37215905c4'
        policyDefinitionReferenceId: 'SQL Managed Instance should have the minimal TLS version of 1.2'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b'
        policyDefinitionReferenceId: 'Latest TLS version should be used in your Web App'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/f9d614c5-c173-4d56-95a7-b4437057d193'
        policyDefinitionReferenceId: 'Latest TLS version should be used in your Function App'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/2c034a29-2a5f-4857-b120-f800fe5549ae'
        policyDefinitionReferenceId: 'Configure App Service slots to disable local authentication for SCM sites'
        parameters: {
          effect: {
            value: 'DeployIfNotExists'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/5e97b776-f380-4722-a9a3-e7f0be029e79'
        policyDefinitionReferenceId: 'Configure App Service to disable local authentication for SCM sites'
        parameters: {
          effect: {
            value: 'DeployIfNotExists'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/f493116f-3b7f-4ab3-bf80-0c2af35e46c2'
        policyDefinitionReferenceId: 'Configure App Service slots to disable local authentication for FTP deployments'
        parameters: {
          effect: {
            value: 'DeployIfNotExists'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/572e342c-c920-4ef5-be2e-1ed3c6a51dc5'
        policyDefinitionReferenceId: 'Configure App Service to disable local authentication on FTP deployments'
        parameters: {
          effect: {
            value: 'DeployIfNotExists'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/72bc14af-4ab8-43af-b4e4-38e7983f9a1f'
        policyDefinitionReferenceId: 'Configure App Configuration stores to disable local authentication methods'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/30d1d58e-8f96-47a5-8564-499a3f3cca81'
        policyDefinitionReferenceId: 'Configure Azure Automation account to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4dbc2f5c-51cf-4e38-9179-c7028eed2274'
        policyDefinitionReferenceId: 'Configure Batch accounts to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/14de9e63-1b31-492e-a5a3-c3f7fd57f555'
        policyDefinitionReferenceId: 'Configure Cognitive Services accounts to disable local authentication methods'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/79fdfe03-ffcb-4e55-b4d0-b925b8241759'
        policyDefinitionReferenceId: 'Configure container registries to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/dc2d41d1-4ab1-4666-a3e1-3d51c43e0049'
        policyDefinitionReferenceId: 'Configure Cosmos DB database accounts to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/8ac2748f-3bf1-4c02-a3b6-92ae68cf75b1'
        policyDefinitionReferenceId: 'Configure Azure Event Grid domains to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/2dd0e8b9-4289-4bb0-b813-1883298e9924'
        policyDefinitionReferenceId: 'Configure Azure Event Grid partner namespaces to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/1c8144d9-746a-4501-b08c-093c8d29ad04'
        policyDefinitionReferenceId: 'Configure Azure Event Grid topics to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/57f35901-8389-40bb-ac49-3ba4f86d889d'
        policyDefinitionReferenceId: 'Configure Azure Event Hub namespaces to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/9f8ba900-a70f-486e-9ffc-faf907305376'
        policyDefinitionReferenceId: 'Configure Azure IoT Hub to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/a6f9a2d0-cff7-4855-83ad-4cd750666512'
        policyDefinitionReferenceId: 'Configure Machine Learning computes to disable local authentication methods'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/4eb216f2-9dba-4979-86e6-5d7e63ce3b75'
        policyDefinitionReferenceId: 'Configure Azure Cognitive Search services to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/910711a6-8aa2-4f15-ae62-1e5b2ed3ef9e'
        policyDefinitionReferenceId: 'Configure Azure Service Bus namespaces to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/702133e5-5ec5-4f90-9638-c78e22f13b39'
        policyDefinitionReferenceId: 'Configure Azure SignalR Service to disable local authentication'
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
      }
    ]
  }
}

resource SecGovDemoRA1 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(SecGovDemoAssign.name, SecGovDemoAssign.type)
  properties: {
    principalId: SecGovDemoAssign.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  }
}
