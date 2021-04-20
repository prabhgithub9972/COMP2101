Prabh ( [switch]$System, 
        [switch]$Disks,
        [switch]$Network
)



if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
    Get-WmiObject win32_processor | Select NumberOfCores, MaxClockSpeed, @{n="L1 Cache Size";e={$_.L1CacheSize -as [int]}},@{n="L2 Cache Size";e={$_.L2CacheSize -as [int]}}, @{n="L3 Cache Size";e={$_.L3CacheSize -as [int]}}| fl
    Get-WmiObject win32_operatingsystem | Select Name, Version | fl
    get-ciminstance win32_videocontroller | Select @{n= "Manufacturer Name" ;e = {$_.AdapterCompatibility}} , Description ,@{n= "Display Resolution "; e = {($_.CurrentHorizontalResolution.toString()) +" X " + ($_.CurrentVerticalResolution.toString())}} | fl
    get-ciminstance win32_networkadapterconfiguration | Where-Object {$_.IPEnabled -eq $True} | Select description, index, ipaddress, ipsubnet, dnsdomain, DnsServerSearchorder| Format-Table -AutoSize
    Get-WmiObject win32_physicalmemory | Select Manufacture, Description,@{n= "Size(GB)" ; e={$_.Capacity / 1GB -as [int]}}, @{n="Bank";e={$_.BankLabel}} | ft -AutoSize
    Get-WmiObject win32_physicalmemory | Select Manufacture, Description,@{n= "Size(GB)" ; e={$_.Capacity / 1GB -as [int]}}, @{n="Bank";e={$_.BankLabel}} | ft -AutoSize 
} 
else {
    "`nYour System Information Report"
    if ($System) {
        Get-WmiObject win32_processor | Select NumberOfCores, MaxClockSpeed, @{n="L1 Cache Size";e={$_.L1CacheSize -as [int]}},@{n="L2 Cache Size";e={$_.L2CacheSize -as [int]}}, @{n="L3 Cache Size";e={$_.L3CacheSize -as [int]}}| fl
        Get-WmiObject win32_operatingsystem | Select Name, Version | fl
        get-ciminstance win32_videocontroller | Select @{n= "Manufacturer Name" ;e = {$_.AdapterCompatibility}} , Description ,@{n= "Display Resolution "; e = {($_.CurrentHorizontalResolution.toString()) +" X " + ($_.CurrentVerticalResolution.toString())}} | fl
        Get-WmiObject win32_physicalmemory | Select Manufacture, Description,@{n= "Size(GB)" ; e={$_.Capacity / 1GB -as [int]}}, @{n="Bank";e={$_.BankLabel}} | ft -AutoSize
    }
    if ($Disks) {
        Get-WmiObject win32_physicalmemory | Select Manufacture, Description,@{n= "Size(GB)" ; e={$_.Capacity / 1GB -as [int]}}, @{n="Bank";e={$_.BankLabel}} | ft -AutoSize 
    }
    if ($Network) {
        get-ciminstance win32_networkadapterconfiguration | Where-Object {$_.IPEnabled -eq $True} | Select description, index, ipaddress, ipsubnet, dnsdomain, DnsServerSearchorder| Format-Table -AutoSize
    }

}
