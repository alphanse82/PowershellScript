Set-ExecutionPolicy Unrestricted -Force

mkdir C:\\Program Files\\Microsoft\\dotnet

$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\downloadFiles\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
C:\\downloadFiles\\dotnet-install.ps1 -InstallDir "C:\\Program Files\\Microsoft\\dotnet"

 
