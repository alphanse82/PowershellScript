
##
# Declaration 
##
$sessionIdForParallelExecution = "7332bf6c-3974-b9fa-59a8-ed5b9954de09"
$sessionIdForBaseExecution = "ad5cf73f-38f2-a9ed-ab5d-bece8d62d576"
$ResultFilter = "All" # All Passed Failed
$ResultPath = "P:\POC\result"


#####################################################################################################
# script code


function fetchCloutTestResult
{
    param (
        [string] $sessionId
    )
    
    $debug = $false

    $baseUrl = "https://cloudtest/api/tenants/CosmosDB3/sessions"

    $sessionUrl = "$baseUrl/{0}/jobs".Replace("{0}", $sessionId)
    $testJobDetailsURL = "$baseUrl/{0}/jobs/{1}/executions/{2}/cases"
    

    if($debug -eq $true) {
        Write-Host  "CloudBuild Session URL ->  $sessionUrl"
    }

    $response = Invoke-WebRequest -Uri $sessionUrl
    $jsonTestJobs = ConvertFrom-Json $([String]::new($response.Content))

    if($debug -eq $true) {
        Write-Host "Total Job Counts areee $($jsonTestJobs.Count)"
        $jsonTestJobs | ConvertTo-Json | Out-File "P:\POC\result\$sessionId-1.log" -Force
    }

    $testCaseExecutionLog = @();

    Write-Host " Counts areeee $($jsonTestJobs.Count)"
    foreach ($jasonTestJob in $jsonTestJobs) 
    {
        $newUrl = $testJobDetailsURL.Replace("{0}","$sessionId").Replace("{1}","$($jasonTestJob.JobId)").Replace("{2}","$($jasonTestJob.ExecutionId)");
        
        Write-Host $newUrl

        $responseForTestJob = Invoke-WebRequest -Uri $newUrl
        $jsonTestJob = ConvertFrom-Json $([String]::new($responseForTestJob.Content))
        
        if($debug -eq $true) {
            Write-Host "TestJob -> $($jasonTestJob.ExecutionId) -> $($jasonTestJob.JobId) -> $($jasonTestJob.ExecutionDurationInMS)"
            Write-Host "Total Job Counts are $($jsonTestJob.Count)"
        }

        $tcresult = New-Object -TypeName PSObject -Property ([Ordered]@{
            TestJobName   = $($jasonTestJob.JobName);
            TestJobResult = "$($jasonTestJob.Result)";  
            TestJobDuration = [System.Math]::Round(( $jasonTestJob.SetupDurationInMS + $jasonTestJob.ExecutionDurationInMS ) / 60000, 2) ;
            # SetupDurationInMS = $jasonTestJob.SetupDurationInMS;
            # ExecutionDurationInMS = $jasonTestJob.ExecutionDurationInMS;
            NumOfPassedTestCases = $jasonTestJob.NumOfPassedTestCases;
            NumOfFailedTestCases = $jasonTestJob.NumOfFailedTestCases;
            })

        $testCaseExecutionLog += $tcresult

    }

    return $testCaseExecutionLog;
}

$testCaseExecutionLogModified = fetchCloutTestResult $sessionIdForParallelExecution 
$testCaseExecutionLogModified | ConvertTo-Json | Out-File ( Join-Path $ResultPath "Modified.log") -Force
$testCaseExecutionLogModified | Export-Csv -Path ( Join-Path $ResultPath "Modified.csv") -NoTypeInformation


$testCaseExecutionLogBase = fetchCloutTestResult $sessionIdForBaseExecution 
$testCaseExecutionLogBase | ConvertTo-Json | Out-File ( Join-Path $ResultPath "Base.log") -Force
$testCaseExecutionLogBase | Export-Csv -Path ( Join-Path $ResultPath "Base.csv") -NoTypeInformation


# return 
# $testCaseExecutionLogBase =  Get-Content -Raw -Path ( Join-Path $ResultPath "Base.log") | ConvertFrom-Json
# $testCaseExecutionLogModified =  Get-Content -Raw -Path ( Join-Path $ResultPath "Modified.log" ) | ConvertFrom-Json

$testCasesexeSummaryClasswise = @();

$uniqueTestJob =  $testCaseExecutionLogModified | Sort-Object  -Property  TestJobName

if( $ResultFilter -ne "All" ) {
    $uniqueTestJob =  $testCaseExecutionLogModified | Where-Object TestJobResult -eq $ResultFilter | Sort-Object  -Property  TestJobName
}

foreach($testjob in $uniqueTestJob) {

    $BaseResult = $testCaseExecutionLogBase | Where-Object TestJobName -eq $testjob.TestJobName

    $testCasesescw = New-Object -TypeName PSObject -Property ([Ordered]@{
        "TestJobName"   = $($testJob.TestJobName);
        "TestJobResult" = "$($testJob.TestJobResult)";
        "BeforeModification(s)"   = $($BaseResult.TestJobDuration);
        "AfterBeModification(s)" = "$($testJob.TestJobDuration)";        
        "% change" =  [System.Math]::Round(100 *( $($BaseResult.TestJobDuration) - $($testJob.TestJobDuration)) / $($BaseResult.TestJobDuration),2);  
        })

        if( $ResultFilter -ne "Passed" ) {
            $testCasesescw = $testCasesescw | Select-Object *,@{label="NumOfPassedTestCases"; Expression= {$testJob.NumOfPassedTestCases}},@{label="NumOfFailedTestCases"; Expression= {$testJob.NumOfFailedTestCases}}
        }

    $testCasesexeSummaryClasswise += $testCasesescw
}


$testCasesexeSummaryClasswise | ConvertTo-Json | Out-File "P:\POC\result\Compare.log" -Force
$testCasesexeSummaryClasswise | Export-Csv -Path "P:\POC\result\Compare.csv" -NoTypeInformation















