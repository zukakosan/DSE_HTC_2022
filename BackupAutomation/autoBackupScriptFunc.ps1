# reference
# https://docs.microsoft.com/ja-jp/azure/backup/quick-backup-vm-powershell#start-a-backup-job

# 関数定義
function ondemandBackup {
    param (
        $vmname
    )
    # バックアップコンテナの指定
    $backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName $vmname

    # $backupcontainerのバックアップアイテムの指定
    $item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

    # $itemに対するバックアップの開始
    Backup-AzRecoveryServicesBackupItem -Item $item
}

# RecoveryServiceVaultのリソースグループとリソース名を指定
$rgname = "AAAM-rg" 
$rsname = "AAAM-rsvault"

#Get-AzRecoveryServicesBackupContainer実行前にcontextの設定が必要
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgname -Name $rsname
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

$vmlist = Get-Content .\vmlist.txt
Write-Host $vmlist
foreach ($vmname in $vmlist) {
    ondemandBackup($vmname)
}

# バックアップ状況の監視
# Get-AzRecoveryservicesBackupJob

