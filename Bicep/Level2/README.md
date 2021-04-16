# Level 2 - Policy as Code with Bicep

* Uses built-in policies and custom policies
* Uses multiple initiatives and assignments
* 1x main.bicep
* Manual CLI deployment
* Targeting multiple Azure environments
* Uses parameter files for environment-specfic values passed during deployment

## Minimum Prerequisities

* [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) version 2.20.0
* bicep cli version 0.3.255 (589f0375df)
* [bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) 0.3.1 vscode extension

## Parameters

**Defaults**
```bicep
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param assignmentIdentityLocation string
param assignmentEnforcementMode string = 'Default'
param listOfAllowedLocations array = [
  'australiaeast'
  'australiasoutheast'
]
param listOfAllowedSKUs array = [
  'Standard_B1ls'
  'Standard_B1ms'
  'Standard_B1s'
  'Standard_B2ms'
  'Standard_B2s'
  'Standard_B4ms'
  'Standard_B4s'
]

param mandatoryTag1Key string = 'BicepTagName'
param mandatoryTag1Value string
```

**Environment-specific**
* params-devtest.json
* params-nonprod.json

## Deployment Steps

```s
# optional step to view the JSON/ARM template
az bicep build -f ./main.bicep

# required steps - azure authentication
az login
az account list

# required steps - deploy to devtest
az account set -s 'xxxx-xxxx-xxxx-xxxx-xxxx'
az deployment sub create -f ./main.bicep -l australiaeast -p ./params-devtest.json

# required steps - deploy to nonprod
az account set -s 'xxxx-xxxx-xxxx-xxxx-xxxx'
az deployment sub create -f ./main.bicep -l australiaeast -p ./params-nonprod.json

# optional step to trigger a subscription-level policy compliance scan (uses current sub context)
az policy state trigger-scan --no-wait
```

### Azure Resource Manager (ARM) Template References

* [policy definitions](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policydefinitions?tabs=json)
* [policyset definitions (initiatives)](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policysetdefinitions?tabs=json)
* [policy assignments](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyassignments?tabs=json)