Write-Host "another file"
$Jobs = Get-AzRecoveryServicesBackupJob -Status InProgress
while ($Jobs.Count > 0) {
    Write-Host -Object "Waiting for completion..."
    Start-Sleep -Seconds 10
    $Jobs = Get-AzRecoveryServicesBackupJob -Status InProgress
    Write-Host $Jobs
}
Write-Host -Object "Done!"
