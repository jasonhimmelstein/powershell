# Connect to SharePoint Online 
$filename = "set-SPOconnection.ps1"
$version = "v1.22 updated on 02/08/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com

# Display the profile version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow

#region functions
function connect-spo
{
Write-Host "Connecting to SharePoint Online, tenancy $url" -background Gray -ForegroundColor Yellow
try
{
    Connect-SPOService -Credential $credential -URL $spoaurl -ErrorAction stop
    Write-Host "Successfully connected.." -ForegroundColor Green
}
catch
{
   Write-host "Failed to connect to $spoaurl -" $_ -ForegroundColor Red
}
}

#endregion

#region temp variables
#variables
$tusername = "jase@sharepointlonghorn.com" 
$turl = "https://splh.sharepoint.com/"
#endregion

#region build variables
# build variable strings
$url = Read-Host -Prompt "What SPO tenant do you want to connect to. If ""$turl"" please press enter otherwise type correct URL"  
if ($url -eq "") {$url = $turl}
$username = Read-Host -Prompt "What is the tenant admin account for $url. If ""$tusername"" please press enter otherwise type correct account"  
if ($username -eq "") {$username = $tusername}
#endregion

#region security
$securePassword = Read-Host -Prompt "Enter your password: " -AsSecureString   
$credential = New-Object System.Management.Automation.PsCredential($username, $securePassword)
#endregion

#region tenant admin url
# Build the tenant admin URL
$aurl = $url.Replace(".sharepoint.com","-admin.sharepoint.com") 
$burl = $aurl -replace("com/.*")
$spoaurl = $burl.Replace("sharepoint.","sharepoint.com")
#endregion 

connect-spo