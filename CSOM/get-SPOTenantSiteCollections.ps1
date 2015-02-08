# Script to get all site collections of a SharePoint Online tenant
$filename = "get-SPOTenantSiteCollections.ps1"
$version = "v1.19 updated on 02/07/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com

# Display the profile version
Write-host "$filename $version"

# Pre-loaded scripts for authentication to the Admin Tenant
. .\SPO-tenantadminpreload.ps1

# Tell PowerShell to reuse the same thread when re-running this script to prevent memory leaks 
$host.Runspace.ThreadOptions = "ReuseThread"  
 
#Definition of the function that gets the list of site collections in the tenant using CSOM 
function Get-SPOTenantSiteCollections 
{ 
    try 
    {     
        Write-Host "----------------------------------------------------------------------------"  -foregroundcolor Green 
        Write-Host "Getting the Tenant Site Collections" -foregroundcolor Green 
        Write-Host "----------------------------------------------------------------------------"  -foregroundcolor Green 
      
        #SPO Client Object Model Context 
        $spoTenant= New-Object Microsoft.Online.SharePoint.TenantAdministration.Tenant($clientContext) 
        $spoTenantSiteCollections=$spoTenant.GetSiteProperties(0,$true) 
        $clientContext.Load($spoTenantSiteCollections) 
        $clientContext.ExecuteQuery() 
         
        #We need to iterate through the $spoTenantSiteCollections object to get the information of each individual Site Collection 
        foreach($spoSiteCollection in $spoTenantSiteCollections){ 
             
           $spoSiteCollection | select url,owner,template 
        } 
        $clientContext.Dispose() 
    } 
    catch [System.Exception] 
    { 
        write-host -f red $_.Exception.ToString()    
    }     
} 
 
Get-SPOTenantSiteCollections
 