# Quick powershell script to remove orphaned AAD Role Assignments from a subscription.
# WARNING: Always test scripts before running them in production environments.
# Related blog: https://jloudon.com/cloud/Removing-Unknown-Azure-RBAC-Role-Assignments-with-PowerShell/

# Authenticate to Azure 
Connect-AzAccount
Get-AzSubscription

#Common Variables
$OBJTYPE = "Unknown"

#Find Azure RBAC Role Assignments of 'Unknown' Type
$RAUNKNOWN =  Get-AzRoleAssignment | where-object {$_.ObjectType.Equals($OBJTYPE)}

#Remove each 'Unknown' Type Azure Role Assignment
$RAUNKNOWN | ForEach-Object {
$object = $_.ObjectId
$roledef = $_.RoleDefinitionName
$rolescope = $_.Scope
Remove-AzRoleAssignment -ObjectId $object -RoleDefinitionName $roledef -Scope $rolescope
}