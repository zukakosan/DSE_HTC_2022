# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context
# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

# 変数
$rgName = "HITACHI-DEMO-rg"
$runbookName = "child-vmstart-com"
$runbookName2 = "child-vmstart-com2"
$autoAccName = "htc-auto-acc"

# 引数を渡したい場合は別途構成する
# $params = @{"xxxx"="yyyy";"aaaa"="bbbb"}
# execute child runbook

# 子Runbookのジョブ管理用配列
$childJobList = @()
# 以下直書きではなくRunbookの変数等を使ってForeachでStartさせる
# Runbookの並列実行(-Waitオプションなし)
$childJob = Start-AzAutomationRunbook -AutomationAccountName $autoAccName -Name $runbookName -ResourceGroupName $rgName -DefaultProfile $AzureContext # -Wait
$childJobList += $childJob
$childJob = Start-AzAutomationRunbook -AutomationAccountName $autoAccName -Name $runbookName2 -ResourceGroupName $rgName -DefaultProfile $AzureContext # -Wait
$childJobList += $childJob
# 確認用出力
Write-Output $childJobList

# 実行中ジョブの状況確認
do{
	$compCount = 0
	Write-Output "Checking Job Status..."
	foreach($cj in $childJobList){
		$Job = Get-AzAutomationJob -Id $cj.JobId -AutomationAccountName $autoAccName -ResourceGroupName $rgName
		$Job.Status
		if($Job.Status -eq "Completed"){
			$compCount += 1
		}
	}
	Write-Output $compCount
	sleep 5
}while($compCount -ne $childJobList.Count)

# ジョブ出力確認
$childJobOutputList = @()
foreach($cj in $childJobList){
	$cj_output = Get-AzAutomationJobOutput -AutomationAccountName $autoAccName -Id $cj.JobId -ResourceGroupName $rgName
	$childJobOutputList += $cj_output
}
Write-Output $childJobOutputList