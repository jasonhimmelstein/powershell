New-VHD -Path "K:\LAB-SQL1\Virtual Hard Disks\SQLData.vhdx" -SizeBytes 40GB -fixed
Add-VMHardDiskDrive -VMName LAB-SQL1 -Path "K:\LAB-SQL1\Virtual Hard Disks\SQLData.vhdx" 

New-VHD -Path "K:\LAB-SQL1\Virtual Hard Disks\SQLLogs.vhdx" -SizeBytes 40GB -fixed
Add-VMHardDiskDrive -VMName LAB-SQL1 -Path "K:\LAB-SQL1\Virtual Hard Disks\SQLLogs.vhdx"

New-VHD -Path "K:\LAB-SQL1\Virtual Hard Disks\SQLTemp.vhdx" -SizeBytes 10GB -fixed
Add-VMHardDiskDrive -VMName LAB-SQL1 -Path "K:\LAB-SQL1\Virtual Hard Disks\SQLTemp.vhdx"