get-ciminstance win32_networkadapterconfiguration |
Where-Object IPEnabled -eq $True |
Select-Object Description, Index, IPAddress,
@{n="Subnet Mask";e={$_.IPSubnet}},
@{n="DNS Domain Name";e={$_.DNSHostName}},
@{n="DNS Server";e={$_.DNSServerSearchOrder}} |
Format-Table
