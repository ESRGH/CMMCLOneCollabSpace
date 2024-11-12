#prompt user for the domain name
$domain = Read-Host "Enter the domain name"

# Install SharePoint Online Management Shell if not already installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
}

# Connect to SharePoint Online
$adminSiteUrl = "https://$domain-admin.sharepoint.com"
#$credential = Get-Credential
Connect-SPOService -Url $adminSiteUrl 

$siteUrl = "https://$domain.sharepoint.com/sites/ExternalSharingSite"

# Allow external sharing for the document library
Set-SPOSite -Identity $siteUrl -SharingCapability ExternalUserSharingOnly


#invite external users to the site
$groupName = "External Contributors"

#import the Azure AD module if not already imported
if (-not (Get-Module -ListAvailable -Name AzureAD)) {
    Install-Module -Name AzureAD -Force
}



#Connect to Azure AD
Connect-AzureAD

#configure the gruop to have contribute permissions to the contribute permissions to the site 
New-SPOSiteGroup -Site $siteUrl -Group $groupName -PermissionLevels "Contribute"

#prompt user to ener comma separated list of external users to invite to the Azure AD 
$externalUsers = Read-Host "Enter a comma separated list of external users to invite to the Azure AD"
foreach ($externalUser in $externalUsers) {
    #Add-SPOUser -SiteUrl $siteUrl -InvitedUserEmail $externalUser -ShareByEmailEnabled $true -SendEmail $true
    Add-SPOUser -Site $siteUrl -LoginName $externalUsers -Group $groupName

}