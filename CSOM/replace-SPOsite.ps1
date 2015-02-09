# Script to replace an SPO Site Collection
$filename = "replace-SPOSite.ps1"
$version = "v1.25 updated on 02/08/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com

# Display the profile version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow

. .\SPO-preload.ps1

#region temp variables
# replace these details - parameters for new site collection..
$tsiteCollectionUrl = "https://splh.sharepoint.com/sites/junk "
$towner = "jase@sharepointlonghorn.com"
$tstorageQuota = "150"
$tresourceQuota = "30"
$tlocaleID = 1033 
$timeZoneID = 10 # Eastern Time (US and Canada) 
$tsitetemplate = "STS#0" # Team Site Template
#endregion

#region build variables
$owner = Read-Host -Prompt "If the Primary Site Collection Owner is not $towner please specify" 
if ($owner -eq "") {$owner = $towner}
$localeID = Read-Host -Prompt "If a Language other than English is desired, set it now" 
if ($localeID -eq "") {$localeID = $tlocaleID}
$templates = Read-Host -Prompt "If you need a list of available templates that can be used type ?, otherwise hit Enter" 
if($templates -ne "") {Get-SPOWebTemplate | Sort-Object "Name" | ft title,name}  
$sitetemplate = Read-Host -Prompt "What is the name of template to be used? If $tsitetemplate hit enter"
if ($sitetemplate -eq "") {$sitetemplate = $tsitetemplate}
$siteCollectionUrl = Read-Host "What is the name of the site you wish to delete and recreate? if $tSiteCollectionURL hit Enter"
if ($siteCollectionUrl -eq "") {$siteCollectionUrl = $tsiteCollectionUrl}
$resourceQuota = Read-Host "Specify the Resource Quota if want to use. if $tresourceQuota hit Enter"
if ($resourceQuota -eq "") {$resourceQuota = $tresourceQuota}
$storageQuota = Read-Host "Specify the Storage Quota if want to use. if $tstorageQuota hit Enter"
if ($storageQuota -eq "") {$storageQuota = $tstorageQuota}
#endregion

#region action block
#if (!$clientContext.ServerObjectIsNull.Value) 
#{ 
#    Write-Host "Connected to SharePoint Online site: '$Url'" -ForegroundColor Green 
} 
try 
{
    Write-Host "Removing site collection $siteCollectionUrl - please wait.."
    Remove-SPOSite $siteCollectionUrl -Confirm:$false -ErrorAction Continue
 
    Write-Host "Now deleting from recycle bin.."
    Remove-SPODeletedSite $siteCollectionUrl -Confirm:$false -ErrorAction Continue

    Write-Host "Waiting for 30s while SPO processes the delete before we create the new site.."
    sleep 30
         
    Write-Host "Creating new site collection at $siteCollectionUrl - please wait.."
    New-SPOSite -Url $siteCollectionUrl -Owner $owner -StorageQuota $storageQuota -LocaleId $localeID -TimeZoneId $timeZoneID -Template $sitetemplate -ErrorAction Continue
 }
 catch
 {
        Write-Host "Not connected to SharePoint Online site" -ForegroundColor Red 
        Write-Host "$_" -BackgroundColor Black -ForegroundColor Red
}
 #endregion

 #region validation
 # Validate the new site is created
    try
    { 
       $tested = test-sposite $siteCollectionUrl
       if($tested -ne "") {Write-Host "$tested.SiteUrl was recreated successfully!" -ForegroundColor Green} 
    }
    catch
    {
        Write-host "Failed to create $siteCollectionURL -" $_ -ForegroundColor Red
    }
  #endregion