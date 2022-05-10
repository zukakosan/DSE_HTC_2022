$vmlist = Get-Content InvokeCommandVmlist.txt
foreach($vm in $vmlist){
    $rgname = $vm.Split(",")[0]
    $vmname = $vm.Split(",")[1]
    Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId "RunPowerShellScript" -ScriptPath "dirscript.ps1" -AsJob
} 
do{
    $Jobs = Get-Job | ?{ $_.Command -eq "Invoke-AzVMRunCommand"}
    $RunningJobs = $Jobs | ?{ $_.State -eq "Running"}
    $CompletedJobs = $Jobs | ?{ $_.State -eq "Completed"}
    
    if( $CompletedJobs -ne $null ){
        foreach( $Job in $CompletedJobs ){
            # 戻り値取得
            $Echos = Receive-Job -Id $Job.Id
            #$Return = $Echos[$Echos.Lenght - 1]
            echo "[INFO] JobID " $job.Id "Completed"
            echo $Echos
            # Job 削除
            Remove-Job -Id $Job.Id
        }
    }
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
}while($RunningJobs -ne $null)

# 異常終了したジョブ
$FailedJobs = Get-Job | ?{ $_.State -eq "Failed"}
if( $FailedJobs -ne $null ){
    # 一覧表示
    echo "Fail Job"
    $FailedJobs | Format-Table -Property Id,Name,State,Location -AutoSize | Out-Host
    echo ""

    # 異常終了した Job を処理
    foreach( $Job in $FailedJobs ){

        # 標準出力と戻り値を echo して Job 削除
        $Failechos = Receive-Job -Id $Job.Id
        echo "[FAIL] JobID " $job.Id "Failed"
        echo $Failechos
        Remove-Job -Id $Job.Id
    }
}

# 切断されたジョブ(ジョブ強制削除)
$DisconnectedJobs = Get-Job | ?{ $_.State -eq "Disconnected"}
if( $DisconnectedJobs -ne $null ){
    # 一覧表示
    echo "Disconnect Job"
    $DisconnectedJobs | Format-Table -Property Id,Name,State,Location -AutoSize | Out-Host
    echo ""

    # Job 強制削除
    foreach( $Job in $DisconnectedJobs ){
        Stop-Job -Id $Job.Id
        Remove-Job -Id $Job.Id
    }
}
