$Return = Invoke-Command localhost -ScriptBlock {ls} -AsJob
# echo $Return
Get-Job
# Get Jobs
$Jobs = Get-Job
do{
    # Running Jobs 
    $RunningJobs = $Jobs | ?{ $_.State -eq "Running"}
    # Completed Jobs
    $CompletedJobs = $Jobs | ?{ $_.State -eq "Completed"}
    # Left-over Jobs
    if( $RunningJobs -ne $null ){
        $Now = Get-Date
        $Message = "未処理ジョブ " + $Now
        echo $Message
        $RunningJobs | Format-Table -Property Id,Name,State,Location -AutoSize | Out-Host
        echo ""
        echo ""
        echo ""
        sleep 10
    }
# $RunningJobs is the variable in Roop so use "do-while", not "while"  
}while ($RunningJobs -ne $null)