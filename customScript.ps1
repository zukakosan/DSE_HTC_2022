# リソースグループ、ロケーション指定
$Location = "westus2"

# 実行コマンド
$Protectedsettings=@{"commandToExecute" = 'sudo sh /opt/microsoft/omsagent/bin/omsadmin.sh -p http://10.20.0.110:8080'}

# 対象 VM のリスト読み込み
$hostlist = get-content .\hostlist.txt

# 拡張エージェント削除
foreach($hostinfo in $hostlist){
    $hostname = $hostinfo.split(",")[0]
    $rg_vm = $hostinfo.split(",")[1]
    write-host "Remove $hostname's Extention. ($rg_vm)"
    Remove-AzVMExtension -ResourceGroupName $rg_vm -Name "CustomScript" -VMName $hostname -Force
}


# 拡張エージェント再インストール
foreach($hostinfo in $hostlist){
    $hostname = $hostinfo.split(",")[0]
    $rg_vm = $hostinfo.split(",")[1]
    write-host "Install $hostname's Extention. ($rg_vm)"
    Set-AzVMExtension -ExtensionName "CustomScript" `
                  -ResourceGroupName $rg_vm `
                  -VMName $hostname `
                  -Publisher "Microsoft.Azure.Extensions" `
                  -ExtensionType "CustomScript" `
                  -TypeHandlerVersion 2.0 `
                  -ProtectedSettings $Protectedsettings `
                  -Location $Location
}