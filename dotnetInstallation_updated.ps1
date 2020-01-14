Set-ExecutionPolicy Unrestricted -Force

mkdir C:\\Program Files\\Microsoft\\dotnet

$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\downloadFiles\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
C:\\downloadFiles\\dotnet-install.ps1 -InstallDir "C:\\Program Files\\Microsoft\\dotnet"

Invoke-WebRequest https://azcopyvnext.azureedge.net/release20190517/azcopy_windows_amd64_10.1.2.zip -OutFile C:\\downloadFiles\\azcopyv10.zip
Get-ChildItem C:\\downloadFiles -Filter *.zip | Expand-Archive -DestinationPath C:\\downloadFiles -Force



$sfpath = (Get-AzKeyVaultSecret -vaultName "ctimagekey" -name "SEBlob").SecretValueText
.\azcopy_windows_amd64_10.1.2\azcopy.exe copy $sfpath C:\\downloadFiles\\sf.zip
Get-ChildItem C:\\downloadFiles -Filter *.zip | Expand-Archive -DestinationPath C:\\downloadFiles -Force

C:\\downloadFiles\\ServiceFabric.XCopyPackage.6.6.73-internal\\lib\\ServiceFabric.XCopyPackage\\InstallFabric.ps1 C:\\downloadFiles\\ServiceFabric.XCopyPackage.6.6.73-internal\\lib\\ServiceFabric.XCopyPackage\\MicrosoftServiceFabric.Internal.6.6.73.0505.cab -AcceptEULA

$Password = (Get-AzKeyVaultSecret -vaultName "ctimagekey" -name "CloudTestLoginPassword").SecretValue
New-LocalUser -Name "CloudTest" -Password $Password -FullName " CloudTest" -Description "Account for testing CloudTest"

net localgroup ServiceFabricAdministrators /add cloudtest

 
