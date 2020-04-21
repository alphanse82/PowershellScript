# To Cleanup Unattached disk 
function CleanupUnAttachedDisk 
{
    $UnattachedDisk = Get-AzDisk | Where-Object DiskState -eq 'Unattached'
    
    foreach($disk in $UnattachedDisk) 
    {     
        Remove-AzDisk -ResourceGroupName $disk.ResourceGroupName -DiskName $disk.Name -Force;
     
    }    
}
