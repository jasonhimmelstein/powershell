# Script to get SharePoint Online tenant authentication information
$filename = "SPO-tenantadminpreload.ps1"
$version = "v1.12 updated on 02/08/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com

# Display the profile version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow

#region temp variables
#variables
$tusername = "jase@sharepointlonghorn.com" 
$turl = "https://splh.sharepoint.com/sites/atrion"
#endregion

#region build variables
$url = Read-Host -Prompt "What SPO tenant do you want to connect to. If ""$turl"" please press enter otherwise type correct URL"  
if ($url -eq "") {$url = $turl}
$username = Read-Host -Prompt "What is the tenant admin account for $url. If ""$tusername"" please press enter otherwise type correct account"  
if ($username -eq "") {$username = $tusername}

$aurl = $url.Replace(".sharepoint.com","-admin.sharepoint.com") 
$burl = $aurl -replace("com/.*")
$spoaurl = $burl.Replace("sharepoint.","sharepoint.com/")
#endregion

#region security
$pwd = Read-Host -Prompt "Enter your password: " -AsSecureString   

# connect/authenticate to SharePoint Online and get ClientContext object.. 
        $clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($spoaurl)  
        $spoCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $pwd)   
        $clientContext.Credentials = $spoCredentials 
#endregion
    
if (!$clientContext.ServerObjectIsNull.Value) 
{ 
    Write-Host "Connected to SharePoint Online Tenant Admin site: '$spoaurl'" -ForegroundColor Green 
} 
