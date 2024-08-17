BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope '<%=$PLASTER_PARAM_ModuleName%>' {
    Describe 'Get-HelloWorld Public Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {

            # It 'should ...' {

            # } #it

        } #context_Error
        Context 'Success' {

            BeforeEach {
                Mock -CommandName Get-Day -MockWith {
                    'Friday'
                } #endMock
            } #beforeEach

            It 'should return the expected results' {
                Get-HelloWorld | Should -BeExactly 'Hello, happy Friday World!'
            } #it

        } #context_Success
    } #describe_Get-HelloWorld
} #inModule
