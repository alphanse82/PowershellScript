mkdir C:\\downloadFiles
$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\downloadFiles\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe > C:\\downloadFiles\\log.txt
C:\\downloadFiles\\dotnet-install.ps1 > C:\\downloadFiles\\log1.txt
