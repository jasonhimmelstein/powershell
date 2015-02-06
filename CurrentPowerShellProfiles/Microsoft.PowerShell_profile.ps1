#PowerShell Profiles to be used
$version = "v4.2 02/05/2015"
#Jason Himmelstein
#http://www.sharepointlonghorn.com
 
function get-cloudy
{
If($AZLoad -eq "y")
{
$xml = (Get-Content -raw -path "C:\Users\$env:username\AppData\Roaming\Windows Azure Powershell\AzureProfile.json") | ConvertFrom-Json
$xsub = $xml.Subscriptions | Select-Object name | out-gridview -outputmode Single -title "Azure Subscriptions"
Select-AzureSubscription -SubscriptionName $xsub.name
}

If($AZLoad -eq "y")
{
# Get the Cloud Service Name
Write-Host "Pick your Cloud Service" -ForegroundColor Blue -BackgroundColor Gray
$ACS = Get-AzureService | Select-Object ServiceName,affinitygroup,status | out-gridview -outputmode Single -title "Connect to a cloud service"
}

If($AZLoad -eq "y")
{
# Get the VMs from the cloud service
Write-host "These VMs are available in this Cloud Service:"
Get-AzureVM | fl name,status
}
}

#Display the profile version
Write-host "PowerShell Profile $version"

# Setting the default starting path
Set-Location c:\powershellscripts\
#PowerShell Profile for PSSnapin
# Welcome message
$Name = $env:Username
$dName = $env:USERDOMAIN + '\' + $env:Username

if ( -not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{ 
    Write-Host "This PowerShell prompt is not elevated" -ForegroundColor Red -BackgroundColor black
    Write-Host "If you are trying to effect change to a SharePoint environment you need to be running PowerShell as Administrator. 
Please restart PowerShell as with the administrator token set." -ForegroundColor Yellow -BackgroundColor black
    return
}
$path = "C:\PowerShellLogs"
$logname = "{0}\{1}-{2}.{3}" -f $path,$name, `
    (Get-Date -Format MMddyyyy-HHmmss),"Txt"
# Start Transcript in logs directory
start-transcript (New-Item -Path $logname -ItemType file) -append -noclobber
 $a = Get-Date
“Date: ” + $a.ToShortDateString()
“Time: ” + $a.ToShortTimeString() 
Write-Host "Please wait while the PowerShell snap-ins load" -foregroundcolor black -backgroundcolor gray
Add-PSSnapin Microsoft.SharePoint.PowerShell -ea 0
Add-PSSnapin Microsoft.Windows.AD -ea 0
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
Write-Host "The following PowerShell Snap-ins are loaded:" -foregroundcolor darkgreen -backgroundcolor gray
get-pssnapin
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1' -ErrorAction SilentlyContinue
Import-Module 'C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.Online.SharePoint.PowerShell.psd1' -ErrorAction SilentlyContinue
""
Write-Host "The following PowerShell Modules are loaded:" -foregroundcolor DarkGreen -BackgroundColor Gray
get-module | ft Name | out-default
Write-Host "
You are now entering PowerShell in the context of: $dName" -foregroundcolor darkgreen -backgroundcolor gray

$AZLoad = Read-Host "Do you wish to load your Azure Accounts? Type [y] to load" 
if ($AZLoad -eq "y"){$AZLoaded = add-AzureAccount}

get-cloudy
