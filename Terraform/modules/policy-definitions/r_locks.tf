resource "azurerm_policy_definition" "auditLockOnNetworking" {
  name         = "auditLockOnNetworking"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit lock on networking"
  description  = "This policy audits if a resource lock 'CanNotDelete' or 'ReadOnly' has been applied to the specified Networking components."

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "field" : "type",
        "in" : "[parameters('resourceTypes')]"
      },
      "then" : {
        "effect" : "auditIfNotExists",
        "details" : {
          "type" : "Microsoft.Authorization/locks",
          "existenceCondition" : {
            "field" : "Microsoft.Authorization/locks/level",
            "in" : [
              "ReadOnly",
              "CanNotDelete"
            ]
          }
        }
      }
    }
  )
  parameters = jsonencode(
    {
      "resourceTypes" : {
        "type" : "Array",
        "metadata" : {
          "description" : "Azure resource types to audit for Locks",
          "displayName" : "resourceTypes"
        },
        "defaultValue" : [
          "microsoft.network/expressroutecircuits",
          "microsoft.network/expressroutegateways",
          "microsoft.network/virtualnetworks",
          "microsoft.network/virtualnetworkgateways",
          "microsoft.network/vpngateways",
          "microsoft.network/p2svpngateways"
        ]
      }
    }
  )
}
