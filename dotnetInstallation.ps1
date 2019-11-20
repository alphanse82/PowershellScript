Set-ExecutionPolicy Unrestricted -Force

[System.Environment]::SetEnvironmentVariable('MULTI_LEVEL_LOOKUP', '0')

mkdir C:\\downloadFiles
$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\downloadFiles\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
cd C:\\downloadFiles
.\dotnet-install.ps1
