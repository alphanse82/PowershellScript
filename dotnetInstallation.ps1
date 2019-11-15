mkdir C:\\1115
$sourceNugetExe = "https://dotnetwebsite.azurewebsites.net/download/dotnet-core/scripts/v1/dotnet-install.ps1"
$targetNugetExe = "C:\\1115\\dotnet-install.ps1"
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe > C:\\1115\\log.txt
C:\\1115\\dotnet-install.ps1 > C:\\1115\\log1.txt
