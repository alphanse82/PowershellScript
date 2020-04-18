
function createImageFromVM {
    param (
        [Parameter(Mandatory=$true, Position=0, HelpMessage="Please add subscription positional Parameter.")]
        [guid]      $SubscriptionId,
        [Parameter(Mandatory=$true, Position=1, HelpMessage="Please add resourcegroup positional Parameter.")]
        [string]    $resourceGroup,
        [Parameter(Mandatory=$true, Position=2, HelpMessage="Please add VM name positional Parameter.")]
        [string]    $vmName,
        [string]    $vmImageName
    )
    
    $context = Set-AzContext -SubscriptionId  $SubscriptionId
    $context.Subscription.Name

    $rgName =  $resourceGroup

    if (($null -eq $vmImageName ) -or ( $vmImageName -eq "" )){
        $vmImageName = $vmName + (Get-Date).ToString("MMdd") + (Get-Random -Maximum 999 -Minimum 100)
    }

    $vmdetails = Get-AzVM -ResourceGroupName $rgName -Name $vmName
    
    Stop-AzVM -Name $vmName -ResourceGroupName $rgName

    $diskID = $vmdetails.StorageProfile.OsDisk.ManagedDisk.Id

    $imageConfig = New-AzImageConfig -Location $vmdetails.Location
    $imageConfigUpdate = Set-AzImageOsDisk -Image $imageConfig -OsState Generalized -OsType Windows -ManagedDiskId $diskID -StorageAccountType Premium_LRS
    New-AzImage -Image $imageConfigUpdate -ImageName $vmImageName -ResourceGroupName $rgName

}

