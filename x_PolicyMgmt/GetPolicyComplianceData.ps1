# Define path for exported files
$FilePath = 'C:\Temp'

# Authenticate to Azure and return all subscription IDs you have access to
Login-AzAccount
Get-AzSubscription

# Set variables for 2x subscriptions
$SUB1 = "xxxxxx1"
$SUB2 = "xxxxxx2"

# Query policy states for 2x individual subscriptions listed above, filter on a policy definitionreferenceId, and export to CSV
Set-AzContext -SubscriptionId $SUB1
Get-AzPolicyState -Filter "PolicyDefinitionReferenceId eq 'deploy - configure log analytics agent to be enabled on windows virtual machines'" | select ResourceId,ResourceGroup,ComplianceState,ResourceLocation,PolicyDefinitionReferenceId | export-csv $FilePath\PolicyComplianceData.csv -NoTypeInformation -append

Set-AzContext -SubscriptionId $SUB2
Get-AzPolicyState -Filter "PolicyDefinitionReferenceId eq 'deploy - configure log analytics agent to be enabled on windows virtual machines'" | select ResourceId,ResourceGroup,ComplianceState,ResourceLocation,PolicyDefinitionReferenceId | export-csv $FilePath\PolicyComplianceData.csv -NoTypeInformation -append