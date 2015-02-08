# Script to join machines to a domain
$version = "v1.4  02/06/2015"
# Created by Jason Himmelstein
# http://www.sharepointlonghorn.com

#Display the version of this script
Write-host "Join Domain $version"

$tdomain = "kleate"
$tda = "administrator"

$domain = Read-Host -Prompt "Please specify which Domain you wish to join. If $tdomain, hit enter" 
If ($domain -eq "") {$domain = $tdomain}
$da = Read-Host -Prompt "Please specify which Domain Admin account you wish to use to join$domain. If $tda, hit enter" 
If ($da -eq "") {$da = $tda}


$username = "$domain\$da" 
Add-Computer -DomainName $domain -Credential $username
Restart-Computer -confirm