# Azure-Policy-As-Code/Bicep/Modules

## Authored & Tested With

* [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) version 2.27.2
* bicep cli version 0.4.613
* [bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) v0.4.613 vscode extension

[![Open in Visual Studio Code](https://open.vscode.dev/badges/open-in-vscode.svg)](https://open.vscode.dev/globalbao/azure-policy-as-code)

## Automatic Deployment

|Deployment Button                  | Description        |Parameters                      |
|:-----------------------|:------------------------------|:------------------------------|
| [![Deploy Policies Management Group Scope to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fglobalbao%2Fazure-policy-as-code%2Fmain%2FBicep%2Fmodules%2Fmg_main.json)  | Deploys Policies to **Management Group** Scope | See `mg_main.bicep`
| [![Deploy Policies Subscription Scope to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fglobalbao%2Fazure-policy-as-code%2Fmain%2FBicep%2Fmodules%2Fsub_main.json)  | Deploys Policies to **Subscription** Scope | See `sub_main.bicep`

## Manual Deployment

```bash
# (optional) step to view the JSON/ARM template
az bicep build -f ./sub_main.bicep
az bicep build -f ./mg_main.bicep

# (required) authenticate
az login
az account show

# (required) choose either Subscription (sub) or Management Group (mg) deployment

# subscription deployment
az deployment sub create -f ./sub_main.bicep -l australiaeast -p ./sub_main_params.json --confirm-with-what-if

# management group deployment
az deployment mg create -f ./mg_main.bicep -l australiaeast -m PRODUCTION -p ./mg_main_params.json --confirm-with-what-if

# (optional) trigger a subscription-level policy compliance scan 
az policy state trigger-scan --no-wait
```

## GitHub Actions Workflows/YAML

### Bicep Continuous Integration Tests
* `automatic trigger on PR` for .bicep and .json files
* `manual trigger` on demand
* runs `Super Linter/ARM TTK` on .json files
* `builds/validates` .bicep files
* runs `what-if deployments to MG and Subscription` scopes with retry logic
* has `dependencies between jobs`

```yaml
name: Bicep-CI-Tests
on:
  pull_request:
    branches: [ main ]
    paths:
    - '**.bicep'
    - '**.json'
  workflow_dispatch:
    
jobs:

  Bicep-ValidationTests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: ARM TTK
      uses: docker://ghcr.io/github/super-linter:slim-v4
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        VALIDATE_ALL_CODEBASE: false
        DEFAULT_BRANCH: main
        VALIDATE_JSON: true
    - name: Bicep Build
      uses: aliencube/bicep-build-actions@v0.3
      with:
        files: '**/*.bicep'

  Bicep-CI-Tests-Sub-Scope:
    needs: Bicep-ValidationTests
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS_PROD }}
    - name: Bicep CI Tests
      id: bicepCI
      continue-on-error: true
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -f ./Bicep/modules/sub_main.bicep -l australiaeast -p ./Bicep/modules/sub_main_params.json --what-if
    - name: Sleep for 30s
      if: ${{ steps.bicepCI.outcome == 'failure' && steps.bicepCI.conclusion == 'success' }}
      uses: juliangruber/sleep-action@v1
      with:
        time: 30s
    - name: Bicep CI Retry
      if: ${{ steps.bicepCI.outcome == 'failure' && steps.bicepCI.conclusion == 'success' }}
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment sub create -f ./Bicep/modules/sub_main.bicep -l australiaeast -p ./Bicep/modules/sub_main_params.json --what-if

  Bicep-CI-Tests-MG-Scope:
    needs: Bicep-CI-Tests-Sub-Scope
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS_PROD }}
    - name: Bicep CI Tests
      id: bicepCI
      continue-on-error: true
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment mg create -f ./Bicep/modules/mg_main.bicep -l australiaeast -m PRODUCTION -p ./Bicep/modules/mg_main_params.json --what-if
    - name: Sleep for 30s
      if: ${{ steps.bicepCI.outcome == 'failure' && steps.bicepCI.conclusion == 'success' }}
      uses: juliangruber/sleep-action@v1
      with:
        time: 30s
    - name: Bicep CI Retry
      if: ${{ steps.bicepCI.outcome == 'failure' && steps.bicepCI.conclusion == 'success' }}
      uses: azure/CLI@v1
      with:
        inlineScript: |
          az deployment mg create -f ./Bicep/modules/mg_main.bicep -l australiaeast -m PRODUCTION -p ./Bicep/modules/mg_main_params.json --what-if
```

### Bicep Continuous Deployment Tests
* `automatic trigger on push` for .bicep and .json files
* `automatic trigger once per day`
* `manual trigger` on demand
* runs `Super Linter/ARM TTK` on .json files
* `builds/validates` .bicep files
* runs `deployments to MG and Subscription` scopes with retry logic
* has `dependencies between jobs`

```yaml
name: Bicep-CD-Tests
on:
  push:
    branches: [ main ]
    paths:
    - '**.bicep'
    - '**.json'
  schedule:
   - cron: "0 0 * * *" #at the end of every day
  workflow_dispatch:
    
jobs:

  Bicep-ValidationTests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: ARM TTK
      uses: docker://ghcr.io/github/super-linter:slim-v4
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        VALIDATE_ALL_CODEBASE: false
        DEFAULT_BRANCH: main
        VALIDATE_JSON: true
    - name: Bicep Build
      uses: aliencube/bicep-build-actions@v0.3
      with:
        files: '**/*.bicep'

  Bicep-CD-Tests-Sub-Scope:
    needs: Bicep-ValidationTests
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
          az deployment sub create -f ./Bicep/modules/sub_main.bicep -l australiaeast -p ./Bicep/modules/sub_main_params.json
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
          az deployment sub create -f ./Bicep/modules/sub_main.bicep -l australiaeast -p ./Bicep/modules/sub_main_params.json

  Bicep-CD-Tests-MG-Scope:
    needs: Bicep-CD-Tests-Sub-Scope
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
          az deployment mg create -f ./Bicep/modules/mg_main.bicep -l australiaeast -m PRODUCTION -p ./Bicep/modules/mg_main_params.json
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
          az deployment mg create -f ./Bicep/modules/mg_main.bicep -l australiaeast -m PRODUCTION -p ./Bicep/modules/mg_main_params.json
```

## Learning resources :books:
* [Azure Policy Overview](https://docs.microsoft.com/en-us/azure/governance/policy/overview)
* [Azure Policy Definitions](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policydefinitions?tabs=bicep)
* [Azure PolicySet Definitions (Initiatives)](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policysetdefinitions?tabs=bicep)
* [Azure Policy Assignments](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyassignments?tabs=bicep)
* [Azure Policy Exemptions](https://docs.microsoft.com/en-us/azure/templates/microsoft.authorization/policyexemptions?tabs=bicep)
* [Azure Policy Remediations](https://docs.microsoft.com/en-us/azure/templates/microsoft.policyinsights/remediations?tabs=bicep)

## Blogs that might interest you :pencil:

* [Global Azure: Policy as Code with Bicep for Enterprise Scale](https://jloudon.com/cloud/Global-Azure-Policy-as-Code-with-Bicep-for-Enterprise-Scale/)
* [Azure Spring Clean: DINE to Automate your Monitoring Governance with Azure Monitor Metric Alerts](https://jloudon.com/cloud/Azure-Spring-Clean-DINE-to-Automate-your-Monitoring-Governance-with-Azure-Monitor-Metric-Alerts/)
* [Cloud Governance with Azure Policy Part 1](https://jloudon.com/cloud/Cloud-Governance-with-Azure-Policy-Part-1/)
* [Cloud Governance with Azure Policy Part 2](https://jloudon.com/cloud/Cloud-Governance-with-Azure-Policy-Part-2/)

## Get in touch :octocat:

Twitter: [@coder_au](https://twitter.com/coder_au) | LinkedIn: [@JesseLoudon](https://www.linkedin.com/in/jesseloudon/) | Web: [jloudon.com](https://jloudon.com) | GitHub: [@JesseLoudon](https://github.com/jesseloudon)