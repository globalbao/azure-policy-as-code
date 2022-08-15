# PowerShell Snippet for calling Azure Policy Compliance REST API to export policy compliance status to CSV file
# Original script source - https://github.com/robotechredmond/Azure-PowerShell-Snippets/blob/master/Azure%20Policy%20-%20Export%20Compliance%20Data%20to%20CSV.ps1

# Authenticate to Azure - can automate with Azure AD Service Principal credentials

Connect-AzAccount 

# Select Azure Subscriptions to include in compliance reporting scope

    $subscriptionIds = 
        (Get-AzSubscription |
         Out-GridView `
            -Title "Select Azure Management Group to include in compliance reporting scope ..." `
            -PassThru).SubscriptionId

# Enter filename for export

    $reportDate = Get-Date -Format yyyyMMdd
    $defaultExportFile = ".\export_policy_${reportDate}.csv"
    $exportFile = Read-Host -Prompt "Export Filename (default=${defaultExportFile})"

    if (!$exportFile) {
        $exportFile = $defaultExportFile
    }

# Get token and create authorization header

    $azContext = Get-AzContext
    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($azProfile)
    $token = $profileClient.AcquireAccessToken($azContext.Subscription.TenantId)
    $authHeader = @{
        'Authorization'='Bearer ' + $token.AccessToken
    }

# Set other REST API parameters

    $apiVersion = "2019-10-01"
    $action = "POST"
    $contentType = "application/json"
    $uriPrefix = "https://management.azure.com/subscriptions/"
    $uriSuffix = "/providers/Microsoft.PolicyInsights/policyStates/latest/summarize?api-version=${apiVersion}"

# Export non-compliant policy results

    $subscriptionIds | % {

        $uri = $uriPrefix + $_ + $uriSuffix

        $summaryResults = 
            Invoke-RestMethod `
                -ContentType $contentType `
                -Uri $uri `
                -Method $action `
                -Headers $authHeader

        $nonCompliantResults =
            Invoke-RestMethod `
                -ContentType $contentType `
                -Uri $summaryResults.value.results.queryResultsUri `
                -Method $action `
                -Headers $authHeader

        $nonCompliantResults.value | ConvertTo-Csv -NoTypeInformation | Out-File -Append -FilePath $exportFile

    }