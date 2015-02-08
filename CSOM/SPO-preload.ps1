# Script to get SharePoint Online tenant authentication information
$filename = "SPO-preloads.ps1"
$version = "v1.18 updated on 02/07/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com

# Display the profile version
Write-host "$filename $version"

#variables
$tusername = "jase@sharepointlonghorn.com" 
$turl = "https://splh.sharepoint.com/"

# build variable strings
$url = Read-Host -Prompt "What SPO tenant do you want to connect to. If ""$turl"" please press enter otherwise type correct URL"  
if ($url -eq "") {$url = $turl}
$username = Read-Host -Prompt "What is the tenant admin account for $url. If ""$tusername"" please press enter otherwise type correct account"  
if ($username -eq "") {$username = $tusername}

$pwd = Read-Host -Prompt "Enter your password: " -AsSecureString   

# connect/authenticate to SharePoint Online and get ClientContext object.. 
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url)  
$spoCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $pwd)   
$clientContext.Credentials = $spoCredentials 


if (!$clientContext.ServerObjectIsNull.Value) 
{ 
    Write-Host "Connected to SharePoint Online site: '$Url'" -ForegroundColor Green 
} 

# helpful function 
function get-SPOTenantAdminURL
{
# strips down and creates the SPO Tenant Admin URL
$aurl = $url.Replace(".sharepoint.com","-admin.sharepoint.com") 
$turl = $aurl -replace("com/.*")
$spoaurl = $burl.Replace("sharepoint.","sharepoint.com")
$spoaurl
}