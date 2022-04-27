$vmlist = Get-Content .\vmlist.json | ConvertFrom-Json
# VMの一括開始
foreach($vm in $vmlist){
    $rgname = $vm.rgname
    $vmname = $vm.vmname
    
    Write-Host "${vmname} is provisioning"
    Start-AzVM -ResourceGroupName $rgname -Name $vmname
}

