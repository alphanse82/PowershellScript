Set-ExecutionPolicy Unrestricted -Force

mkdir C:\\Program Files\\Microsoft\\dotnet

$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\downloadFiles\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
C:\\downloadFiles\\dotnet-install.ps1 -InstallDir "C:\\Program Files\\Microsoft\\dotnet"

Invoke-WebRequest https://azcopyvnext.azureedge.net/release20190517/azcopy_windows_amd64_10.1.2.zip -OutFile C:\\downloadFiles\\azcopyv10.zip
Get-ChildItem C:\\downloadFiles -Filter *.zip | Expand-Archive -DestinationPath C:\\downloadFiles -Force

$sfpath = "https://environmentsetup.blob.core.windows.net/servicefab/ServiceFabric.XCopyPackage.6.6.73-internal.zip?sp=r&st=2020-01-14T21:22:38Z&se=2020-07-01T04:22:38Z&spr=https&sv=2019-02-02&sr=b&sig=de3bkmf8kBr87CJbdlWIL4bhumbu4Y05hrwtTwbGrIk%3D"
C:\\downloadFiles\\azcopy_windows_amd64_10.1.2\\azcopy.exe copy $sfpath C:\\downloadFiles\\sf.zip
Get-ChildItem C:\\downloadFiles -Filter *.zip | Expand-Archive -DestinationPath C:\\downloadFiles -Force

C:\\downloadFiles\\ServiceFabric.XCopyPackage.6.6.73-internal\\lib\\ServiceFabric.XCopyPackage\\InstallFabric.ps1 C:\\downloadFiles\\ServiceFabric.XCopyPackage.6.6.73-internal\\lib\\ServiceFabric.XCopyPackage\\MicrosoftServiceFabric.Internal.6.6.73.0505.cab -AcceptEULA

#$Password = (Get-AzKeyVaultSecret -vaultName "ctimagekey" -name "CloudTestLoginPassword").SecretValue
#New-LocalUser -Name "CloudTest" -Password $Password -FullName " CloudTest" -Description "Account for testing CloudTest"
#net localgroup ServiceFabricAdministrators /add cloudtest

 
