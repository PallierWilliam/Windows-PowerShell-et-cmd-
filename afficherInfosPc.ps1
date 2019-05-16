$Computer=$env:computername

$ComputerHW = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer |
        select Manufacturer,Model | FT -AutoSize

$ComputerCPU = Get-WmiObject win32_processor -ComputerName $Computer |
        select DeviceID,Name | FT -AutoSize

$ComputerRAM = Get-WmiObject Win32_PhysicalMemory -ComputerName $Computer |
        select DeviceLocator,Manufacturer,PartNumber,Capacity,Speed | FT -AutoSize

$ComputerDisks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $Computer |
        select DeviceID,VolumeName,Size,FreeSpace | FT -AutoSize

$ComputerVideo = Get-WmiObject Win32_VideoController | Select description,driverversion

$ComputerNetwork = Get-NetAdapter | fl Name, InterfaceIndex

    Write-Host "Computer Name: $Computer"
    Write-Output $ComputerHW
    Write-Output $ComputerCPU
    Write-Output $ComputerRAM
    Write-Output $ComputerDisks
    Write-Output $ComputerVideo
    Write-Output $ComputerNetwork
