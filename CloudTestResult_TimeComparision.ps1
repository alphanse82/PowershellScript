
##
# Declaration 
##

$sessionIdForParallelExecutions = "6454164_a3923f95-3d6d-016e-d8eb-12df9cd4b82e","6508005_7332bf6c-3974-b9fa-59a8-ed5b9954de09","6559829_4e8d80c9-9993-5afa-1ad4-afee7a7b89f2", "6584338_d342c8f8-f467-9c2f-2591-ab9080a7a64f"
$sessionIdForBaseExecution = "6580786_7f014bd9-1df7-7bea-e26e-185e44b72865"
$ResultPath = "P:\POC\result"


#####################################################################################################
# script code

function fetchCloutTestResult
{
    param (
        [Parameter(Mandatory=$true)]
        [string] $sessionId,
        [bool] $debugFlag = 0,
        [string] $tenant = "CosmosDB3"
    )
    
    $baseUrl = "https://cloudtest/api/tenants/{0}/sessions".Replace("{0}",$tenant)

    $sessionUrl = "$baseUrl/{0}/jobs".Replace("{0}", $sessionId)
    
    if($debugFlag -eq $true) {
        Write-Host  "CloudTest Session URL ->  $sessionUrl"
    }

    $response = Invoke-WebRequest -Uri $sessionUrl
    $jsonTestJobs = ConvertFrom-Json $([String]::new($response.Content))

    if($debugFlag -eq $true) {
        Write-Host "Job Counts are $($jsonTestJobs.Count)"
    }

    $testCaseExecutionLog = @();

    Write-Host "Counts are $($jsonTestJobs.Count)"

    foreach ($jasonTestJob in $jsonTestJobs) 
    {

        if($debug -eq $true) {
            Write-Host ""
            Write-Host "TestJob -> $($jasonTestJob.ExecutionId) -> $($jasonTestJob.JobId) -> $($jasonTestJob.ExecutionDurationInMS)"
            Write-Host "Total Job Counts are $($jsonTestJob.Count)"
            Write-Host ""
        }

        $tcresult = New-Object -TypeName PSObject -Property ([Ordered]@{
            TestJobName   = $($jasonTestJob.JobName);
            TestJobResult = "$($jasonTestJob.Result)";  
            TestJobDuration = [System.Math]::Round(( $jasonTestJob.SetupDurationInMS + $jasonTestJob.ExecutionDurationInMS ) / 60000, 2) ;
            NumOfPassedTestCases = $jasonTestJob.NumOfPassedTestCases;
            NumOfFailedTestCases = $jasonTestJob.NumOfFailedTestCases;
            })

        $testCaseExecutionLog += $tcresult

    }

    return $testCaseExecutionLog;
}


$testCaseExecutionLogBase = fetchCloutTestResult -sessionId ($sessionIdForBaseExecution -split "_")[1] -debug 0 -tenant "CosmosDB3"
$testCaseExecutionLogBase | ConvertTo-Json | Out-File ( Join-Path $ResultPath "Base.log") -Force

$testCaseExecutionLogBase =  $testCaseExecutionLogBase | Sort-Object  -Property  TestJobName | Select-Object @{label="TestJobName"; Expression= {$_.TestJobName}} , @{label="BaseDuration"; Expression= {$_.TestJobDuration}}

$testCasesExecutionResults = $testCaseExecutionLogBase;

foreach($parallelExecutionSessionId in $sessionIdForParallelExecutions) {

    $sessionId = ($parallelExecutionSessionId -split "_")[1];
    $devOpsBuild = ($parallelExecutionSessionId -split "_")[0];
    $testCaseExecutionLogModified = fetchCloutTestResult -sessionId $sessionId -debug 0 -tenant "CosmosDB3"
    $testCaseExecutionLogModified | ConvertTo-Json | Out-File ( Join-Path $ResultPath "$($devOpsBuild)_Modified.log") -Force
    
    $testCasesexeSummaryClasswise = @();

    foreach($testjob in $testCasesExecutionResults) {

        $BasecaseResult = $testCasesExecutionResults | Where-Object TestJobName -eq $testjob.TestJobName
        $ModifiedCaseResult = $testCaseExecutionLogModified | Where-Object TestJobName -eq $testjob.TestJobName  
        $improvement =  [System.Math]::Round(100 *( $($BasecaseResult.BaseDuration) - $($ModifiedCaseResult.TestJobDuration)) / $($BasecaseResult.BaseDuration),2)   
        $testCasesescw = $BasecaseResult | Select-Object *,@{label="$($devOpsBuild)_Result"; Expression= {$ModifiedCaseResult.TestJobResult}},@{label="$($devOpsBuild)_Duration"; Expression= {$ModifiedCaseResult.TestJobDuration}},@{label="$($devOpsBuild)_%Improvement"; Expression= {$improvement}}    
    
        $testCasesexeSummaryClasswise += $testCasesescw
    }

    $testCasesExecutionResults = $testCasesexeSummaryClasswise;
}

$testCasesExecutionResults | ConvertTo-Json | Out-File ( Join-Path $ResultPath "Staging.log") -Force
$Staging  =  Get-Content -Raw -Path ( Join-Path $ResultPath "Staging.log") | ConvertFrom-Json
$fileName = (Get-Date -format s).Replace("-","").Replace(":","")
$fileName = Join-Path $ResultPath "FinalComparision_$($fileName).csv"
$Staging | Export-Csv $fileName -NoTypeInformation -Force

Start-Process Excel -FilePath $fileName
