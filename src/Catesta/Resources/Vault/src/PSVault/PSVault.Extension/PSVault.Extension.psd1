@{
    ModuleVersion     = '<%=$PLASTER_PARAM_Version%>'
    RootModule        = '<%=$PLASTER_PARAM_ModuleName%>.Extension.psm1'
    FunctionsToExport = @('Set-Secret', 'Get-Secret', 'Remove-Secret', 'Get-SecretInfo', 'Test-SecretVault')
}
