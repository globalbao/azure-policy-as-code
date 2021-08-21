resource "azurerm_policy_definition" "appGateway_cpuUtilization" {
  name         = "appGateway_cpuUtilization"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to appGateway for cpuUtilization"
  description  = "Deploys a metric alert to appGateway for cpuUtilization (Current CPU utilization of the Application Gateway)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/appGateway"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/appGateway"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "CpuUtilization"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-appGateway_cpuUtilization')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Current CPU utilization of the Application Gateway",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/appGateway",
                            "metricName" : "CpuUtilization",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/appGateway",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }
  )
}

resource "azurerm_policy_definition" "appGateway_clientRTT" {
  name         = "appGateway_ClientRtt"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to appGateway for clientRTT"
  description  = "Deploys a metric alert to appGateway for clientRTT (Average round trip time between clients and Application Gateway)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/applicationGateways"
          },
          {
            "field" : "Microsoft.Network/applicationGateways/sku.tier",
            "equals" : "Standard_v2"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/applicationGateways"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "ClientRtt"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/applicationGateways/', field('fullName'))]"
              }
            ]
          },
          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-appGateway_clientRTT')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average round trip time between clients and Application Gateway",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/applicationGateways",
                            "metricName" : "ClientRtt",
                            "dimensions" : [
                              {
                                "name" : "Listener",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/applicationGateways",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "appGateway_unhealthyHostCount" {
  name         = "appGateway_unhealthyHostCount"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to appGateway for unhealthyHostCount"
  description  = "Deploys a metric alert to appGateway for unhealthyHostCount (Current UnhealthyHostcount of the Application Gateway)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/appGateway"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/appGateway"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "UnhealthyHostcount"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-appGateway_unhealthyHostCount')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Current UnhealthyHostcount of the Application Gateway",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/appGateway",
                            "metricName" : "UnhealthyHostcount",
                            "dimensions" : [
                              {
                                "name" : "BackendSettingsPool",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/appGateway",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "appGateway_healthyHostCount" {
  name         = "appGateway_healthyHostCount"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to appGateway for healthyHostCount"
  description  = "Deploys a metric alert to appGateway for healthyHostCount (Current HealthyHostCount of the Application Gateway)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/appGateway"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/appGateway"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "HealthyHostCount"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-appGateway_healthyHostCount')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Current HealthyHostCount of the Application Gateway",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/appGateway",
                            "metricName" : "HealthyHostCount",
                            "dimensions" : [
                              {
                                "name" : "BackendSettingsPool",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/appGateway",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "appGateway_failedRequests" {
  name         = "appGateway_failedRequests"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to appGateway for failedRequests"
  description  = "Deploys a metric alert to appGateway for failedRequests (Current FailedRequests of the Application Gateway)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/appGateway"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/appGateway"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "FailedRequests"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-appGateway_failedRequests')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Current FailedRequests of the Application Gateway",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/appGateway",
                            "metricName" : "FailedRequests",
                            "dimensions" : [
                              {
                                "name" : "BackendSettingsPool",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/appGateway",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "appGateway_totalRequests" {
  name         = "appGateway_totalRequests"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to appGateway for totalRequests"
  description  = "Deploys a metric alert to appGateway for totalRequests (Current TotalRequests of the Application Gateway)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/appGateway"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/appGateway"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "TotalRequests"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/appGateway/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-appGateway_totalRequests')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Current TotalRequests of the Application Gateway",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/appGateway",
                            "metricName" : "TotalRequests",
                            "dimensions" : [
                              {
                                "name" : "BackendSettingsPool",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/appGateway",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "azureFirewall_health" {
  name         = "azureFirewall_health"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Azure Firewall for health"
  description  = "Deploys a metric alert to Azure Firewall for health (Indicates the overall health of this firewall)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/azurefirewalls"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/azurefirewalls"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "FirewallHealth"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/azurefirewalls/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-azureFirewall_health')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Indicates the overall health of this firewall",
                      "severity" : 2,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "High",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/azurefirewalls",
                            "metricName" : "FirewallHealth",
                            "dimensions" : [
                              {
                                "name" : "Status",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              },
                              {
                                "name" : "Reason",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "LessThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/azurefirewalls",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteCircuit_arpAvailability" {
  name         = "expressRouteCircuit_arpAvailability"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteCircuit for arpAvailability"
  description  = "Deploys a metric alert to expressRouteCircuit for arpAvailability (ARP Availability from MSEE towards all peers)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteCircuits"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteCircuits"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "ArpAvailability"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteCircuits/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteCircuit_arpAvailability')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "ARP Availability from MSEE towards all peers",
                      "severity" : 1,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteCircuits",
                            "metricName" : "ArpAvailability",
                            "dimensions" : [
                              {
                                "name" : "PeeringType",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              },
                              {
                                "name" : "Peer",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "LessThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteCircuits",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteCircuit_bgpAvailability" {
  name         = "expressRouteCircuit_bgpAvailability"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteCircuit for bgpAvailability"
  description  = "Deploys a metric alert to expressRouteCircuit for bgpAvailability (BGP Availability from MSEE towards all peers)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteCircuits"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteCircuits"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "BgpAvailability"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteCircuits/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteCircuit_bgpAvailability')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "BGP Availability from MSEE towards all peers",
                      "severity" : 1,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteCircuits",
                            "metricName" : "BgpAvailability",
                            "dimensions" : [
                              {
                                "name" : "PeeringType",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              },
                              {
                                "name" : "Peer",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "LessThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteCircuits",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteCircuit_bitsInPerSecond" {
  name         = "expressRouteCircuit_bitsInPerSecond"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteCircuit for bitsInPerSecond"
  description  = "Deploys a metric alert to expressRouteCircuit for bitsInPerSecond (Bits ingressing Azure per second)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteCircuits"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteCircuits"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "BitsInPerSecond"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteCircuits/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteCircuit_bitsInPerSecond')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Bits ingressing Azure per second",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Low",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteCircuits",
                            "metricName" : "BitsInPerSecond",
                            "dimensions" : [
                              {
                                "name" : "PeeringType",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteCircuits",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteCircuit_bitsOutPerSecond" {
  name         = "expressRouteCircuit_bitsOutPerSecond"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteCircuit for bitsOutPerSecond"
  description  = "Deploys a metric alert to expressRouteCircuit for bitsOutPerSecond (Bits egressing Azure per second)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteCircuits"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteCircuits"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "BitsOutPerSecond"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteCircuits/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteCircuit_bitsOutPerSecond')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Bits egressing Azure per second",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Low",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteCircuits",
                            "metricName" : "BitsOutPerSecond",
                            "dimensions" : [
                              {
                                "name" : "PeeringType",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteCircuits",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteCircuitPeer_bitsInPerSecond" {
  name         = "expressRouteCircuitPeer_bitsInPerSecond"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteCircuitPeer for bitsInPerSecond"
  description  = "Deploys a metric alert to expressRouteCircuitPeer for bitsInPerSecond (Bits ingressing Azure per second)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteCircuits/peerings"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteCircuits/peerings"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "BitsInPerSecond"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteCircuits/peerings/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteCircuitPeer_bitsInPerSecond')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Bits ingressing Azure per second",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Low",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteCircuits/peerings",
                            "metricName" : "BitsInPerSecond",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteCircuits/peerings",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteCircuitPeer_bitsOutPerSecond" {
  name         = "expressRouteCircuitPeer_bitsOutPerSecond"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteCircuitPeer for bitsOutPerSecond"
  description  = "Deploys a metric alert to expressRouteCircuitPeer for bitsOutPerSecond (Bits egressing Azure per second)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteCircuits/peerings"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteCircuits/peerings"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "BitsOutPerSecond"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteCircuits/peerings/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteCircuitPeer_bitsOutPerSecond')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Bits egressing Azure per second",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Low",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteCircuits/peerings",
                            "metricName" : "BitsOutPerSecond",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteCircuits/peerings",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteGateway_bitsInPerSecond" {
  name         = "expressRouteGateway_bitsInPerSecond"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteGateway for bitsInPerSecond"
  description  = "Deploys a metric alert to expressRouteGateway for bitsInPerSecond (Bits ingressing Azure per second)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteGateways"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteGateways"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "ErGatewayConnectionBitsInPerSecond"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteGateways/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteGateway_bitsInPerSecond')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Bits ingressing Azure per second",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Low",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteGateways",
                            "metricName" : "ErGatewayConnectionBitsInPerSecond",
                            "dimensions" : [
                              {
                                "name" : "ConnectionName",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteGateways",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "expressRouteGateway_bitsOutPerSecond" {
  name         = "expressRouteGateway_bitsOutPerSecond"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to expressRouteGateway for bitsOutPerSecond"
  description  = "Deploys a metric alert to expressRouteGateway for bitsOutPerSecond (Bits ingressing Azure per second)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/expressRouteGateways"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/expressRouteGateways"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "ErGatewayConnectionBitsOutPerSecond"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/expressRouteGateways/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-expressRouteGateway_bitsOutPerSecond')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Bits egressing Azure per second",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT1M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Low",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/expressRouteGateways",
                            "metricName" : "ErGatewayConnectionBitsOutPerSecond",
                            "dimensions" : [
                              {
                                "name" : "ConnectionName",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/expressRouteGateways",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "loadBalancer_dipAvailability" {
  name         = "loadBalancer_dipAvailability"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Load Balancer for dipAvailability"
  description  = "Deploys a metric alert to Load Balancers for dipAvailability (Average Load Balancer health probe status per time duration)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/loadBalancers"
          },
          {
            "field" : "Microsoft.Network/loadBalancers/sku.name",
            "equals" : "Standard"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/loadBalancers"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "DipAvailability"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/loadBalancers/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-loadBalancer_dipAvailability')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average Load Balancer health probe status per time duration",
                      "severity" : 2,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/loadBalancers",
                            "metricName" : "DipAvailability",
                            "dimensions" : [
                              {
                                "name" : "ProtocolType",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              },
                              {
                                "name" : "FrontendIPAddress",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              },
                              {
                                "name" : "BackendIPAddress",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "LessThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/loadBalancers",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "loadBalancer_vipAvailability" {
  name         = "loadBalancer_vipAvailability"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Load Balancer for vipAvailability"
  description  = "Deploys a metric alert to Load Balancers for vipAvailability (Average Load Balancer data path availability per time duration)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Network/loadBalancers"
          },
          {
            "field" : "Microsoft.Network/loadBalancers/sku.name",
            "equals" : "Standard"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Network/loadBalancers"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "VipAvailability"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Network/loadBalancers/', field('fullName'))]"
              }
            ]
          },
          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-loadBalancer_vipAvailability')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average Load Balancer data path availability per time duration",
                      "severity" : 2,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Network/loadBalancers",
                            "metricName" : "VipAvailability",
                            "dimensions" : [
                              {
                                "name" : "FrontendPort",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              },
                              {
                                "name" : "FrontendIPAddress",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "LessThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Network/loadBalancers",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "sqlManagedInstances_avgCPUPercent" {
  name         = "sqlManagedInstances_avgCPUPercent"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to sqlManagedInstances for avgCPUPercent"
  description  = "Deploys a metric alert to sqlManagedInstances for avgCPUPercent"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.sql/managedinstances"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.sql/managedinstances"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "avg_cpu_percent"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/managedinstances/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-sqlManagedInstances_avgCPUPercent')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average CPU percentage",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.sql/managedinstances",
                            "metricName" : "avg_cpu_percent",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.sql/managedinstances",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "sqlManagedInstances_ioRequests" {
  name         = "sqlManagedInstances_ioRequests"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to sqlManagedInstances for ioRequests"
  description  = "Deploys a metric alert to sqlManagedInstances for ioRequests"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.sql/managedinstances"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.sql/managedinstances"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "io_requests"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/managedinstances/', field('fullName'))]"
              }
            ]
          },
          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-sqlManagedInstances_ioRequests')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "IO requests count",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.sql/managedinstances",
                            "metricName" : "io_requests",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.sql/managedinstances",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "sqlServerDB_blockedByFirewall" {
  name         = "sqlServerDB_blockedByFirewall"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to sqlServerDB for blockedByFirewall"
  description  = "Deploys a metric alert to sqlServerDB for blocked_by_firewall"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.sql/servers/databases"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.sql/servers/databases"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "blocked_by_firewall"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/servers/databases/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-sqlServerDB_blockedByFirewall')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "blocked_by_firewall",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.sql/servers/databases",
                            "metricName" : "blocked_by_firewall",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Total",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.sql/servers/databases",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "sqlServerDB_connectionFailed" {
  name         = "sqlServerDB_connectionFailed"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to sqlServerDB for connectionFailed"
  description  = "Deploys a metric alert to sqlServerDB for connectionFailed"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.sql/servers/databases"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.sql/servers/databases"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "connection_failed"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/servers/databases/', field('fullName'))]"
              }
            ]
          },
          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-sqlServerDB_connectionFailed')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "connection_failed",
                      "severity" : 2,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT5M",
                      "windowSize" : "PT30M",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.sql/servers/databases",
                            "metricName" : "connection_failed",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.sql/servers/databases",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "sqlServerDB_cpuPercent" {
  name         = "sqlServerDB_cpuPercent"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to sqlServerDB for cpuPercent"
  description  = "Deploys a metric alert to sqlServerDB for cpuPercent"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.sql/servers/databases"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.sql/servers/databases"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "cpu_percent"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/servers/databases/', field('fullName'))]"
              }
            ]
          },
          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-sqlServerDB_cpuPercent')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "cpu_percent",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.sql/servers/databases",
                            "metricName" : "cpu_percent",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.sql/servers/databases",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "sqlServerDB_deadlock" {
  name         = "sqlServerDB_deadlock"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to sqlServerDB for deadlock"
  description  = "Deploys a metric alert to sqlServerDB for deadlock"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.sql/servers/databases"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.sql/servers/databases"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "deadlock"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/servers/databases/', field('fullName'))]"
              }
            ]
          },
          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-sqlServerDB_deadlock')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "deadlock",
                      "severity" : 1,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.sql/servers/databases",
                            "metricName" : "deadlock",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Total",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.sql/servers/databases",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "sqlServerDB_storagePercent" {
  name         = "sqlServerDB_storagePercent"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to sqlServerDB for storagePercent"
  description  = "Deploys a metric alert to sqlServerDB for storagePercent"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.sql/servers/databases"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.sql/servers/databases"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "storage_percent"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.sql/servers/databases/', field('fullName'))]"
              }
            ]
          },
          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-sqlServerDB_storagePercent')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "storage_percent",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.sql/servers/databases",
                            "metricName" : "storage_percent",
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Maximum",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.sql/servers/databases",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websvrfarm_cpuPercentage" {
  name         = "websvrfarm_cpuPercentage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to WebServerFarm for cpuPercentage"
  description  = "Deploys a metric alert to WebServerFarm for cpuPercentage"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/serverfarms"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/serverfarms"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "CpuPercentage"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/serverfarms/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websvrfarm_cpuPercentage')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average Response Time",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/serverfarms",
                            "metricName" : "CpuPercentage",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/serverfarms",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websvrfarm_memoryPercentage" {
  name         = "websvrfarm_memoryPercentage"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to WebServerFarm for memoryPercentage"
  description  = "Deploys a metric alert to WebServerFarm for memoryPercentage"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/serverfarms"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/serverfarms"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "MemoryPercentage"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/serverfarms/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websvrfarm_memoryPercentage')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average Response Time",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/serverfarms",
                            "metricName" : "MemoryPercentage",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/serverfarms",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "website_averageMemoryWorkingSet" {
  name         = "website_averageMemoryWorkingSet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website for averageMemoryWorkingSet"
  description  = "Deploys a metric alert to Websites for averageMemoryWorkingSet"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "AverageMemoryWorkingSet"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-website_averageMemoryWorkingSet')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average Response Time",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites",
                            "metricName" : "AverageMemoryWorkingSet",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "website_averageResponseTime" {
  name         = "website_averageResponseTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website for averageResponseTime"
  description  = "Deploys a metric alert to Websites for averageResponseTime"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "AverageResponseTime"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-website_averageResponseTime')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Average Response Time",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites",
                            "metricName" : "AverageResponseTime",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "website_cpuTime" {
  name         = "website_cpuTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website for cpuTime"
  description  = "Deploys a metric alert to Websites for cpuTime"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "CpuTime"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    },
                    "defaultValue" : "[resourceId('Microsoft.Web/sites', parameters('resourceName'))]"
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-website_cpuTime')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "CPU Time",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Low",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites",
                            "metricName" : "CpuTime",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Total",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "website_healthCheckStatus" {
  name         = "website_healthCheckStatus"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website for healthCheckStatus"
  description  = "Deploys a metric alert to Websites for healthCheckStatus"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "HealthCheckStatus"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-website_healthCheckStatus')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Health Check Status",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites",
                            "metricName" : "HealthCheckStatus",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "LessThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "website_http5xx" {
  name         = "website_http5xx"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website for http5xx"
  description  = "Deploys a metric alert to Websites for http5xx"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "Http5xx"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-website_http5xx')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Http Server Errors",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites",
                            "metricName" : "Http5xx",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Total",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "website_requestsInApplicationQueue" {
  name         = "website_requestsInApplicationQueue"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website for requestsInApplicationQueue"
  description  = "Deploys a metric alert to Websites for requestsInApplicationQueue"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "RequestsInApplicationQueue"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-website_requestsInApplicationQueue')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Requests In Application Queue",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites",
                            "metricName" : "RequestsInApplicationQueue",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websiteSlot_averageMemoryWorkingSet" {
  name         = "websiteSlot_averageMemoryWorkingSet"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website Slots for averageMemoryWorkingSet"
  description  = "Deploys a metric alert to Website Slots averageMemoryWorkingSet"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites/slots"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites/slots"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "AverageMemoryWorkingSet"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websiteSlot_averageMemoryWorkingSet')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "AverageMemoryWorkingSet",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites/slots",
                            "metricName" : "AverageMemoryWorkingSet",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites/slots",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websiteSlot_averageResponseTime" {
  name         = "websiteSlot_averageResponseTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website Slots for averageResponseTime"
  description  = "Deploys a metric alert to Website Slots averageResponseTime"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites/slots"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites/slots"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "AverageResponseTime"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websiteSlot_averageResponseTime')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "AverageResponseTime",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites/slots",
                            "metricName" : "AverageResponseTime",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites/slots",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websiteSlot_cpuTime" {
  name         = "websiteSlot_cpuTime"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website Slots for cpuTime"
  description  = "Deploys a metric alert to Website Slots cpuTime"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites/slots"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites/slots"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "CpuTime"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websiteSlot_cpuTime')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "CpuTime",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites/slots",
                            "metricName" : "CpuTime",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Total",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites/slots",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websiteSlot_healthCheckStatus" {
  name         = "websiteSlot_healthCheckStatus"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website Slots for healthCheckStatus"
  description  = "Deploys a metric alert to Website Slots healthCheckStatus"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites/slots"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites/slots"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "HealthCheckStatus"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websiteSlot_healthCheckStatus')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "HealthCheckStatus",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites/slots",
                            "metricName" : "HealthCheckStatus",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "LessThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites/slots",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websiteSlot_http5xx" {
  name         = "websiteSlot_http5xx"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website Slots for http5xx"
  description  = "Deploys a metric alert to Website Slots http5xx (Http Server Errors)"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites/slots"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites/slots"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "Http5xx"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websiteSlot_http5xx')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Http5xx",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites/slots",
                            "metricName" : "Http5xx",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Total",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites/slots",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}

resource "azurerm_policy_definition" "websiteSlot_requestsInApplicationQueue" {
  name         = "websiteSlot_requestsInApplicationQueue"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deploy alert to Website Slots for requestsInApplicationQueue"
  description  = "Deploys a metric alert to Website Slots requestsInApplicationQueue"
  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Web/sites/slots"
          }
        ]
      },
      "then" : {
        "effect" : "deployIfNotExists",
        "details" : {
          "evaluationdelay" : "AfterProvisioningSuccess",
          "roleDefinitionIds" : [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "type" : "Microsoft.Insights/metricAlerts",
          "existenceCondition" : {
            "allOf" : [
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricNamespace",
                "equals" : "Microsoft.Web/sites/slots"
              },
              {
                "field" : "Microsoft.Insights/metricAlerts/criteria.Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria.allOf[*].metricName",
                "equals" : "RequestsInApplicationQueue"
              },
              {
                "field" : "Microsoft.Insights/metricalerts/scopes[*]",
                "equals" : "[concat(subscription().id, '/resourceGroups/', resourceGroup().name, '/providers/Microsoft.Web/sites/slots/', field('fullName'))]"
              }
            ]
          },

          "deployment" : {
            "properties" : {
              "mode" : "incremental",
              "template" : {
                "$schema" : "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion" : "1.0.0.0",
                "parameters" : {
                  "resourceName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceName",
                      "description" : "Name of the resource"
                    }
                  },
                  "resourceId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceId",
                      "description" : "Resource ID of the resource emitting the metric that will be used for the comparison"
                    }
                  },
                  "resourceLocation" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "resourceLocation",
                      "description" : "Location of the resource"
                    }
                  },
                  "actionGroupName" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupName",
                      "description" : "Name of the Action Group"
                    }
                  },
                  "actionGroupRG" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupRG",
                      "description" : "Resource Group containing the Action Group"
                    }
                  },
                  "actionGroupId" : {
                    "type" : "string",
                    "metadata" : {
                      "displayName" : "actionGroupId",
                      "description" : "The ID of the action group that is triggered when the alert is activated or deactivated"
                    },
                    "defaultValue" : "[resourceId(parameters('actionGroupRG'), 'Microsoft.Insights/ActionGroups', parameters('actionGroupName'))]"
                  }
                },
                "variables" : {},
                "resources" : [
                  {
                    "type" : "Microsoft.Insights/metricAlerts",
                    "apiVersion" : "2018-03-01",
                    "name" : "[concat(parameters('resourceName'), '-websiteSlot_requestsInApplicationQueue')]",
                    "location" : "global",
                    "properties" : {
                      "description" : "Requests In Application Queue",
                      "severity" : 3,
                      "enabled" : true,
                      "scopes" : ["[parameters('resourceId')]"],
                      "evaluationFrequency" : "PT15M",
                      "windowSize" : "PT1H",
                      "criteria" : {
                        "allOf" : [
                          {
                            "alertSensitivity" : "Medium",
                            "failingPeriods" : {
                              "numberOfEvaluationPeriods" : 2,
                              "minFailingPeriodsToAlert" : 1
                            },
                            "name" : "Metric1",
                            "metricNamespace" : "Microsoft.Web/sites/slots",
                            "metricName" : "RequestsInApplicationQueue",
                            "dimensions" : [
                              {
                                "name" : "Instance",
                                "operator" : "Include",
                                "values" : [
                                  "*"
                                ]
                              }
                            ],
                            "operator" : "GreaterThan",
                            "timeAggregation" : "Average",
                            "criterionType" : "DynamicThresholdCriterion"
                          }
                        ],
                        "odata.type" : "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
                      },
                      "autoMitigate" : true,
                      "targetResourceType" : "Microsoft.Web/sites/slots",
                      "targetResourceRegion" : "[parameters('resourceLocation')]",
                      "actions" : [
                        {
                          "actionGroupId" : "[parameters('actionGroupId')]",
                          "webHookProperties" : {}
                        }
                      ]
                    }
                  }
                ]
              },
              "parameters" : {
                "resourceName" : {
                  "value" : "[field('name')]"
                },
                "resourceId" : {
                  "value" : "[field('id')]"
                },
                "resourceLocation" : {
                  "value" : "[field('location')]"
                },
                "actionGroupName" : {
                  "value" : "${var.azure_monitor_action_group_name}"
                },
                "actionGroupRG" : {
                  "value" : "${var.azure_monitor_action_group_rg_name}"
                }
              }
            }
          }
        }
      }
    }

  )
}