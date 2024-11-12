#Inatll Microsof Graph module if not already installed

#connect to Microsoft Graph
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

Import-Module Microsoft.Graph.Identity.SignIns

# Define the conditional access policy details
$policy = @{
    displayName = "Require MFA for External Users"
    state = "enabled" # Set to "enabled" to activate the policy, "disabled" for testing
    conditions = @{
        users = @{
            includeExternalUsersOnly = $true
        }
        applications = @{
            includeApplications = @("Office365SharePointOnline") # Specify SharePoint Online only
        }
    }
    grantControls = @{
        operator = "OR"
        builtInControls = @("mfa")
    }
    sessionControls = $null
}

# Create the policy
New-MgConditionalAccessPolicy -BodyParameter $policy

# Confirm creation
Write-Output "Conditional Access Policy created successfully."



# Connect to Azure AD
Connect-AzureAD

#prompt user to ener comma separated list of external users to invite to the Azure AD
$externalUsers = Read-Host "Enter a comma separated list of external users to invite to the Azure AD"
$externalUsers = $externalUsers -split ","
foreach ($externalUser in $externalUsers) {
    # Invite external user to your Azure AD
    $invitation = New-AzureADMSInvitation -InvitedUserEmailAddress $externalUser `
                                          -InviteRedirectUrl "https://enterprisesoultionsrealized.sharepoint.com" `
                                          -SendInvitationMessage $true
}
