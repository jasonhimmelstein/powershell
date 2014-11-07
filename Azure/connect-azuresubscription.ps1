#  This script can be used to connect to a specific Azure Subscription if more than one exists in your WindowsAzureProfile.xml file
#  http://www.sharepointlonghorn.com/
#  v2.14 11/06/2014
#  Jason Himmelstein

# Get the list of Azure Subscriptions you have in your WindowsAzureProfile.xml file 
Write-Host "The following are the Azure Subscriptions you are connected to:" -ForegroundColor Blue -BackgroundColor Gray
$xml = (Get-Content -raw -path "C:\Users\$env:username\AppData\Roaming\Windows Azure Powershell\AzureProfile.json") | ConvertFrom-Json
$xsub = $xml.Subscriptions | Select-Object name | out-gridview -outputmode Single -title "Azure Subscriptions"
""
$ASub = $xsub.Name
""
# Connect to the desired Azure Subscription
Write-host "You are now connected to:"
Select-AzureSubscription -SubscriptionName $ASub | ft name
Write-host "The following Cloud Services are available to you:"
Get-AzureService | fl ServiceName,affinitygroup,status