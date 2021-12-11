targetScope = 'managementGroup'

// PARAMETERS
param policySource string = 'Bicep'
param policyCategory string = 'Custom'
param customPolicyIds array
param customPolicyNames array

// VARAIBLES
var builtinPolicies1 = json(loadTextContent('./id_library/keyvault.json'))

// CUSTOM POLICYSETS
resource keyvault_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'keyvault_initiative'
  properties: {
    policyType: 'Custom'
    displayName: 'KeyVault Governance Initiative - MG Scope'
    description: 'KeyVault Governance Initiative MG Scope via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '1.0.0'
    }
    parameters: {
      logAnalytics: {
        type: 'String'
        metadata: {
          displayName: 'Log Analytics workspace'
          description: 'Specify the Log Analytics workspace the Key Vault should be connected to.'
          strongType: 'omsWorkspace'
          assignPermissions: true
        }
      }
      allowedCAs: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed Azure Key Vault Supported CAs'
          description: 'The list of allowed certificate authorities supported by Azure Key Vault.'
        }
        allowedValues: [
          'DigiCert'
          'GlobalSign'
        ]
        defaultValue: [
          'DigiCert'
          'GlobalSign'
        ]
      }
      allowedKeyTypesCertificates: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed key types'
          description: 'The list of allowed certificate key types.'
        }
        allowedValues: [
          'RSA'
          'RSA-HSM'
          'EC'
          'EC-HSM'
        ]
        defaultValue: [
          'RSA'
          'RSA-HSM'
        ]
      }
      allowedKeyTypes: {
        type: 'Array'
        metadata: {
          displayName: 'Allowed key types'
          description: 'The list of allowed key types.'
        }
        allowedValues: [
          'RSA'
          'RSA-HSM'
          'EC'
          'EC-HSM'
        ]
        defaultValue: [
          'RSA'
          'RSA-HSM'
          'EC'
          'EC-HSM'
        ]
      }
      minimumDaysBeforeExpiration: {
        type: 'Integer'
        metadata: {
          displayName: 'The minimum days before expiration'
          description: 'Specify the minimum number of days that a key or secret should remain usable prior to expiration.'
        }
        defaultValue: 30
      }
      maximumValidityInDays: {
        type: 'Integer'
        metadata: {
          displayName: 'The maximum validity period in days'
          description: 'Specify the maximum number of days a key or secret can be valid for. Using a key or secret with a long validity period is not recommended.'
        }
        defaultValue: 200
      }
      minimumRSAKeySize: {
        type: 'Integer'
        metadata: {
          displayName: 'Minimum RSA key size'
          description: 'The minimum key size for RSA keys.'
        }
        allowedValues: [
          2048
          3072
          4096
        ]
        defaultValue: 2048
      }
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: customPolicyIds[0] //deployDiagSettingsKeyVault
        policyDefinitionReferenceId: customPolicyNames[0]
        parameters: {
          logAnalytics: {
            value: '[parameters(\'logAnalytics\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeyVaultsShouldHavePurgeProtectionEnabled
        policyDefinitionReferenceId: 'KeyVaultsShouldHavePurgeProtectionEnabled'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeyVaultsShouldHaveSoftDeleteEnabled
        policyDefinitionReferenceId: 'KeyVaultsShouldHaveSoftDeleteEnabled'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.CertificatesShouldBeIssuedByTheSpecifiedIntegratedCertificateAuthority
        policyDefinitionReferenceId: 'CertificatesShouldBeIssuedByTheSpecifiedIntegratedCertificateAuthority'
        parameters: {
          allowedCAs: {
            value: '[parameters(\'allowedCAs\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.CertificatesShouldUseAllowedKeyTypes
        policyDefinitionReferenceId: 'CertificatesShouldUseAllowedKeyTypes'
        parameters: {
          allowedKeyTypes: {
            value: '[parameters(\'allowedKeyTypesCertificates\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.CertificatesUsingRSACryptographyShouldHaveTheSpecifiedMinimumKeySize
        policyDefinitionReferenceId: 'CertificatesUsingRSACryptographyShouldHaveTheSpecifiedMinimumKeySize'
        parameters: {
          minimumRSAKeySize: {
            value: '[parameters(\'minimumRSAKeySize\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeysShouldBeTheSpecifiedCryptographicTypeRSAOrEC
        policyDefinitionReferenceId: 'KeysShouldBeTheSpecifiedCryptographicTypeRSAOrEC'
        parameters: {
          allowedKeyTypes: {
            value: '[parameters(\'allowedKeyTypes\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeyVaultKeysShouldHaveAnExpirationDate
        policyDefinitionReferenceId: 'KeyVaultKeysShouldHaveAnExpirationDate'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeysShouldHaveMoreThanTheSpecifiedNumberOfDaysBeforeExpiration
        policyDefinitionReferenceId: 'KeysShouldHaveMoreThanTheSpecifiedNumberOfDaysBeforeExpiration'
        parameters: {
          minimumDaysBeforeExpiration: {
            value: '[parameters(\'minimumDaysBeforeExpiration\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeysShouldHaveTheSpecifiedMaximumValidityPeriod
        policyDefinitionReferenceId: 'KeysShouldHaveTheSpecifiedMaximumValidityPeriod'
        parameters: {
          maximumValidityInDays: {
            value: '[parameters(\'maximumValidityInDays\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeysShouldNotBeActiveForLongerThanTheSpecifiedNumberOfDays
        policyDefinitionReferenceId: 'KeysShouldNotBeActiveForLongerThanTheSpecifiedNumberOfDays'
        parameters: {
          maximumValidityInDays: {
            value: '[parameters(\'maximumValidityInDays\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeysUsingRSACryptographyShouldHaveASpecifiedMinimumKeySize
        policyDefinitionReferenceId: 'KeysUsingRSACryptographyShouldHaveASpecifiedMinimumKeySize'
        parameters: {
          minimumRSAKeySize: {
            value: '[parameters(\'minimumRSAKeySize\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.SecretsShouldHaveContentTypeSet
        policyDefinitionReferenceId: 'SecretsShouldHaveContentTypeSet'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.KeyVaultSecretsShouldHaveAnExpirationDate
        policyDefinitionReferenceId: 'KeyVaultSecretsShouldHaveAnExpirationDate'
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.SecretsShouldHaveMoreThanTheSpecifiedNumberOfDaysBeforeExpiration
        policyDefinitionReferenceId: 'SecretsShouldHaveMoreThanTheSpecifiedNumberOfDaysBeforeExpiration'
        parameters: {
          minimumDaysBeforeExpiration: {
            value: '[parameters(\'minimumDaysBeforeExpiration\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.SecretsShouldHaveTheSpecifiedMaximumValidityPeriod
        policyDefinitionReferenceId: 'SecretsShouldHaveTheSpecifiedMaximumValidityPeriod'
        parameters: {
          maximumValidityInDays: {
            value: '[parameters(\'maximumValidityInDays\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: builtinPolicies1.SecretsShouldNotBeActiveForLongerThanTheSpecifiedNumberOfDays
        policyDefinitionReferenceId: 'SecretsShouldNotBeActiveForLongerThanTheSpecifiedNumberOfDays'
        parameters: {
          maximumValidityInDays: {
            value: '[parameters(\'maximumValidityInDays\')]'
          }
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
    ]
  }
}

// OUTPUTS
output customInitiativeId string = keyvault_initiative.id
