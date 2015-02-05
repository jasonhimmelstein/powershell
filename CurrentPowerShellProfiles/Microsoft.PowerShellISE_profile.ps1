# PowerShell_ISE profile for SharePoint environments
$version = "v4.2 02/05/2015"
# Jason Himmelstein
# http://www.sharepointlonghorn.com

function get-cloudy
{
$AZLoad = Read-Host "Do you wish to load your Azure Accounts? Type [y] to load" 
if ($AZLoad -eq "y"){$AZLoaded = add-AzureAccount}

If($AZLoad -eq "y")
{
Write-Host "The following are Azure Subscriptions that you are connected to:" -ForegroundColor Blue -BackgroundColor Gray
Get-AzureSubscription | ft SubscriptionName | out-default
}
}

function Load-AzureSubscription
{
Select-AzureSubscription -SubscriptionName $Asub
}

function Load-CloudService
{
$tACS = "CloudService"

# Connect to the desired Azure Subscription
# Select-AzureSubscription -SubscriptionName $ASub
""
""
# Get the Cloud Service Name
Write-Host "The following are a part of the Azure Cloud Service you are connected to:" -ForegroundColor Blue -BackgroundColor Gray
Get-AzureService | fl ServiceName,affinitygroup,status
$ACS = Read-Host -Prompt "Which Azure Cloud Service is hosting your VMs. If ""$tACS"" please press enter otherwise type the name of the Azure Cloud Service"  
if ($ACS -eq "") {$ACS = $tACS}
}

function List-AzureVms
{
Write-host "The following VMs are now available to you as a part of the Cloud Service ""$ACS"":"
Get-AzureVM | fl name,status
}

#Display the profile version
Write-host "PowerShell Profile $version"

# Setting the default starting path
Set-Location c:\powershellscripts\
#PowerShell Profile for PSSnapin
# Welcome message
$Name = $env:Username
$dName = $env:USERDOMAIN + '\' + $env:Username
""
if ( -not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{ 
    Write-Output "This PowerShell ISE prompt is not elevated"
    write-output "If you are trying to effect change to a SharePoint environment you need to be running PowerShell ISE as Administrator. 
Please restart PowerShell ISE as with the administrator token set." 
    return
}

Function Get-logNameFromDate
 {
 Param(
  [string]$path = "c:\PowerShellLogs",
  [string]$name = "log",
  [switch]$Create
 )
 $logname = "{0}\{1}-{2}_ISE.{3}" -f $path,$name, `
    (Get-Date -Format MMddyyyy-HHmmss),"Txt" 
if($create) 
  { 
   New-Item -Path $logname -ItemType file | out-null
   $logname
  }
 else {$logname}
 } # end function get-lognamefromdate

# This works for PowerShell v2, but not yet for v3.
Function Output-ISETranscript
{
  Param(
    [string]$logname = (Get-logNameFromDate -path "C:\PowerShellLogs" -name $name -Create)
  )
  $transcriptHeader = @"
**************************************
Windows PowerShell ISE Transcript Start
Start Time: $(get-date)
UserName: $env:username
UserDomain: $env:USERDNSDOMAIN
ComputerName: $env:COMPUTERNAME
Windows version: $((Get-WmiObject win32_operatingsystem).version)
**************************************
Transcript started. Output file is $logname
"@
  $transcriptHeader >> $logname
  $psISE.CurrentPowerShellTab.Output.Text >> $logname
} #end function start-iseTranscript

Write-Host "Please wait while the PowerShell snap-ins load" -foregroundcolor black -backgroundcolor gray
Add-PSSnapin Microsoft.SharePoint.PowerShell -ea 0
Add-PSSnapin Microsoft.Windows.AD -ea 0
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
Write-Host "The following PowerShell Snap-ins are loaded:" -foregroundcolor darkgreen -backgroundcolor gray
get-pssnapin
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1'-ErrorAction SilentlyContinue
Import-Module 'C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.Online.SharePoint.PowerShell.psd1' -ErrorAction SilentlyContinue
""
Write-Host "The following PowerShell Modules are loaded:" -foregroundcolor DarkGreen -BackgroundColor Gray
get-module | ft Name | out-default
Write-Host "In PowerShell v2 when you are finished and want to log your transcript 
please use the Output-ISETranscript command before closing or wiping the window.
This command does not yet work for PowerShell v3" -foregroundcolor white -BackgroundColor DarkMagenta
Write-Host "
You are now entering PowerShell in the context of: $dName" -foregroundcolor darkgreen -backgroundcolor gray

get-cloudy