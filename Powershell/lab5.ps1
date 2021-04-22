#-System displays the cpu, OS, RAM, Video reports ony
	#-Disks displays the disks report only
	#-Network displays the network report only
	#$args
	param ( [switch]$System, 
	        [switch]$Disks,
	        [switch]$Network
	)
	

	

	

	if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
	    full_report.ps1
	} else {
	    "`nYour System Information Report"
	    if ($System) {
	        "`n`nProcessor:"
	        "==================================="
	        (CPU_info | fl | out-string).trim()
	        "`n`nOperating system:"
	        "==================================="
	        (operating_system_info | fl | out-string).trim()
	        "`n`nMemory:"
	        "==================================="
	        (memory_info | ft -AutoSize | out-string).trim()
	        "`n`nVideo Card:"
	        "==================================="
	        (video_card | fl | out-string).trim()
	    }
	    if ($Disks) {
	        "`n`nDisk:"
	        "==================================="
	        (disk_info | ft -AutoSize Drive,Vendor,Model,“Size(GB)”,"Free Space(GB)","Space Uasge(%)" | out-string).trim()
	    }
	    if ($Network) {
	        "`n`nNetwork Adapter:"
	        "==================================="
	        (Network_info | ft -AutoSize | out-string).trim()
	    }
	}

