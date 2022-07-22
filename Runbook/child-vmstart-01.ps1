$AzureContext = (Connect-AzAccount -Identity).context
# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContex
$result = Start-AzVM -ResourceGroupName "HITACHI-DEMO-rg" -Name "20220428testvm"
# カスタムオブジェクトを返したい場合
$myObject = [PSCustomObject]@{
    # パラメータを渡している場合はそこから必要な値を抽出
    # Name = $VM.Name
    Name = "20220428testvm"
    Status = $result.Status
}
Write-Output $myObject