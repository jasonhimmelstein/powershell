# Script to add SharePoint Install account to local administrators group
$version = "v1.4  02/06/2015"
# Created by Jason Himmelstein
# http://www.sharepointlonghorn.com

#Display the version of this script
Write-host "Set SharePoint Install Account as Local Admin $version"

#variables
$tspinstallaccount = "sp_install"

#specify account
$spinstallaccount = Read-Host -Prompt "What is the name of your SharePoint Install account? If $tspinstallaccount, hit enter" 
If ($spinstallaccount -eq "") {$spinstallaccount = $tspinstallaccount}

#do stuff
$spi = [ADSI]"WinNT://$env:computername/Administrators,group" 
$spi.psbase.Invoke("Add",([ADSI]"WinNT://$env:USERDOMAIN/$spinstallaccount").path)