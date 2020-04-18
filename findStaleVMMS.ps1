function GetVMSSDetailsForResourceGroup {
    param (
    [string] $subscriptionId, 
    [string] $resourceGroupName,
    [string] $currentVersion
    )

    $instanceIds = @()
    $instanceIds =  Get-AzVmss -ResourceGroupName $resourceGroupName | Select-Object Name

    $VMInstance = @()
    foreach ( $instance in  $instanceIds) { 
        $detail = Get-AzVmss -ResourceGroupName $resourceGroupName -VMScaleSetName $instance.Name | Select-Object @{Label = "ImageVersion"; Expression = {$_.VirtualMachineProfile.StorageProfile.ImageReference.Id}}, @{Label = "Capacity"; Expression = {$_.Sku.Capacity}}
        $detail = New-Object -TypeName PSObject -Property ([Ordered]@{
            "SubscriptionId"  = $subscriptionId;
            "VMSSName"  = $instance.Name;
             "Capacity" = $detail.Capacity;
            "IsCurrent"  = IsCurrent -imageVersion $detail.ImageVersion -version $currentVersion;
            "IsPrevious" = IsCurrent -imageVersion $detail.ImageVersion -version '0.0303.2020';
            })
        $VMInstance += $detail
    }
    return $VMInstance
}

function IsCurrent {
    param (
        [string] $imageVersion,
        [string] $version
    )
    return  ValidateVersion  -imageVersion $imageVersion -version $version
}

function IsPrevious {
    param (
        [string] $imageVersion,
        [string] $version
    )
    return  ValidateVersion  -imageVersion $imageVersion -version $version
}

function ValidateVersion {
    param (
        [string] $imageVersion,
        [string] $version
    )

    $isMatching = "false"
    if( $ImageVersion.IndexOf($version) -gt 0) {
        $isMatching = "true"
    }
    return $isMatching;
}

function GetDomainList {
    $subscriptionList = @();
    $subscriptionList += [System.Tuple]::Create('susbscription Id', 'your resource group')  
    return $subscriptionList
}

$subscriptionList = GetDomainList
$list = @()
foreach( $temp in $subscriptionList ) {
    Set-AzContext -SubscriptionId $temp[0]
    $list += GetVMSSDetailsForResourceGroup -ResourceGroupName $temp[1] -subscriptionId  $temp[0] -currentVersion '0.0414.2020'
}

#$list | ConvertTo-Json | Out-File "P:\POC\result\StaleVMMS.json" -Force
$list | Export-Csv -Path "P:\POC\result\StaleVMMS.csv" -Force
