$vmlist = Get-Content .\vmlist.txt

# VMの一括開始
foreach($vm in $vmlist){
    $rgname = $vm.Split(",")[0]
    $vmname = $vm.Split(",")[1]
    
    Write-Host "${vmname} is provisioning"
    Start-AzVM -ResourceGroupName $rgname -Name $vmname
}

