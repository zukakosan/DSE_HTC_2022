# reference
# https://docs.microsoft.com/en-us/powershell/module/az.recoveryservices/get-azrecoveryservicesbackupjob?view=azps-7.1.0#:~:text=The%20Get-AzRecoveryServicesBackupJob%20cmdlet%20gets%20Azure%20Backup%20jobs%20for,the%20vault%20context%20by%20using%20the%20-VaultId%20parameter.

# リソースグループ、リカバリサービスボルト名指定
$rgname = "<YOUR-RESOURCEGROUP-NAME>" 
$rsname = "<YOUR-RECOVERYSERVICE-VAULT-NAME>"
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgname -Name $rsname

$Jobs = Get-AzRecoveryServicesBackupJob -Status InProgress -VaultId $vault.ID
$Jobs
# $Jobs.Count
while ($Jobs.Count -gt 0) {
    $jobs_count = $Jobs.Count
    Write-Host "${jobs_count} jobs are Waiting for completion..."
    Start-Sleep -Seconds 10
    $Jobs = Get-AzRecoveryServicesBackupJob -Status InProgress
    $Jobs
}
Write-Host -Object "Done!"
