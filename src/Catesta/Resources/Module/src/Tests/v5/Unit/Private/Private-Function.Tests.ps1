BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope '<%=$PLASTER_PARAM_ModuleName%>' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'Get-Day Private Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {

            It 'should return unknown if an error is encountered getting the date' {
                Mock -CommandName Get-Date -MockWith {
                    throw 'Fake Error'
                } #endMock
                Get-Day | Should -BeExactly 'Unknown'
            } #it

        } #context_Error
        Context 'Success' {

            BeforeEach {
                Mock -CommandName Get-Date -MockWith {
                    [PSCustomObject]@{
                        DisplayHint = 'DateTime'
                        DateTime    = 'Thursday, June 11, 2021 21:08:41'
                        Date        = '06/11/21 00:00:00'
                        Day         = '10'
                        DayOfWeek   = 'Friday'
                        DayOfYear   = '162'
                        Hour        = '21'
                        Kind        = 'Local'
                        Millisecond = '989'
                        Minute      = '8'
                        Month       = '6'
                        Second      = '41'
                        Ticks       = '637589561219896868'
                        TimeOfDay   = '21:08:41.9896868'
                        Year        = '2021'
                    }
                } #endMock
            } #beforeEach

            It 'should return the expected results' {
                Get-Day | Should -BeExactly 'Friday'
            } #it

        } #context_Success
    } #describe_Get-HelloWorld
} #inModule
