# 注ondemandBackupで関数化仕様と思ったが、$vmnameがなぜか 'System.Object[]'認定されてしまいエラー
# 関数化していなければ通る＋直前のWrite-Host $vmname.GetType()でSystem.String()が出るので本当に謎

# reference
# https://docs.microsoft.com/ja-jp/azure/backup/quick-backup-vm-powershell#start-a-backup-job


# 関数定義
function ondemandBackup {
    param (
        $vmname,
        $retentiondays
    )
    # バックアップコンテナの指定
    $backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName $vmname

    # $backupcontainerのバックアップアイテムの指定
    $item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

    # 保持期間の設定
    $expirydate = (Get-Date).ToUniversalTime().AddDays($retentiondays)

    # $itemに対するバックアップの開始
    Backup-AzRecoveryServicesBackupItem -Item $item -ExpiryDateTimeUTC $expirydate
}

# RecoveryServiceVaultのリソースグループとリソース名を指定
$rgname = "AAAM-rg" 
$rsname = "AAAM-rsvault"

# Get-AzRecoveryServicesBackupContainer実行前にcontextの設定が必要
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgname -Name $rsname
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

# 対象VMリストの取得
$vmlist = Get-Content .\vmlist.txt
# 出力
Write-Host $vmlist

foreach ($vm in $vmlist) {
    Write-Host $vm
    $vmname = $vm.Split(",")[0]
    Write-Host $vmname.GetType()
    $retentiondays = 30
    # 本番環境でなければ保持日数を14日にする
    if($vm.Split(",")[1] -ne "prod"){
        $retentiondays = 14
    }
    Write-Host $vmname.GetType()
    # バックアップの実行
    ondemandBackup($vmname, $retentiondays)
}

# バックアップ状況の監視
# Get-AzRecoveryservicesBackupJob

