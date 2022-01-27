# 対象ルールのリスト取得
# ex. ResourceGroupName,alertRuleName,AlertType
$rulelist = Get-Content .\alertrulelist.txt

foreach($rule in $rulelist){
    $rgname = $rule.Split(",")[0]
    $alertrulename = $rule.Split(",")[1]
    $alerttype = $rule.Split(",")[2]

    if ($alerttype -eq "Metric"){
        Get-AzMetricAlertRuleV2 -Name $alertrulename -ResourceGroupName $rgname | Add-AzMetricAlertRuleV2
    }elseif($alerttype -eq "Log"){
        Update-AzScheduledQueryRule -Name $alertrulename -ResourceGroupName $rgname -Enabled $true
    }else{
        Write-Host "No Alert Type"
    }
}