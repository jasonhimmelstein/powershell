#  This script can be used to start & stop Azure IaaS VMs
#  http://blog.sharepointlonghorn.com/
#  v1.29 12/3/2013
#  Jason Himmelstein

Function Start-AzureVMs
{
	#Start the Azure VMs in the Cloud Service
    foreach ($vm in $vms)
	{
		if($vms.Status -eq "StoppedDeallocated") 
		{
			$vm | start-azurevm
			Write-Host "The Azure VM"($vm).name"is now started" -ForegroundColor green -BackgroundColor Black
		}
		    else 
            {
                Write-host "Starting the Azure VM"($vm).name"has failed." -ForegroundColor Red -BackgroundColor Black 
            }

    }
}

Function Stop-AzureVMs
{
	#Stop the Azure VMs in the Cloud Service
	foreach ( $vm in $vms)
	{
		if( $vms.Status -ne "StoppedDeallocated") 
		{
			$vm | stop-azurevm -force
			Write-Host "The Azure VM"($vm).name"has been stopped & deallocated"  -ForegroundColor green -BackgroundColor Black
		}
		else {Write-host "Stopping the Azure VM"($vm).name"has failed." -ForegroundColor Red -BackgroundColor Black}
	} 
}

# Variables block
$tACS = "CloudService"

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
$vmsle = $vms | fl name,status
Write-Host "The following machines are a part of the $ACS Cloud Service:" -ForegroundColor Blue -BackgroundColor Gray
$vmsle
""
""
$gravy = Read-Host "Do you want to start or stop the VMs listed above? Please type either stop or start" 
if ($gravy -eq "start") {$gravy = Start-AzureVMs}
elseif ($gravy -eq "stop") {$gravy = Stop-AzureVMs} 