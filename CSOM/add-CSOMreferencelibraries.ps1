# Script to add CSOM reference libraries to PowerShell Session
$filename = "add-CSOMreferencelibraries.ps1"
$version = "v1.25 updated on 02/07/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com

# Display the profile version
Write-host "$filename $version"

try 
    {
# SharePoint libraries
# These are found on any SharePoint Server 2013 box in c:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.Runtime.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.Taxonomy.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.DocumentManagement.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.Publishing.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.Search.Applications.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.Search.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.UserProfiles.dll" 
Add-Type -Path "C:\PowerShellScripts\dll\Microsoft.SharePoint.Client.WorkflowServices.dll" 

# SharePoint Online library
# This comes from the SharePoint Server 2013 Client Components SDK found: http://www.microsoft.com/en-us/download/details.aspx?id=35585
Add-Type -Path "C:\Program Files\SharePoint Client Components\Assemblies\Microsoft.Online.SharePoint.Client.Tenant.dll" 
} 
        
    catch [System.Exception] 
    { 
        $outerror = $true
    }     

	If ($outerror) {	
	Write-Warning  "An error occurred while loading the CSOM reference libraries. Check the path to the files"
    }
    else {

	Write-Host "INFO: The CSOM reference libraries have loaded correctly!" -ForegroundColor Yellow
}
$outerror = $foo

