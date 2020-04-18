
$list = Get-AzDisk | Where-Object DiskState -eq 'Unattached'
$list | Select-Object ResourceGroupName,
        @{N="DiskName"; E={ $_.Id.Substring($_.Id.LastIndexOf('/')+1) }} , 
        @{N="CreatedDate";E={$_.TimeCreated.ToString("yyy-MM-dd")}}, 
        DiskSizeGB,
        DiskIOPSReadWrite
