# リソースグループ、リカバリサービスボルト名指定
$rgname = "<YOUR-RESOURCEGROUP-NAME>" 
$rsname = "<YOUR-RECOVERYSERVICE-VAULT-NAME>"
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgname -Name $rsname

$Jobs = Get-AzRecoveryServicesBackupJob -Status InProgress -VaultId $vault.ID
$Jobs

$tscount = $Jobs.Count
while ($tscount -gt 0) {
    Write-Host "${tscount} Jobs are Taking Snapshot..."
    foreach ($Job in $Jobs) {
        $wlname = $Job.WorkloadName
        $SubTasks = Get-AzRecoveryServicesBackupJobDetail -Job $Job -VaultId $Vault.id
        # subtasks[0] = Take Snapshot
        if($SubTasks.subtasks[0].Status -ne "Completed"){
            # $stname = $SubTasks.subtask[0].Name
            Write-Host "${wlname} is Taking Snapshot..."
            $SubTasks.subtasks
        }else{
            $tscount--
        }
    }
    Start-Sleep -Seconds 10
}

Write-Host "(Subtask)Taking Snapshot process is ended"