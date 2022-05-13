$vmlist = Get-Content InvokeCommandVmlist.txt
foreach($vm in $vmlist){
    $rgname = $vm.Split(",")[0]
    $vmname = $vm.Split(",")[1]
    Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId "RunPowerShellScript" -ScriptPath "dirscript.ps1" -AsJob
} 
# 実行中のジョブが残っている間は繰り返し実行
# RunningJobsはループ内で定義しているためdo-whileで対応
do{
    # Invoke-AzVMRunCommand(実行コマンド)に関するジョブのみを取得する
    $Jobs = Get-Job | ?{ $_.Command -eq "Invoke-AzVMRunCommand"}
    # 終了したジョブを取得
    $CompletedJobs = $Jobs | ?{ $_.State -eq "Completed"}
    # 実行中のジョブを取得
    $RunningJobs = $Jobs | ?{ $_.State -eq "Running"}

    # 終了したジョブについては戻り値を確認し、ジョブを削除する
    if( $CompletedJobs -ne $null ){
        foreach( $Job in $CompletedJobs ){
            # 戻り値取得
            $Echos = Receive-Job -Id $Job.Id
            #$Return = $Echos[$Echos.Lenght - 1]
            Write-Output "[INFO] JobID " $job.Id "Completed"
            # 戻り値の表示
            Write-Output $Echos
            # 終了したジョブに対するGet-Jobの回避として終了したジョブを削除する
            Remove-Job -Id $Job.Id
        }
    }
    
    # 実行中のジョブはテーブルで表示
    if( $RunningJobs -ne $null ){
        $Now = Get-Date
        $Message = "Jobs bellow are running now: " + $Now
        Write-Output $Message
        $RunningJobs | Format-Table -Property Id,Name,State,Location -AutoSize | Out-Host
        Write-Output ""
        Write-Output ""
        Write-Output ""
        Start-Sleep 10
    }
}while($RunningJobs -ne $null)

# 異常終了したジョブ
$FailedJobs = Get-Job | ?{ $_.State -eq "Failed"}
if( $FailedJobs -ne $null ){
    # 一覧表示
    Write-Output "Fail Job"
    $FailedJobs | Format-Table -Property Id,Name,State,Location -AutoSize | Out-Host
    Write-Output ""

    # 異常終了した Job を処理
    foreach( $Job in $FailedJobs ){

        # 標準出力と戻り値を echo して Job 削除
        $Failechos = Receive-Job -Id $Job.Id
        Write-Output "[FAIL] JobID " $job.Id "Failed"
        Write-Output $Failechos
        Remove-Job -Id $Job.Id
    }
}

# 切断されたジョブ(ジョブ強制削除)
$DisconnectedJobs = Get-Job | ?{ $_.State -eq "Disconnected"}
if( $DisconnectedJobs -ne $null ){
    # 一覧表示
    Write-Output "Disconnect Job"
    $DisconnectedJobs | Format-Table -Property Id,Name,State,Location -AutoSize | Out-Host
    Write-Output ""

    # Job 強制削除
    foreach( $Job in $DisconnectedJobs ){
        Stop-Job -Id $Job.Id
        Remove-Job -Id $Job.Id
    }
}
