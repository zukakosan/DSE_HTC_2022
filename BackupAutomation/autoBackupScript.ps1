# reference
# https://docs.microsoft.com/ja-jp/azure/backup/quick-backup-vm-powershell#start-a-backup-job

$rgname = "AAAM-rg" 
$rsname = "AAAM-rsvault"
$vmlist = Get-Content .\vmlist.txt

#Get-AzRecoveryServicesBackupContainer実行前にcontextの設定が必要
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgname -Name $rsname
Set-AzRecoveryServicesAsrVaultContext -Vault $vault

foreach($vmname in $vmlist){
    # バックアップコンテナの指定
    $backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName $vmname

    # バックアップアイテムの指定
    $item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

    # オンデマンドバックアップの開始
    Backup-AzRecoveryServicesBackupItem -Item $item
}
