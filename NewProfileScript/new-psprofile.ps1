#  Script to create the PowerShell Profiles for every user 
$filename = "new-psprofile.ps1"
$version = "v4.03 updated on 06/10/2015"
#  Jason Himmelstein
#  http://www.sharepointlonghorn.com

#Display the profile version
Write-host "$filename $version"

#region variables
$scriptspath = "c:\PowerShellScripts"
$logspath = "c:\PowerShellLogs"
$checkforprofiles = "check-profiles.ps1"
$createprofile = "create-profiles.ps1"
$profilescript = "create-powershellprofiles.bat"
$createprofile = "create-profiles.ps1"
$checkprofileshortcut = "check-profiles.bat"
$psprofile = "C:\Users\$env:Username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$psiseprofile = "C:\Users\$env:Username\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
#endregion

#region registry
# In order to be able to make programmatic changes to the registry you need to set the remote execution policy to allow this unless you unblock this script 
Write-Host "Setting the Remote Execution policy to allow Registry changes" -foregroundcolor magenta -backgroundcolor black 
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
#endregion

#region creating blank files & folders
# This will create a logs and scripts directory off of the C:\ Root
Write-Host "Creating the logs and scripts directories..." -foregroundcolor white -backgroundcolor black
New-Item -Path $logspath -type directory -ErrorAction SilentlyContinue
New-Item -Path $scriptspath -type directory -ErrorAction SilentlyContinue

# Create the script that will be called by the Run registry entry for each user
Write-Host "Creating the file to check for existing profiles or create new ones..." -foregroundcolor white -backgroundcolor black
New-Item -type file -Path $scriptspath\$checkforprofiles

# Create the file that will be used to create PowerShell profiles 
Write-Host "Creating the creating profiles script file..." -foregroundcolor white -backgroundcolor black
New-item -type file -path $scriptspath\$createprofile -force

# Create the batch file that will be launched via the batch file shortcut for each user to create the profile
Write-Host "Creating script to create profiles..." -foregroundcolor white -backgroundcolor black
New-item -type file -path $scriptspath\$profilescript -force

# Create the batch file that will be launched via the shortcut in the All Users Startup 
Write-Host "Creating batch file to run check-profiles..." -foregroundcolor white -backgroundcolor black
New-item -type file -path $scriptspath\$checkprofileshortcut -force
#endregion

#region check-profiles.ps1
Write-Host "Adding content to the check for profiles script file..." -foregroundcolor white -backgroundcolor black
Add-Content $scriptspath\$checkforprofiles{# Script to check for PowerShell profiles and create them if they don't
# v1.3 11/5/2012
# Jason Himmelstein
# http://www.sharepointlonghorn.com

# The purpose of this script is to make sure that the PowerShell profiles prescribed for SharePoint environments
# are in in place.  This is a simple if else loop that checks to see if the folder "WindowsPowerShell" is already
# created for the logged in user.

# In order to be able to make programmatic changes to the registry you need to set the remote execution policy  to allow this
# Write-Host "Setting the Remote Execution policy to allow Registry changes" -foregroundcolor red -backgroundcolor black 
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Variable defines where the create profiles script is 
$createprofile = "c:\PowerShellScripts\create-profiles.ps1"
# Variable that calls to where the default powershell profile location is 
$userprofilecreated = "C:\Users\$env:Username\Documents\WindowsPowerShell\"

$ChkFile = $userprofilecreated 
$FileExists = Test-Path $ChkFile 
If ($FileExists -eq $True){
write-host "The profiles already exist" -ForegroundColor DarkGreen -BackgroundColor Gray}
else{powershell.exe -file $createprofile -WindowStyle Hidden | Out-File c:\Users\$env:Username\Documents\profilecreation.log}
}
#endregion

