targetScope = 'subscription'

// PARAMETERS
param policySource string = 'Bicep'
param policyCategory string = 'Custom'
param customPolicyIds array
param customPolicyNames array

// CUSTOM POLICYSETS
resource appGateway_monitoring_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: 'appGateway_monitoring_initiative'
  properties: {
    policyType: 'Custom'
    displayName: 'Application Gateway Monitoring Governance Initiative - Sub Scope'
    description: 'Application Gateway Monitoring Governance Initiative - Sub Scope via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '1.0.0'
    }
    parameters: {
      actionGroupName: {
        type: 'String'
        metadata: {
          description: 'Name of the Action Group'
          displayName: 'actionGroupName'
        }
      }
      actionGroupRG: {
        type: 'String'
        metadata: {
          description: 'Resource Group containing the Action Group'
          displayName: 'actionGroupRG'
        }
      }
      autoMitigate: {
        type: 'Boolean'
        metadata: {
          description: 'Indicates whether the alert should be auto resolved or not'
          displayName: 'autoMitigate'
        }
        defaultValue: true
      }
      alertSensitivity: {
        type: 'String'
        metadata: {
          'description': 'The extent of deviation required to trigger an alert. This will affect how tight the threshold is to the metric series pattern.'
          'displayName': 'alertSensitivity'
        }
        allowedValues: [
          'High'
          'Medium'
          'Low'
        ]
        defaultValue: 'Medium'
      }
      dimensions: {
        type: 'Object'
        metadata: {
          description: 'List of dimension conditions. See https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported'
          displayName: 'dimensions'
        }
      }
      minFailingPeriodsToAlert: {
        type: 'Integer'
        metadata: {
          description: 'The number of violations to trigger an alert. Should be smaller or equal to numberOfEvaluationPeriods.'
          displayName: 'minFailingPeriodsToAlert'
        }
        defaultValue: 1
      }
      numberOfEvaluationPeriods: {
        type: 'Integer'
        metadata: {
          description: 'The number of aggregated lookback points. The lookback time window is calculated based on the aggregation granularity (windowSize) and the selected number of aggregated points.'
          displayName: 'numberOfEvaluationPeriods'
        }
        defaultValue: 2
      }
      metricName: {
        type: 'String'
        metadata: {
          description: 'Name of the metric'
          displayName: 'metricName'
        }
      }
      operator: {
        type: 'String'
        metadata: {
          description: 'The criteria operator'
          displayName: 'operator'
        }
        allowedValues: [
          'Equals'
          'GreaterThan'
          'GreaterThanOrEqual'
          'LessThan'
          'LessThanOrEqual'
          'NotEquals'
        ]
      }
      timeAggregation: {
        type: 'String'
        metadata: {
          description: 'The criteria time aggregation types'
          displayName: 'timeAggregation'
        }
        allowedValues: [
          'Average'
          'Count'
          'Maximum'
          'Minimum'
          'Total'
        ]
      }
      description: {
        type: 'String'
        metadata: {
          description: 'The description of the metric alert that will be included in the alert email'
          displayName: 'description'
        }
      }
      evaluationFrequency: {
        type: 'String'
        metadata: {
          description: 'How often the metric alert is evaluated represented in ISO 8601 duration format e.g. PT15M'
          displayName: 'evaluationFrequency'
        }
        defaultValue: 'PT15M'
      }
      severity: {
        type: 'Integer'
        metadata: {
          description: 'Alert severity'
          displayName: 'severity'
        }
        allowedValues: [
          0
          1
          2
          3
          4
        ]
        defaultValue: 3
      }
      windowSize: {
        type: 'String'
        metadata: {
          description: 'The period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold e.g. PT1H'
          displayName: 'windowSize'
        }
        'defaultValue': 'PT1H'
      }
      effect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'DeployIfNotExists'
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: customPolicyIds[7] //deployAlertAppGateway
        policyDefinitionReferenceId: 'clientRtt-${customPolicyNames[7]}'
        parameters: {
          metricName: {
            value: '[parameters(\'metricName\')]'
          }
          operator: {
            value: '[parameters(\'operator\')]'
          }
          timeAggregation: {
            value: '[parameters(\'timeAggregation\')]'
          }
          dimensions: {
            value: '[parameters(\'dimensions\')]'
          }
          description: {
            value: '[parameters(\'description\')]'
          }
          actionGroupName: {
            value: '[parameters(\'actionGroupName\')]'
          }
          actionGroupRG: {
            value: '[parameters(\'actionGroupRG\')]'
          }
          autoMitigate: {
            value: '[parameters(\'autoMitigate\')]'
          }
          alertSensitivity: {
            value: '[parameters(\'alertSensitivity\')]'
          }
          minFailingPeriodsToAlert: {
            value: '[parameters(\'minFailingPeriodsToAlert\')]'
          }
          numberOfEvaluationPeriods: {
            value: '[parameters(\'numberOfEvaluationPeriods\')]'
          }
          evaluationFrequency: {
            value: '[parameters(\'evaluationFrequency\')]'
          }
          severity: {
            value: '[parameters(\'severity\')]'
          }
          windowSize: {
            value: '[parameters(\'windowSize\')]'
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
output customInitiativeId string = appGateway_monitoring_initiative.id
