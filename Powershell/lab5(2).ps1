    ####################################
#     My system info functions     #
####################################
function system_hardware_info {
    gwmi win32_computersystem | select Name,Manufacturer,Model
}
function operating_system_info {
    gwmi win32_operatingsystem | select Caption,Version
}
function CPU_info {
    gwmi win32_processor | select Name,NumberOfCores,
                                  @{ n = "L1CacheSize" ; e = { if($_.L1CacheSize -ne $null) {
                                                                    $_.L1CacheSize
                                                               } else {
                                                                    "data unavailable"
                                                               }
                                                             }
                                  }, 
                                  @{ n = "L2CacheSize" ; e = { if($_.L2CacheSize -ne $null) {
                                                                    $_.L2CacheSize
                                                               } else {
                                                                    "data unavailable"
                                                               }
                                                             }                              
                                  }, 
                                  @{ n = "L3CacheSize" ; e = { if($_.L3CacheSize -ne $null) {
                                                                    $_.L3CacheSize
                                                               } else {
                                                                    "data unavailable"
                                                               }
                                                             }                              
                                  }
}
function memory_info {
    $RAMs = 0
    gwmi win32_physicalmemory | foreach{
        new-object -typename psobject -property @{  Vendor = $_.Manufacturer;
                                                    "Speed(MHz)" =  if($_.Speed -ne $null) {
                                                                        $_.Speed
                                                                    } else {
                                                                        "data unavailable"
                                                                    };
                                                    "Size(GB)" = $_.Capacity / 1GB -as [int];
                                                    Bank = $_.BankLabel;
                                                    Slot = $_.DeviceLocator                                                    
                                                }
        $RAMs += ($_.Capacity / 1GB -as [int])
    }
    "Total RAM: " + $RAMs.toString() + " GB"
}
function disk_info {
    $diskdrives = Get-CIMInstance CIM_diskdrive
    $diskinfo = foreach ($disk in $diskdrives) { 
        $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition 
        foreach ($partition in $partitions) { 
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk 
            foreach ($logicaldisk in $logicaldisks) { 
                new-object -typename psobject -property @{ Drive=$logicaldisk.deviceid; 
                                                           Vendor=$disk.Manufacturer; 
                                                           Model=$disk.model; 
                                                           “Size(GB)”="{0:N2}" -f ($partition.size / 1gb); 
                                                           "Free Space(GB)"= "{0:N2}" -f (($logicaldisk.freespace) / 1gb)
                                                           "Space Uasge(%)" = "{0:N2}" -f (($logicaldisk.size-$logicaldisk.freespace) * 100 / $logicaldisk.size)
                                                          } 
            } 
        }
    } 
    $diskinfo
}
function video_card {
    gwmi win32_videocontroller | select @{ n = "Vendor"; e={$_.AdapterCompatibility}},
                                        Description,
                                        @{ n = "Current screen resolution"; e = { if ($_.CurrentHorizontalResolution -ne $null -and $_.CurrentVerticalResolution -ne $null) {
                                                                                    ($_.CurrentHorizontalResolution).toString() +" x " + ($_.CurrentVerticalResolution).toString() 
                                                                                  } else {
                                                                                    "data unavailable"
                                                                                  }
                                                                                }
                                        }
}
function Network_info {
    get-ciminstance win32_networkadapterconfiguration |
        Where-Object {$_.IPEnabled -eq $True} |
        select Description,
       	       Index,
               IPAddress,
               IPSubnet,
               DNSDomain,
               @{n="DNSServer";e={$_.DNSServerSearchOrder}} 
}
