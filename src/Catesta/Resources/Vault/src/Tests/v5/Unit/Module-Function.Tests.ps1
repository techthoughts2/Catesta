BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
    $vaultName = '<%=$PLASTER_PARAM_ModuleName%>'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

Describe '<%=$PLASTER_PARAM_ModuleName%> Vault Extension Tests' -Tag Unit {
    BeforeAll {
        $WarningPreference = "SilentlyContinue"
        $vaultName = 'AWSVault'
        $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
        Import-Module -Name Microsoft.PowerShell.SecretManagement
        Get-SecretVault $vaultName -ErrorAction Ignore | Unregister-SecretVault -ErrorAction Ignore
        Register-SecretVault -Name $vaultName -ModuleName $PathToManifest
    } #beforeAll

    AfterAll {
        Unregister-SecretVault -Name $vaultName -ErrorAction Ignore
    } #afterAll

    Context 'Your First Vault Test' {

        It 'should always be true' {
            $true | Should -BeTrue
        } #it

    } #context_FunctionName
} #describe_vaultExtension
