# Quick powershell script to remove policy resources from Azure
# Warning: Always test scripts before running them in production environments

# Authenticate to Azure and return all subscription IDs / management group IDs you have access to
Login-AzAccount
Get-AzSubscription
Get-AzManagementGroup

# Set variable for Management Group ID
$mgId = 'myManagementGroup'

# Get Policy resources and remove them from Azure
Get-AzPolicyAssignment -Scope '/providers/Microsoft.Management/managementgroups/$mgId' | Remove-AzPolicyAssignment
Get-AzPolicySetDefinition -ManagementGroupName $mgId -Custom | Remove-AzPolicySetDefinition -Force
Get-AzPolicyDefinition | Where-Object {$_.properties.PolicyType -match 'Custom'} | Remove-AzPolicyDefinition -Force