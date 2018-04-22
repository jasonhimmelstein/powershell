# Script to download all of the prerequisites for using SharePoint Online PowerShell from the local machine
$filename = "New-JHPowerShell.ps1"
$version = "v1.06 updated on 11/18/2017"
#  Jason Himmelstein
#  http://www.sharepointlonghorn.com
#  @jasehimm

#Display the profile version
Write-host "You are running $filename $version" -BackgroundColor Black -ForegroundColor Green

#region variables
$InstallersPath = 'C:\PowerShellScripts\installers\'
$url = "http://jasehimm.online/SP16ClientComponentSDK"
#endregion  

#region create installers path
New-Item -Path $InstallersPath -type directory -ErrorAction SilentlyContinue
#endregion  

#region get the file name of the download
  $tk = ((Invoke-WebRequest -UseBasicParsing -Uri $url).links | Where-Object -Property data-bi-cN -Like -Value "click here to download manually" | select -First 1).href
  $jsh = $tk.Substring($tk.LastIndexOf("/") + 1)
#endregion

#region execute download
$start_time = Get-Date  
Invoke-WebRequest -Uri $url -OutFile $InstallersPath\$jsh 
Write-Output "It took $((Get-Date).Subtract($start_time).Seconds) second(s) to download $jsh to $installerspath" 
#endregion
