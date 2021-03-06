﻿# Script to get SharePoint Online tenant authentication information
$filename = "SPO-preloads.ps1"
$version = "v1.22 updated on 02/20/2015"
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
# build variable strings
$url = Read-Host -Prompt "What SPO tenant do you want to connect to. If ""$turl"" please press enter otherwise type correct URL"  
if ($url -eq "") {$url = $turl}
$username = Read-Host -Prompt "What is the tenant admin account for $url. If ""$tusername"" please press enter otherwise type correct account"  
if ($username -eq "") {$username = $tusername}
#endregion

#region security
$pwd = Read-Host -Prompt "Enter your password: " -AsSecureString   

# connect/authenticate to SharePoint Online and get ClientContext object.. 
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url)  
$spoCredentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $pwd)   
$clientContext.Credentials = $spoCredentials 
#endregion

if (!$clientContext.ServerObjectIsNull.Value) 
{ 
    Write-Host "Connected to SharePoint Online site: '$Url'" -ForegroundColor Green 
} 