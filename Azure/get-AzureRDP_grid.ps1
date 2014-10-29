#  This script can be used to RDP to Azure IaaS VMs
#  http://www.sharepointlonghorn.com/
#  v2.0 10/28/2014
#  Jason Himmelstein

# Get the Cloud Service Name
Write-Host "The following are a part of the Azure Cloud Service you are connected to:" -ForegroundColor Blue -BackgroundColor Gray
Get-AzureService | Select-Object ServiceName,status | out-gridview -outputmode single -OutVariable ACS -title "Azure Cloud Service"
""
# How to get the VM names without using the start or stop function
$vms = get-azurevm | where {$_.ServiceName -EQ $ACS.ServiceName} 
""
Write-Host "From the list in the pop out, select the VM you wish to RDP to"-ForegroundColor Blue -BackgroundColor Gray
$RDPto = $vms | Select-Object name,status | out-gridview -outputmode Single -title "Virtual Machine to RDP to"

Get-AzureRemoteDesktopFile -ServiceName $ACS.servicename -name $RDPto.name -Launch 