# Microsoft Reactor 2022 Event: Flexing Your Security Governance with Azure Policy As Code

As seen on [YouTube: Flexing Your Security Governance with Azure Policy As Code](https://youtu.be/SuH_TBBsvLI)
Related blog post: [jloudon.com/Flexing-your-Security-Governance-with-Azure-Policy-as-Code](https://jloudon.com/cloud/Flexing-your-Security-Governance-with-Azure-Policy-as-Code/)

# Runsheet

## Deploy - resource groups
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.Resources\resourceGroups'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment create -f .\deploy-aus.bicep -l australiasoutheast -p .\.parameters\parameters-aus.json
az deployment create -f .\deploy-aue.bicep -l australiaeast -p .\.parameters\parameters-aue.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment create -f .\deploy-aus.bicep -l australiasoutheast -p .\.parameters\parameters-aus.json
az deployment create -f .\deploy-aue.bicep -l australiaeast -p .\.parameters\parameters-aue.json
```

## Deploy - log analytics workspaces
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.OperationalInsights\workspaces'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment group create --resource-group secgovdemoaus --name LAW-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name LAW-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment group create --resource-group secgovdemoaus --name LAW-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name LAW-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue.json
```

## Deploy - ddos protection plan
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.Network\ddosProtectionPlans'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment group create --resource-group secgovdemoaus --name DDOS-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment group create --resource-group secgovdemoaus --name DDOS-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
```

## Deploy - virtual networks
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.Network\virtualNetworks'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment group create --resource-group secgovdemoaus --name VNET-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name VNET-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment group create --resource-group secgovdemoaus --name VNET-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name VNET-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue.json
```

## Deploy - storage accounts
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.Storage\storageAccounts'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment group create --resource-group secgovdemoaus --name SA-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus-dev.json
az deployment group create --resource-group secgovdemoaue --name SA-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue-dev.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment group create --resource-group secgovdemoaus --name SA-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus-test.json
az deployment group create --resource-group secgovdemoaue --name SA-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue-test.json
```

## Deploy - key vaults
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.KeyVault\vaults'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment group create --resource-group secgovdemoaus --name KV-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus-dev.json
az deployment group create --resource-group secgovdemoaue --name KV-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue-dev.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment group create --resource-group secgovdemoaus --name KV-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus-test.json
az deployment group create --resource-group secgovdemoaue --name KV-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue-test.json
```

## Deploy - sql servers
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.Sql\servers'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment group create --resource-group secgovdemoaus --name SQLSVR-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name SQLSVR-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment group create --resource-group secgovdemoaus --name SQLSVR-AUS -f .\deploy-aus.bicep -p .\.parameters\parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name SQLSVR-AUE -f .\deploy-aue.bicep -p .\.parameters\parameters-aue.json
```

## Deploy - app services
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\ResourceModules\arm\Microsoft.Web\sites'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment group create --resource-group secgovdemoaus --name WA-AUS -f .\deploy-aus.bicep -p .\.parameters\wa.parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name WA-AUE -f .\deploy-aue.bicep -p .\.parameters\wa.parameters-aue.json
az deployment group create --resource-group secgovdemoaus --name FA-AUS -f .\deploy-aus.bicep -p .\.parameters\fa.parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name FA-AUE -f .\deploy-aue.bicep -p .\.parameters\fa.parameters-aue.json
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment group create --resource-group secgovdemoaus --name WA-AUS -f .\deploy-aus.bicep -p .\.parameters\wa.parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name WA-AUE -f .\deploy-aue.bicep -p .\.parameters\wa.parameters-aue.json
az deployment group create --resource-group secgovdemoaus --name FA-AUS -f .\deploy-aus.bicep -p .\.parameters\fa.parameters-aus.json
az deployment group create --resource-group secgovdemoaue --name FA-AUE -f .\deploy-aue.bicep -p .\.parameters\fa.parameters-aue.json
```

## Deploy - azure policies - dev subscription
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\azure-policy-as-code\Bicep\demos\security-governance'
az account set -s 5bf747d8-aeef-42a9-9263-07379c144d5a
az deployment sub create -f ./deploy-sub-dev.bicep -l australiaeast
az policy state trigger-scan --no-wait
```

## Deploy - azure policies - test management group
```bash
cd 'C:\Users\JesseLoudon\OneDrive\4_GitHub\GlobalBao\azure-policy-as-code\Bicep\demos\security-governance'
az account set -s 781d91ce-e381-4a27-ad7f-e0cbc0a86e39
az deployment mg create -f ./deploy-mg-test.bicep -l australiaeast -m TEST
az policy state trigger-scan --no-wait
```