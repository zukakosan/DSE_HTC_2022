$AzureContext = (Connect-AzAccount -Identity).context
# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
$result = Start-AzVM -ResourceGroupName "HITACHI-DEMO-rg" -Name "20220428testvm02"
Write-Output $result