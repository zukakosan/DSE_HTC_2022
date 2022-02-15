$vmlist = Get-Content .\vmlist.txt

# VMの一括停止
foreach($vm in $vmlist){
    $rgname = $vm.Split(",")[0]
    $vmname = $vm.Split(",")[1]
    
    Write-Host "${vmname} is shutting down"
    # ユーザ確認待ちをしないための-Force
    # 非同期で停止ジョブを開始させたい場合は-NoWait
    Stop-AzVM -ResourceGroupName $rgname -Name $vmname -Force
}

