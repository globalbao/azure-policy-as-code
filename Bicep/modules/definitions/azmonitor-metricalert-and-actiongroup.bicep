targetScope = 'subscription'

// PARAMETERS   
param policySource string = 'Bicep'
param policyCategory string = 'Custom'
param actionGroupName string
param actionGroupRG string
param actionGroupID string

// VARIABLES

// OUTPUTS
output policyID string = policy.id
output policyName string = policy.name
output policyDisplayName string = policy.properties.displayName

// RESOURCES
resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
    name: 'deployMetricAlertLB_dipAvailability'
    properties: {
        displayName: 'Deploy metric alert to Load Balancer for dipAvailability'
        description: 'DeployIfNotExists a metric alert to Load Balancers for dipAvailability (Average Load Balancer health probe status per time duration)'
        policyType: 'Custom'
        mode: 'All'
        metadata: {
            category: policyCategory
            source: policySource
            version: '0.1.0'
        }
        parameters: {}
        policyRule: {
            if: {
                allOf: [
                    {
                        field: 'type'
                        equals: 'Microsoft.Network/loadBalancers'
                    }
                    {
                        field: 'Microsoft.Network/loadBalancers/sku.name'
                        equals: 'Standard' // only Standard SKU support metric alerts
                    }
                ]
            }
            then: {
                effect: 'deployIfNotExists'
                details: {
                    type: 'Microsoft.Insights/metricAlerts'
                    evaluationdelay: 'AfterProvisioningSuccess'
                    roleDefinitionIds: [
                        '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
                    ]
                    existenceCondition: {
                        allOf: [
                            {
                                field: 'Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace'
                                equals: 'Microsoft.Network/loadBalancers'
                            }
                            {
                                field: 'Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName'
                                equals: 'DipAvailability'
                            }
                            {
                                field: 'Microsoft.Insights/metricalerts/scopes[*]'
                                equals: '[concat(subscription().id, \'/resourceGroups/\', resourceGroup().name, \'/providers/Microsoft.Network/loadBalancers/\', field(\'fullName\'))]'
                            }
                        ]
                    }
                    deployment: {
                        properties: {
                            mode: 'incremental'
                            template: {
                                '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                                contentVersion: '1.0.0.0'
                                parameters: {
                                    resourceName: {
                                        type: 'String'
                                        metadata: {
                                            displayName: 'resourceName'
                                            description: 'Name of the resource'
                                        }
                                    }
                                    resourceId: {
                                        type: 'String'
                                        metadata: {
                                            displayName: 'resourceId'
                                            description: 'Resource ID of the resource emitting the metric that will be used for the comparison'
                                        }
                                    }
                                    resourceLocation: {
                                        type: 'String'
                                        metadata: {
                                            displayName: 'resourceLocation'
                                            description: 'Location of the resource'
                                        }
                                    }
                                    actionGroupName: {
                                        type: 'String'
                                        metadata: {
                                            displayName: 'actionGroupName'
                                            description: 'Name of the Action Group'
                                        }
                                    }
                                    actionGroupRG: {
                                        type: 'String'
                                        metadata: {
                                            displayName: 'actionGroupRG'
                                            description: 'Resource Group containing the Action Group'
                                        }
                                    }
                                    actionGroupId: {
                                        type: 'String'
                                        metadata: {
                                            displayName: 'actionGroupId'
                                            description: 'The ID of the action group that is triggered when the alert is activated or deactivated'
                                        }
                                    }
                                }
                                variables: {}
                                resources: [
                                    {
                                        type: 'Microsoft.Insights/metricAlerts'
                                        apiVersion: '2018-03-01'
                                        name: '[concat(parameters(\'resourceName\'), \'-DipAvailability\')]'
                                        location: 'global'
                                        properties: {
                                            description: 'Average Load Balancer health probe status per time duration'
                                            severity: '2'
                                            enabled: 'true'
                                            scopes: [
                                                '[parameters(\'resourceId\')]'
                                            ]
                                            evaluationFrequency: 'PT15M'
                                            windowSize: 'PT1H'
                                            criteria: {
                                                allOf: [
                                                    {
                                                        alertSensitivity: 'Medium'
                                                        failingPeriods: {
                                                            numberOfEvaluationPeriods: '2'
                                                            minFailingPeriodsToAlert: '1'
                                                        }
                                                        name: 'Metric1'
                                                        metricNamespace: 'Microsoft.Network/loadBalancers'
                                                        metricName: 'DipAvailability'
                                                        dimensions: [
                                                            {
                                                                name: 'ProtocolType'
                                                                operator: 'Include'
                                                                values: [
                                                                    '*'
                                                                ]
                                                            }
                                                            {
                                                                name: 'FrontendIPAddress'
                                                                operator: 'Include'
                                                                values: [
                                                                    '*'
                                                                ]
                                                            }
                                                            {
                                                                name: 'BackendIPAddress'
                                                                operator: 'Include'
                                                                values: [
                                                                    '*'
                                                                ]
                                                            }
                                                        ]
                                                        operator: 'LessThan'
                                                        timeAggregation: 'Average'
                                                        criterionType: 'DynamicThresholdCriterion'
                                                    }
                                                ]
                                                'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
                                            }
                                            autoMitigate: 'true'
                                            targetResourceType: 'Microsoft.Network/loadBalancers'
                                            targetResourceRegion: '[parameters(\'resourceLocation\')]'
                                            actions: [
                                                {
                                                    actionGroupId: actionGroupID
                                                    webHookProperties: {}
                                                }
                                            ]
                                        }
                                    }
                                ]
                            }
                            parameters: {
                                resourceName: {
                                    value: '[field(\'name\')]'
                                }
                                resourceId: {
                                    value: '[field(\'id\')]'
                                }
                                resourceLocation: {
                                    value: '[field(\'location\')]'
                                }
                                actionGroupName: {
                                    value: actionGroupName
                                }
                                actionGroupRG: {
                                    value: actionGroupRG
                                }
                                actionGroupID: {
                                    value: actionGroupID
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
