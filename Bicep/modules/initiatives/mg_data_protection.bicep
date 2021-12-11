targetScope = 'managementGroup'

// PARAMETERS
param policySource string = 'Bicep'
param policyCategory string = 'Custom'

// VARAIBLES
var builtinPolicies1 = json(loadTextContent('./id_library/backup.json'))
var builtinPolicies2 = json(loadTextContent('./id_library/compute.json'))

// CUSTOM POLICYSETS
resource data_protection_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'data_protection_initiative'
  properties: {
    policyType: 'Custom'
    displayName: 'Data Protection Governance Initiative - MG Scope'
    description: 'Data Protection Governance Initiative - MG Scope via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '1.0.0'
    }
    parameters: {
      vaultLocation: {
        type: 'String'
        metadata: {
          displayName: 'Location (Specify the location of the VMs that you want to protect)'
          description: 'Specify the location of the VMs that you want to protect. VMs should be backed up to a vault in the same location. For example - CanadaCentral'
          strongType: 'location'
        }
      }
      inclusionTagName: {
        type: 'String'
        metadata: {
          displayName: 'Inclusion Tag Name'
          description: 'Name of the tag to use for including VMs in the scope of this policy. This should be used along with the Inclusion Tag Value parameter. Learn more at https://aka.ms/AppCentricVMBackupPolicy'
        }
        defaultValue: ''
      }
      inclusionTagValue: {
        type: 'Array'
        metadata: {
          displayName: 'Inclusion Tag Values'
          description: 'Value of the tag to use for including VMs in the scope of this policy (in case of multiple values use a comma-separated list). This should be used along with the Inclusion Tag Name parameter. Learn more at https://aka.ms/AppCentricVMBackupPolicy.'
        }
      }
      backupPolicyId: {
        type: 'String'
        metadata: {
          displayName: 'Backup Policy (of type Azure VM from a vault in the location chosen above)'
          description: 'Specify the ID of the Azure Backup policy to configure backup of the virtual machines. The selected Azure Backup policy should be of type Azure Virtual Machine. This policy needs to be in a vault that is present in the location chosen above. For example - /subscriptions/<SubscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.RecoveryServices/vaults/<VaultName>/backupPolicies/<BackupPolicyName>'
          strongType: 'Microsoft.RecoveryServices/vaults/backupPolicies'
        }
      }
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'AuditIfNotExists'
          'Disabled'
        ]
        defaultValue: 'AuditIfNotExists'
      }
      effect2: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'DeployIfNotExists'
          'AuditIfNotExists'
          'Disabled'
        ]
        defaultValue: 'DeployIfNotExists'
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: builtinPolicies1.AzureBackupShouldBeEnabledForVirtualMachines
        policyDefinitionReferenceId: 'AzureBackupShouldBeEnabledForVirtualMachines'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.ConfigureBackupOnVirtualMachinesWithAGivenTagToAnExistingRecoveryServicesVaultInTheSameLocation
        policyDefinitionReferenceId: 'ConfigureBackupOnVirtualMachinesWithAGivenTagToAnExistingRecoveryServicesVaultInTheSameLocation'
        parameters: {
          vaultLocation: {
            value: '[parameters(\'vaultLocation\')]'
          }
          inclusionTagName: {
            value: '[parameters(\'inclusionTagName\')]'
          }
          inclusionTagValue: {
            value: '[parameters(\'inclusionTagValue\')]'
          }
          backupPolicyId: {
            value: '[parameters(\'backupPolicyId\')]'
          }
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.AuditVirtualMachinesWithoutDisasterRecoveryConfigured
        policyDefinitionReferenceId: 'Compute_AuditVirtualMachinesWithoutDisasterRecoveryConfigured'
      }
    ]
  }
}

// OUTPUTS
output customInitiativeId string = data_protection_initiative.id
