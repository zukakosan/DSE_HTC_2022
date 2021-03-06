# reference
# https://docs.microsoft.com/ja-jp/azure/backup/quick-backup-vm-powershell#start-a-backup-job

$rgname = "<YOUR-RESOURCEGROUP-NAME>" 
$rsname = "<YOUR-RECOVERYSERVICE-VAULT-NAME>"
$vmlist = Get-Content .\vmlist.txt

# Get-AzRecoveryServicesBackupContainer実行前にcontextの設定が必要
# Set-AzRecoveryServicesAsrVaultContextではなくSet-AzRecoveryServicesVaultContextを使う
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgname -Name $rsname
Set-AzRecoveryServicesVaultContext -Vault $vault

foreach($vm in $vmlist){
    $vmname = $vm.Split(",")[0]
    $retentiondays = 30

    # 本番環境でなければ保持日数を14日にする
    if($vm.Split(",")[1] -ne "prod"){
        $retentiondays = 14
    }
    # バックアップコンテナの指定
    $backupcontainer = Get-AzRecoveryServicesBackupContainer `
    -ContainerType "AzureVM" `
    -FriendlyName $vmname

    # バックアップアイテムの指定
    $item = Get-AzRecoveryServicesBackupItem `
    -Container $backupcontainer `
    -WorkloadType "AzureVM"

    # 保持期間の設定
    $expirydate = (Get-Date).ToUniversalTime().AddDays($retentiondays)

    # $itemに対するバックアップの開始
    Backup-AzRecoveryServicesBackupItem -Item $item -ExpiryDateTimeUTC $expirydate
}

# .\jobStatusCheckScript.ps1