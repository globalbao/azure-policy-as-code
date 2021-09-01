# Azure-Policy-As-Code/Bicep/Learn/Level3

* Uses built-in policies and custom policies
* Uses multiple initiatives and assignments
* Custom policyDefinitionReferenceId for initiatives
* Custom non-compliance msgs for assignments targeted to the policyDefinitionReferenceId
* Advanced modules organised per resource type
* CI/CD workflow automation with GitHub Actions YAML
* Targeting multiple Azure environments with authentication via GitHub secrets
* Uses parameter files for environment-specfic values passed during deployment

[YouTube Video Timestamp 1h 11m 45s](https://www.youtube.com/watch?v=qpnMJXw6pIg&t=1h11m45s)

## Minimum Prerequisities

* [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) version 2.20.0
* bicep cli version 0.3.255 (589f0375df)
* [bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) 0.3.1 vscode extension

## Parameters

**Defaults**
```bicep
param policySource string = 'globalbao/azure-policy-as-code'
param policyCategory string = 'Custom'
param assignmentEnforcementMode string = 'Default'
param assignmentIdentityLocation string = 'australiaeast'
param mandatoryTag1Key string = 'BicepTagName'
param mandatoryTag1Value string = 'tempvalue'
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
```

**Environment-specific**
* params-devtest.json
* params-nonprod.json
* params-prod.json

## Deployment Steps

**CLI**
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

# required steps - deploy to prod
az account set -s 'xxxx-xxxx-xxxx-xxxx-xxxx'
az deployment sub create -f ./main.bicep -l australiaeast -p ./params-prod.json

# optional step to trigger a subscription-level policy compliance scan (uses current sub context)
az policy state trigger-scan --no-wait
```

**GitHub Actions**
```yaml
name: Bicep-CD
on:
  push:
    branches: [ main ]
    paths:
    - '**.bicep'
  workflow_dispatch:
#   schedule:
#   - cron: "0 0 * * *" #at the end of every day
    
jobs:

  DEVTEST-BICEP-CD:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS_DEVTEST }}
    - name: Bicep CD
      id: bicepCD
      continue-on-error: true
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -n devtest-bicep-cd -f ./Bicep/Level3/main.bicep -l australiaeast -p ./Bicep/Level3/params-devtest.json -o none
    - name: Sleep for 30s
      if: ${{ steps.bicepCD.outcome == 'failure' && steps.bicepCD.conclusion == 'success' }}
      uses: juliangruber/sleep-action@v1
      with:
        time: 30s
    - name: Bicep CD Retry
      if: ${{ steps.bicepCD.outcome == 'failure' && steps.bicepCD.conclusion == 'success' }}
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -n devtest-bicep-cd -f ./Bicep/Level3/main.bicep -l australiaeast -p ./Bicep/Level3/params-devtest.json -o none

  NONPROD-BICEP-CD:
    needs: DEVTEST-BICEP-CD
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS_NONPROD }}
    - name: Bicep CD
      id: bicepCD
      continue-on-error: true
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -n nonprod-bicep-cd -f ./Bicep/Level3/main.bicep -l australiaeast -p ./Bicep/Level3/params-nonprod.json -o none
    - name: Sleep for 30s
      if: ${{ steps.bicepCD.outcome == 'failure' && steps.bicepCD.conclusion == 'success' }}
      uses: juliangruber/sleep-action@v1
      with:
        time: 30s
    - name: Bicep CD Retry
      if: ${{ steps.bicepCD.outcome == 'failure' && steps.bicepCD.conclusion == 'success' }}
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -n nonprod-bicep-cd -f ./Bicep/Level3/main.bicep -l australiaeast -p ./Bicep/Level3/params-nonprod.json -o none

  PROD-BICEP-CD:
    needs: NONPROD-BICEP-CD
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS_PROD }}
    - name: Bicep CD
      id: bicepCD
      continue-on-error: true
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -n prod-bicep-cd -f ./Bicep/Level3/main.bicep -l australiaeast -p ./Bicep/Level3/params-prod.json -o none
    - name: Sleep for 30s
      if: ${{ steps.bicepCD.outcome == 'failure' && steps.bicepCD.conclusion == 'success' }}
      uses: juliangruber/sleep-action@v1
      with:
        time: 30s
    - name: Bicep CD Retry
      if: ${{ steps.bicepCD.outcome == 'failure' && steps.bicepCD.conclusion == 'success' }}
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -n prod-bicep-cd -f ./Bicep/Level3/main.bicep -l australiaeast -p ./Bicep/Level3/params-prod.json -o none
```

### Azure Resource Manager (ARM) Template References

* [policy definitions](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policydefinitions?tabs=json)
* [policyset definitions (initiatives)](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policysetdefinitions?tabs=json)
* [policy assignments](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyassignments?tabs=json)
