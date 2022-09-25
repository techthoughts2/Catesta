#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
$WarningPreference = "SilentlyContinue"
#-------------------------------------------------------------------------
#Import-Module $moduleNamePath -Force

InModuleScope '<%=$PLASTER_PARAM_ModuleName%>' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'Get-HelloWorld Public Function Tests' -Tag Unit {
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
