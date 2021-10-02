########################################
# Description: Queries built-in Azure Policy resources (policies/policysets), builds a hashtable object with the results, and exports to JSON for consumption via Bicep.
# Note1: Excluded policies: 'Static' (type), 'Deprecated' (DisplayName), and 'Preview' (DisplayName)
# Note2: This script is modified from Justin Grote's original input as mentioned here: https://github.com/Azure/bicep/issues/1895
########################################

# Define folder path for exported JSON files
$FilePath = 'C:\Temp'

# Authenticate to Azure and return all subscription IDs you have access to
Login-AzAccount
Get-AzSubscription

# Create object for policy results
[ScriptBlock]$PolicyNameResolver = {
    $baseDisplayName = $PSItem.properties.displayname -replace '[^\s\w]',''
    $category = $PSItem.properties.metadata.category -replace '\s',''
    $name = (Get-Culture).TextInfo.ToTitleCase($baseDisplayName) -replace '\s',''
    $category + "_" + $name
}

# Query policy definitions and build hashtable
$policies = Get-AzPolicyDefinition | 
    Where-Object {$_.properties.PolicyType -match 'BuiltIn' -and $_.properties.DisplayName -cnotmatch 'Deprecated' -and $_.properties.DisplayName -cnotmatch 'Preview'}|
    Select-Object @{N='Name';E=$PolicyNameResolver}, PolicyDefinitionId |
    Sort-Object Name |
    Foreach-Object {
        '"{0}": "{1}"' -f $_.Name,$_.PolicyDefinitionId
    }

# Export policy definition results to JSON
ConvertTo-Json -InputObject $policies -Depth 10 | Out-File $FilePath\builtin_policy_definitions.json

# Query policyset definitions and build hashtable
$policysets = Get-AzPolicySetDefinition | 
    Where-Object {$_.properties.PolicyType -match 'BuiltIn' -and $_.properties.DisplayName -cnotmatch 'Deprecated' -and $_.properties.DisplayName -cnotmatch 'Preview'}|
    Select-Object @{N='Name';E=$PolicyNameResolver}, PolicySetDefinitionId |
    Sort-Object Name |
    Foreach-Object {
        '"{0}": "{1}"' -f $_.Name,$_.PolicySetDefinitionId
    }

# Export policyset definition results to JSON
ConvertTo-Json -InputObject $policysets -Depth 10 | Out-File $FilePath\builtin_policyset_definitions.json