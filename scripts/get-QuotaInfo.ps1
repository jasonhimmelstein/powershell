$filename = "get-quotainfo.ps1"
$version = "v2.3 updated on 08/22/2011"
# written by Jason Himmelstein
# http://www.sharepointlonghorn.com
# @jasehimm

#Display the profile version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow
""

$t = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.quotatemplates 
$tFound = $false
$webApp = Get-SPWebApplication http://pocs.onertn.ray.com | %{$_.Sites} | Get-SPSite 
$webApp | fl Url, @{n="Storage Used/1MB";e={[int]($_.Usage.Storage/1MB)}},
@{n="Storage Available Warning/1MB"; e={[int](($_.Quota).StorageWarningLevel/1MB)}},
@{n="Storage Available Maximum/1MB"; e={[int](($_.Quota).StorageMaximumLevel/1MB)}}, 
@{n="Sandboxed Resource Points Warning";e={[int](($_.Quota).UserCodeWarningLevel)}}, 
@{n="Sandboxed Resource Points Maximum";e={[int](($_.Quota).UserCodeMaximumLevel)}},
@{n="Quota Name"; e={ foreach($qt in $t){if($qt.QuotaId -eq [int](($_.Quota).QuotaID)){$qt.Name; $tFound = $true}} if($tFound -eq $false){"No Template Applied"}$tFound=$false;}} >> C:\scripts\SiteCollectionList.txt
if($parent) {$webApp.Dispose(); $t.Dispose()}