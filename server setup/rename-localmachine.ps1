#  This renames a local machine
#  From http://www.sharepointlonghorn.com/
#  v1.0 02/05/2015
#  Jason Himmelstein

# specify the new computer name
$newcompname = Read-Host -Prompt "Enter name you want to give the computer"

# rename the computer
Rename-Computer -NewName $newcompname 

# Reboot the server
Restart-Computer -confirm
