   function welcome {
write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It's $now."
}


function get-cpuinfo {
get-ciminstance cim_processor | 
select Name, MaxClockSpeed, CurrentClockSpeed, NumberOfCores, Manufacturer
}


function get-mydisks {

(new-object -typename psobject -property @{
 Model=(get-disk).Model;
 Manufacturer=(get-disk).Manufacturer;
 SerialNumber=(get-disk).SerialNumber;
 FirmwareVersion=(get-disk).FirmwareVersion;
 Size=(get-disk).Size;

 }) | ft

}

function get-sysInfo {

"**System Information**"



    Get-WmiObject win32_computersystem

}

function get-osInfo {

"**OS Information**
"

    Get-WmiObject -Class win32_operatingsystem |
        foreach {
            New-Object -TypeName psobject -Property @{
                OSName = $_.Name
                Version = $_.Version
                }
        } 
        ft -AutoSize OsName,
                     Version

}

function get-proInfo {

"**Processor Information ** 
"



    Get-WmiObject -Class win32_processor |
        foreach {
            New-Object -TypeName psobject -Property @{
                Speed = $_.MaxClockSpeed
                NumberOfCores = $_.NumberOfCores
                L1CacheSize = "data unavailable"
                L2CacheSize = "data unavailable"
                L3CacheSize = $_.L3CacheSize
                }
        } 
        ft -AutoSize Speed,
                     NumberOfCores,
                     L1CacheSize,
                     L2CacheSize,
                     L3CacheSize

                     "
                     "

}

function get-ramInfo {

"**RAM information**"


    $totalCapacity = 0

    Get-WmiObject -Class win32_physicalmemory |
        foreach {
            New-Object -TypeName psobject -Property @{
                Vendor = $_.Manufacturer
                Model = "data unavailable"
                "Size(MB)" = $_.capacity/1mb
                Bank = $_.banklabel
                Slot = $_.devicelocator
                }
            $totalCapacity += $_.capacity/1mb
        } |
            ft -auto Vendor,
                      Model,
                     "Size(MB)",
                      Bank,
                      Slot

      "Total RAM: ${totalCapacity}MB
      
      "

}

function get-diskInfo {

"**Disk Information**
"



        $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Vendor=$disk.Manufacturer
                                                               Model=$disk.Model
                                                               "SizeFree(GB)"=$logicaldisks.FreeSpace / 1gb -as [int]
                                                               "SpaceFree(%)"=($logicaldisk.FreeSpace/$logicaldisk.size)*100 -as [int]
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               } | ft
           }
      }
  }

}


function get-adaptInfo {

  "**Network Adapters** "



  get-ciminstance win32_networkadapterconfiguration |
     Where-Object ipenabled -eq True |
     Select-Object Discription, index, IPAddress, subnetmask, dnsdomain, dnsserver
        ft

}

function get-videoInfo {

"**Video Card Information**
"



    Get-WmiObject -Class win32_videocontroller |
        foreach {
            New-Object -TypeName psobject -Property @{
                Vendor = $_.Name
                Description = $_.Description
                CurrentScreenResolution = ($_.CurrentHorizontalResolution) * ($_.CurrentVerticalResolution)
                
                }
        } 

}
