# Enable Metric Alert
Get-AzMetricAlertRuleV2 -Name $alertrulename -ResourceGroupName $rgname | Add-AzMetricAlertRuleV2
# Disable Metric Alert 
Get-AzMetricAlertRuleV2 -Name $alertrulename -ResourceGroupName $rgname | Add-AzMetricAlertRuleV2 -DisableRule

# Log Alertの場合ログクエリの中でAggregatedValueカラムを明示的に作成しておかないとBadRequest Error
# Enable Log Alert
Update-AzScheduledQueryRule -Name $alertrulename -ResourceGroupName $rgname -Enabled $true
# Disable Log Alert
Update-AzScheduledQueryRule -Name $alertrulename -ResourceGroupName $rgname -Enabled $false
