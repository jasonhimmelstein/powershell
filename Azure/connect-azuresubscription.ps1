#  This script can be used to connect to a specific Azure Subscription if more than one exists in your WindowsAzureProfile.xml file
#  http://blog.sharepointlonghorn.com/
#  v1.3 12/11/2013
#  Jason Himmelstein

# Variables block
$tASub = "VS"


# Get the list of Azure Subscriptions you have in your WindowsAzureProfile.xml file 
Write-Host "The following are the Azure Subscriptions you are connected to:" -ForegroundColor Blue -BackgroundColor Gray
$xml = (Get-Content -raw -path "C:\Users\$env:username\AppData\Roaming\Windows Azure Powershell\AzureProfile.json") | ConvertFrom-Json
$xml.Subscriptions | select name
""
# Select the Azure Subscription you want to connect to
$Asub = Read-Host -Prompt "Which Azure Subscription do you wish to connect to? If ""$tAsub"" please press enter otherwise type the name of the Azure Subscriptions you wish to connect to (this is case sensitive)"  
if ($Asub -eq "") {$Asub = $tAsub}

# Connect to the desired Azure Subscription
Select-AzureSubscription -SubscriptionName $ASub

Write-host "You are now connected to ""$aSub"" and the following Cloud Services are available to you:"
Get-AzureService | fl ServiceName,affinitygroup,status
