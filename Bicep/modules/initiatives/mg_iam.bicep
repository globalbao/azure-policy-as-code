targetScope = 'managementGroup'

// PARAMETERS
param policySource string = 'Bicep'
param policyCategory string = 'Custom'
param customPolicyIds array
param customPolicyNames array

// VARAIBLES
var builtinPolicies1 = json(loadTextContent('./id_library/general.json'))
var builtinPolicies2 = json(loadTextContent('./id_library/securitycenter.json'))

// CUSTOM POLICYSETS
resource iam_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'iam_initiative'
  properties: {
    policyType: 'Custom'
    displayName: 'IAM Governance Initiative - MG Scope'
    description: 'Identity & Access Management Governance Initiative MG Scope via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '1.0.0'
    }
    parameters: {
      resourceTypes: {
        type: 'Array'
        metadata: {
          description: 'Azure resource types to audit for locks e.g. microsoft.network/expressroutecircuits and microsoft.network/expressroutegateways'
          displayName: 'Resource types to audit for locks'
        }
        defaultValue: []
      }
      lockLevel: {
        type: 'Array'
        metadata: {
          description: 'Resource lock level to audit for'
          displayName: 'Lock level'
        }
        allowedValues: [
          'ReadOnly'
          'CanNotDelete'
        ]
        defaultValue: [
          'ReadOnly'
          'CanNotDelete'
        ]
      }
      principalType: {
        type: 'String'
        metadata: {
          description: 'Which principalType to audit against e.g. User'
          displayName: 'principalType'
        }
        allowedValues: [
          'User'
          'Group'
          'ServicePrincipal'
        ]
        defaultValue: 'User'
      }
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'Audit'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
      effect2: {
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
    }
    policyDefinitions: [
      {
        policyDefinitionId: customPolicyIds[1] //auditResourceLocks
        policyDefinitionReferenceId: customPolicyNames[1]
        parameters: {
          resourceTypes: {
            value: '[parameters(\'resourceTypes\')]'
          }
          lockLevel: {
            value: '[parameters(\'lockLevel\')]'
          }
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: customPolicyIds[2] //auditRoleAssignments
        policyDefinitionReferenceId: customPolicyNames[2]
        parameters: {
          principalType: {
            value: '[parameters(\'principalType\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.AuditUsageOfCustomRBACRules
        policyDefinitionReferenceId: 'AuditUsageOfCustomRBACRules'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.CustomSubscriptionOwnerRolesShouldNotExist
        policyDefinitionReferenceId: 'CustomSubscriptionOwnerRolesShouldNotExist'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.DeprecatedAccountsShouldBeRemovedFromYourSubscription
        policyDefinitionReferenceId: 'DeprecatedAccountsShouldBeRemovedFromYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.DeprecatedAccountsWithOwnerPermissionsShouldBeRemovedFromYourSubscription
        policyDefinitionReferenceId: 'DeprecatedAccountsWithOwnerPermissionsShouldBeRemovedFromYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.ExternalAccountsWithReadPermissionsShouldBeRemovedFromYourSubscription
        policyDefinitionReferenceId: 'ExternalAccountsWithReadPermissionsShouldBeRemovedFromYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.ExternalAccountsWithWritePermissionsShouldBeRemovedFromYourSubscription
        policyDefinitionReferenceId: 'ExternalAccountsWithWritePermissionsShouldBeRemovedFromYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.ExternalAccountsWithOwnerPermissionsShouldBeRemovedFromYourSubscription
        policyDefinitionReferenceId: 'ExternalAccountsWithOwnerPermissionsShouldBeRemovedFromYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.MFAShouldBeEnabledAccountsWithWritePermissionsOnYourSubscription
        policyDefinitionReferenceId: 'MFAShouldBeEnabledAccountsWithWritePermissionsOnYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.MFAShouldBeEnabledOnAccountsWithReadPermissionsOnYourSubscription
        policyDefinitionReferenceId: 'MFAShouldBeEnabledOnAccountsWithReadPermissionsOnYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.MFAShouldBeEnabledOnAccountsWithOwnerPermissionsOnYourSubscription
        policyDefinitionReferenceId: 'MFAShouldBeEnabledOnAccountsWithOwnerPermissionsOnYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies2.ThereShouldBeMoreThanOneOwnerAssignedToYourSubscription
        policyDefinitionReferenceId: 'ThereShouldBeMoreThanOneOwnerAssignedToYourSubscription'
        parameters: {
          effect: {
            value: '[parameters(\'effect2\')]'
          }
        }
      }
    ]
  }
}

// OUTPUTS
output customInitiativeId string = iam_initiative.id
