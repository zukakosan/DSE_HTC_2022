# リソースグループ、リカバリサービスボルト名指定
$rgname = "AAAM-rg" 
$rsname = "AAAM-rsvault"
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
