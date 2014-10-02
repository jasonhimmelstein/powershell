#  This script can be used to RDP to Azure IaaS VMs
#  http://blog.sharepointlonghorn.com/
#  v1.27 11/29/2013
#  Jason Himmelstein

# Variables block
$tACS = "CloudService"
""
""
# Get the Cloud Service Name
Write-Host "The following are a part of the Azure Cloud Service you are connected to:" -ForegroundColor Blue -BackgroundColor Gray
Get-AzureService | fl ServiceName,affinitygroup,status
$ACS = Read-Host -Prompt "Which Azure Cloud Service is hosting your VMs. If ""$tACS"" please press enter otherwise type the name of the Azure Cloud Service"  
if ($ACS -eq "") {$ACS = $tACS}
""
""
# How to get the VM names without using the start or stop function
$vms = get-azurevm | where {$_.ServiceName -EQ $ACS} 
$vmslist = $vms.name
Write-Host "The following machines are a part of the $ACS Cloud Service:" -ForegroundColor Blue -BackgroundColor Gray
$vmslist
""
""
$RDPto = Read-Host "From the list above, type the name of the VM you wish to RDP to"

Get-AzureRemoteDesktopFile -ServiceName $ACS -name $RDPto -Launch