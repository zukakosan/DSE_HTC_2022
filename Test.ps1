Write-OutPut "test forever"
Set-AzVMExtension -ExtensionName "CustomScript" `
    -ResourceGroupName $rg_vm `
    -VMName $hostname `
    -Publisher "Microsoft.Azure.Extensions" `
    -ExtensionType "CustomScript" `
    -TypeHandlerVersion 2.0 `
    -ProtectedSettings $Protectedsettings `
    -Location $Location