#region Microsoft.PowerShell_profile.ps1
# Add content to create-profiles.ps1 
Write-Host "Adding content to the creating profiles script file..." -foregroundcolor white -backgroundcolor black
Add-Content $scriptspath\$createprofile {
#PowerShell Profiles to be used
$filename = "Microsoft.PowerShell_profile.ps1"
$version = "v4.22 updated on 02/08/2015"
#Jason Himmelstein
#http://www.sharepointlonghorn.com

#Display the profile version
Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow
""
$psprofile = "C:\Users\$env:Username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$psiseprofile = "C:\Users\$env:Username\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"

#create empty .ps1 files
New-item -type file -path $psiseprofile -force
New-Item -type file -path $psprofile -force

# This script will set the default location in PowerShell to c:\powershellscripts
# It will also automatically load the SharePoint Snapin 
# It will let you know what user you are running in the context of
# In an Office Web Apps remove the SharePoint PSSnapin and reference in the Write-Host


Add-Content $psprofile { 
        #PowerShell Profiles to be used
        $filename = "Microsoft.PowerShell_profile.ps1"
        $version = "v4.22 updated on 02/08/2015"
        #Jason Himmelstein
        #http://www.sharepointlonghorn.com

        #Display the profile version
        Write-host "$filename $version" -BackgroundColor Black -ForegroundColor Yellow
        ""

        #region functions  
        function get-cloudy
        {
        $AZLoad = Read-Host "Do you wish to load your Azure Accounts? Type [y] to load" 
        if ($AZLoad -eq "y"){$AZLoaded = add-AzureAccount}

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

        function get-o365
        {
        try{
            $o365Load = Read-Host "Do you wish to connect to Office 365? Type [y] to load" 
            if ($o365Load -eq "y"){. .\set-o365connection.ps1}
        }
        catch
        {
            Write-host "Failed to load set-o365Conection.ps1. Check the file location in your PowerShell Profile" -ForegroundColor Red

            #to get verbose logging uncomment the following line
            #write-host "$_" -BackgroundColor Black -ForegroundColor Red 
        }
        }

        function get-SPO
        {
        try{
            $SPOLoad = Read-Host "Do you wish to connect to SharePoint Online? Type [y] to load" 
            if ($SPOLoad -eq "y"){. .\set-SPOconnection.ps1}
        }
        catch
        {
            Write-host "Failed to load set-SPOConection.ps1. Check the file location in your PowerShell Profile" -ForegroundColor Red

            #to get verbose logging uncomment the following line
            #write-host "$_" -BackgroundColor Black -ForegroundColor Red 
        }
        }

        #endregion

        # Setting the default starting path
        Set-Location c:\powershellscripts\

        #region permissions check
        if ( -not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
        { 
            Write-Host "This PowerShell prompt is not elevated" -ForegroundColor Red -BackgroundColor black
            Write-Host "If you are trying to effect change to a SharePoint environment you need to be running PowerShell as Administrator. 
        Please restart PowerShell as with the administrator token set." -ForegroundColor Yellow -BackgroundColor black
            return
        }
      
        #endregion

        #region logging
        # set logging
        $path = "C:\PowerShellLogs"
        $logname = "{0}\{1}-{2}.{3}" -f $path,$env:Username, `
            (Get-Date -Format MMddyyyy-HHmmss),"Txt"
        # Start Transcript in logs directory
        start-transcript (New-Item -Path $logname -ItemType file) -append -noclobber
         $a = Get-Date
        “Date: ” + $a.ToShortDateString()
        “Time: ” + $a.ToShortTimeString() 
        #endregion 

        #region imports
        #loading snap-ins & modules
        ""
        Write-Host "Please wait while the PowerShell snap-ins load" -foregroundcolor black -backgroundcolor gray
        Add-PSSnapin Microsoft.SharePoint.PowerShell -ea 0
        Add-PSSnapin Microsoft.Windows.AD -ea 0
        Import-Module ActiveDirectory -ErrorAction SilentlyContinue
        ""
        Write-Host "The following PowerShell Snap-ins are loaded:" -foregroundcolor darkgreen -backgroundcolor gray
        get-pssnapin
        Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1' -ErrorAction SilentlyContinue
        Import-Module 'C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.Online.SharePoint.PowerShell.psd1' -ErrorAction SilentlyContinue
        ""
        Write-Host "The following PowerShell Modules are loaded:" -foregroundcolor DarkGreen -BackgroundColor Gray
        get-module | ft Name | out-default
        #endregion

        #region CSOM
        # Loading the CSOM references from add-CSOMreferencelibraries
        try{
            ""
            Write-Host "Attempting to load CSOM Reference Libraries"
            . .\add-CSOMreferencelibraries.ps1 -ea 0
            ""
        }
        catch{
            Write-host "Failed to load add-CSOMreferencelibraries.ps1. Check the file location in your PowerShell Profile" -ForegroundColor Red
            Write-Host "Error: $_" -BackgroundColor Black -ForegroundColor Red 
            ""
        }
        #endregion

        Write-Host "You are now entering PowerShell in the context of: $env:USERDOMAIN\$env:Username" -foregroundcolor darkgreen -backgroundcolor gray

        # load additional modules with authentication 
        get-cloudy
        get-o365
        get-SPO
        }
      
#endregion

#region Microsoft.PowerShellISE_profile.ps1
# In an Office Web Apps remove the SharePoint PSSnapin and reference in the Write-Host
Add-Content $psiseprofile {
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

    }
}
#endregion

#region create-powershellprofiles.bat
# Add content to create-powershellprofiles.bat
Write-Host "Adding content to the create PowerShell Profiles batch file..." -foregroundcolor white -backgroundcolor black
Add-Content $scriptspath\$profilescript {REM Batch file to create PowerShell Profiles 
REM v1.4 01/26/2013
REM Jason Himmelstein
REM http://www.sharepointlonghorn.com

powershell.exe -command "Set-ExecutionPolicy Bypass -Scope CurrentUser -Force"
powershell.exe -file "c:\PowerShellScripts\create-profiles.ps1"
}
#endregion

#region check-profiles.bat
# Add content to check-profiles.bat
Write-Host "Adding content to the batch file to launch the check for profiles script file..." -foregroundcolor white -backgroundcolor black
Add-Content $scriptspath\$checkprofileshortcut {REM Batch file to launch the check for profiles script file
REM v1.4 01/26/2013
REM Jason Himmelstein
REM http://www.sharepointlonghorn.com

powershell.exe -WindowStyle Hidden -file c:\PowerShellScripts\check-profiles.ps1}
#endregion

#region add a shortcut link to favorites
# Add the a shortcut link to favorites in Windows Explorer to the PowerShellScripts folder
Write-Host "Adding a link to favorites in Windows Explorer to the PowerShellScripts folder..." -foregroundcolor white -backgroundcolor black
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Default\Links\PowerShellScripts.lnk")
$Shortcut.TargetPath = $scriptspath
$Shortcut.Save()
#endregion