New-VM –Name LAB-DC1 –MemoryStartupBytes 2GB -Generation 2 -BootDevice VHD -VHDPath "D:\VMs\LAB-DC1\Virtual Hard Disks\LAB-DC1.vhdx" -SwitchName "LAB_Switch" -Path "D:\VMs\" -confirm
Set-VMProcessor LAB-DC1 -Count 1
Set-VMMemory LAB-DC1 -DynamicMemoryEnabled $true -MaximumBytes 2GB

New-VM –Name LAB-App1 –MemoryStartupBytes 8GB -Generation 2 -BootDevice VHD -VHDPath "K:\LAB-App1\Virtual Hard Disks\LAB-App1.vhdx" -SwitchName "LAB_Switch" -Path "K:\" -confirm
Set-VMProcessor LAB-App1 -Count 2
Set-VMMemory LAB-App1 -DynamicMemoryEnabled $false 

New-VM –Name LAB-Web1 –MemoryStartupBytes 8GB -Generation 2 -BootDevice VHD -VHDPath "K:\LAB-Web1\Virtual Hard Disks\LAB-Web1.vhdx" -SwitchName "LAB_Switch" -Path "K:\" -confirm
Set-VMProcessor LAB-Web1 -Count 2
Set-VMMemory LAB-Web1 -DynamicMemoryEnabled $false 

New-VM –Name LAB-SQL1 –MemoryStartupBytes 8GB -Generation 2 -BootDevice VHD -VHDPath "K:\LAB-SQL1\Virtual Hard Disks\LAB-SQL1.vhdx" -SwitchName "LAB_Switch" -Path "K:\" -confirm
Set-VMProcessor LAB-SQL1 -Count 2
Set-VMMemory LAB-SQL1 -DynamicMemoryEnabled $false 

New-VM –Name OWA –MemoryStartupBytes 2GB -Generation 2 -BootDevice VHD -VHDPath "D:\VMs\OWA\Virtual Hard Disks\OWA.vhdx" -SwitchName "LAB_Switch" -Path "D:\VMs\" -confirm
Set-VMProcessor OWA -Count 1
Set-VMMemory OWA -DynamicMemoryEnabled $true -MaximumBytes 2GB

Start-VM -Name LAB-DC1
Start-VM -Name LAB-App1
Start-VM -Name LAB-Web1
Start-VM -Name LAB-SQL1
Start-VM -Name OWA
