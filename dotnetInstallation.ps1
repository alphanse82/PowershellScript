Set-ExecutionPolicy Unrestricted -Force

[System.Environment]::SetEnvironmentVariable('MULTI_LEVEL_LOOKUP', '0')

mkdir C:\\Program Files\\Microsoft\\dotnet
mkdir C:\\downloadFiles

$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\downloadFiles\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
cd C:\\downloadFiles
.\dotnet-install.ps1 -InstallDir "C:\\Program Files\\Microsoft\\dotnet"

Invoke-WebRequest https://azcopyvnext.azureedge.net/release20190517/azcopy_windows_amd64_10.1.2.zip -OutFile C:\\downloadFiles\\azcopyv10.zip
Get-ChildItem C:\\downloadFiles -Filter *.zip | Expand-Archive -DestinationPath C:\\downloadFiles -Force

.\azcopy_windows_amd64_10.1.2\azcopy.exe copy "https://environmentsetup.blob.core.windows.net/servicefab/ServiceFabric.XCopyPackage.6.6.73-internal.zip?sp=r&st=2019-11-26T07:28:25Z&se=2019-12-31T15:28:25Z&spr=https&sv=2019-02-02&sr=b&sig=gVgFM6WRyyQiK1RkKUpog2TptxLE%2B0vp7X1VWLu3XYY%3D" C:\\downloadFiles\\sf.zip
Get-ChildItem C:\\downloadFiles -Filter *.zip | Expand-Archive -DestinationPath C:\\downloadFiles -Force

C:\downloadFiles\ServiceFabric.XCopyPackage.6.6.73-internal\lib\ServiceFabric.XCopyPackage\InstallFabric.ps1 C:\downloadFiles\ServiceFabric.XCopyPackage.6.6.73-internal\lib\ServiceFabric.XCopyPackage\MicrosoftServiceFabric.Internal.6.6.73.0505.cab -AcceptEULA

$Password = ConvertTo-SecureString "Azure@ib@2019!" -AsPlainText -Force
New-LocalUser -Name "CloudTest" -Password $Password -FullName " CloudTest" -Description "Account for testing CloudTest"

net localgroup ServiceFabricAdministrators /add cloudtest

 
