$Return = Invoke-Command -ComputerName "localhost","10.21.0.6" -ScriptBlock {dir c:\; Start-Sleep 10} -AsJob
# $Return = Invoke-Command -ComputerName "localhost" -ScriptBlock {dir c:\} -AsJob

# echo $Return
Get-Job
# Get Jobs
# $Jobs = Get-Job
# Use "-IncludeChildJob" option if you want
# $Jobs = Get-Job -IncludeChildJob
do{
    $Jobs = Get-Job -IncludeChildJob
    # Running Jobs 
    $RunningJobs = $Jobs | ?{ $_.State -eq "Running"}
    # Completed Jobs
    $CompletedJobs = $Jobs | ?{ $_.State -eq "Completed"}
    # Left-over Jobs
    if( $RunningJobs -ne $null ){
        $Now = Get-Date
        $Message = "Jobs bellow are running now: " + $Now
        echo $Message
        $RunningJobs | Format-Table -Property Id,Name,State,Location -AutoSize | Out-Host
        echo ""
        echo ""
        echo ""
        sleep 10
    }
# $RunningJobs is the variable in Roop so use "do-while", not "while"  
}while ($RunningJobs -ne $null)
$Return.Childjobs | % {
    write-host $_.location
    $_.output
    }