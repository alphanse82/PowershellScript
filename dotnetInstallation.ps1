Set-ExecutionPolicy Unrestricted -Force

[System.Environment]::SetEnvironmentVariable('MULTI_LEVEL_LOOKUP', '0')

mkdir C:\\Program Files\\Microsoft\\dotnet
mkdir C:\\downloadFiles

$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\downloadFiles\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
cd C:\\downloadFiles
.\dotnet-install.ps1 -InstallDir "C:\\Program Files\\Microsoft\\dotnet"

Invoke-WebRequest https://azcopyvnext.azureedge.net/release20190517/azcopy_windows_amd64_10.1.2.zip -OutFile C:\\downloadFiles\azcopyv10.zip
Get-ChildItem C:\downloadFiles\ -Filter *.zip | Expand-Archive -DestinationPath C:\downloadFiles\ -Force

.\azcopy_windows_amd64_10.1.2\azcopy.exe copy "https://environmentsetup.blob.core.windows.net/servicefab/ServiceFabric.XCopyPackage.6.6.73-internal.zip?sp=r&st=2019-11-25T21:09:01Z&se=2019-11-26T05:09:01Z&spr=https&sv=2019-02-02&sr=b&sig=5gik3Zt2bLjkCvz0M1tHDqRRDveCAWhmw2XshQKTRok%3D" C:\downloadFiles\sf.zip
Get-ChildItem C:\downloadFiles\ -Filter *.zip | Expand-Archive -DestinationPath C:\downloadFiles\ -Force

C:\downloadFiles\ServiceFabric.XCopyPackage.6.6.73-internal\lib\ServiceFabric.XCopyPackage\InstallFabric.ps1 C:\downloadFiles\ServiceFabric.XCopyPackage.6.6.73-internal\lib\ServiceFabric.XCopyPackage\MicrosoftServiceFabric.Internal.6.6.73.0505.cab -AcceptEULA

net localgroup ServiceFabricAdministrators /add cloudtest

 
