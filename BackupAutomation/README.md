# 使い方
- vmlist.txtにvm名,環境名(`prod`かそれ以外か)を記入
    - 例：
    vm01,prod
    vm02,dev
    vm03,staging
- autoBackupScript.ps1内にリソースグループ名とリカバリサービスボルト名を記入
- jobStatusCheckScript.ps1内にリソースグループ名とリカバリサービスボルト名を記入
- powerShellにてautoBackupScript.ps1を実行したのちjobStatusCheckScript.ps1を実行する

# 注意点
- 下記コマンドがAzure Cloud Shellだと効かない可能性あり

```powerShell
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $rgname -Name $rsname
Set-AzRecoveryServicesAsrVaultContext -Vault $vault
```
- jobStatusCheckScript.ps1をautoBackupScript.ps1の中から呼び出すとジョブのリストが上手くアウトプットされない
- jobStatusCheckScript.ps1内でのリソースグループ名とリカバリサービスボルト名の設定が不要の可能性
    - autoBackupScript.ps1内でコンテクストをセットしているため
