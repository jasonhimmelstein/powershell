# Launch PowerShell ISE as an Admin code
# v1.1  10/24/2011
# Created by Jason Himmelstein
# http://www.sharepointlonghorn.com
# @jasehimm

Add-PSSnapin Microsoft.SharePoint.PowerShell -EA 0

# Farm account name
$farmAccountname = "domain\service_account"

# Load the Farm Account Creds
$cred = Get-Credential $farmAccountname

# Create a new process with UAC elevation
Start-Process $PsHome\powershell.exe -Credential $cred -ArgumentList "-Command Start-Process $PSHOME\powershell_ise.exe -Verb Runas" -Wait