BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'Catesta'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope $ModuleName {
    $functionName = 'New-ModuleProject'
    Describe "$functionName Function Tests" -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $path = '{0}\{1}' -f $env:TEMP, 'testModule'
        } #beforeAll

        # Mock -CommandName Write-Error { }
        # Mock -CommandName Write-Warning { }

        BeforeEach {
            Mock -CommandName Import-Module { }
            function Invoke-Plaster {
                param(
                    $VAULT,
                    $PassThru
                )
            }
            Mock -CommandName Invoke-Plaster -MockWith {
                [PSCustomObject]@{
                    TemplatePath    = 'C:\Users\jake\Desktop\Project\0_CodeProject\Catesta\src\Catesta\Resources\AWS'
                    DestinationPath = 'C:\rs-pkgs\test\plastertest3'
                    Success         = $true
                    TemplateType    = 'Project'
                    CreatedFiles    = '{C:\rs-pkgs\test\plastertest3\.vscode\tasks.json}'
                    UpdatedFiles    = '{}'
                    MissingModules  = '{}'
                    OpenFiles       = '{C:\rs-pkgs\test\plastertest3\src\test12234\test12234.psd1, C:\rs-pkgs\test\plastertest3\src\test12234\test12234.psm1}'
                }
            } #endMock
        } #beforeEach

        Context 'ShouldProcess' {

            BeforeEach {
                Mock -CommandName Invoke-Plaster { }
                Mock -CommandName Import-Module { }
                Mock -CommandName New-ModuleProject -MockWith { } #endMock
            } #end_beforeEach
            It 'Should process by default' {
                New-ModuleProject -DestinationPath $path
                # Should -Invoke New-ModuleProject -Scope It -Exactly -Times 1
                Should -Invoke New-ModuleProject -Scope It -Exactly -Times 1
            } #it
            It 'Should not process on explicit request for confirmation (-Confirm)' {
                { New-ModuleProject -DestinationPath $path -Confirm }
                Should -Invoke New-ModuleProject -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on implicit request for confirmation (ConfirmPreference)' {
                {
                    $ConfirmPreference = 'Low'
                    New-ModuleProject -DestinationPath $path
                }
                Should -Invoke New-ModuleProject -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on explicit request for validation (-WhatIf)' {
                { New-ModuleProject -DestinationPath $path -WhatIf }
                Should -Invoke New-ModuleProject -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on implicit request for validation (WhatIfPreference)' {
                {
                    $WhatIfPreference = $true
                    New-ModuleProject -DestinationPath $path
                }
                Should -Invoke New-ModuleProject -Scope It -Exactly -Times 0
            } #it
            It 'Should process on force' {
                $ConfirmPreference = 'Medium'
                New-ModuleProject -DestinationPath $path -Force
                Should -Invoke New-ModuleProject -Scope It -Exactly -Times 1
            } #it

        } #context_shouldprocess

        Context 'Error' {

            It 'should throw if Plaster module can not be imported' {
                Mock -CommandName Import-Module -MockWith {
                    throw 'Fake Error'
                } #endMock
                { New-ModuleProject -DestinationPath $path } | Should -Throw
            } #it

            It 'should throw if an error is encountered creating the template with Plaster' {
                Mock -CommandName Invoke-Plaster -MockWith {
                    throw 'Fake Error'
                }
                { New-ModuleProject -DestinationPath $path } | Should -Throw
            } #it

        } #context_Error

        Context 'Success' {

            It 'should not throw if no issues are encountered' {
                { New-ModuleProject -DestinationPath $path } | Should -Not -Throw
            } #it

            It 'should return an InvokePlasterInfo object if PassThru switch provided' {
                New-ModuleProject -DestinationPath $path -PassThru | Should -Not -BeNullOrEmpty
            } #it

            It 'should return null if PassThru switch not provided' {
                New-ModuleProject -DestinationPath $path | Should -BeNullOrEmpty
            } #it

            It 'should have the VAULT parameter set to NOTVAULT even if a custom value is passed in' {
                New-ModuleProject -DestinationPath $path -ModuleParameters @{
                    VAULT = 'VAULT'
                }
                Should -Invoke -CommandName Invoke-Plaster -Times 1 -ParameterFilter {
                    $VAULT -eq 'NOTVAULT'
                }
            } #it

            It 'should have the PassThru parameter set properly if PassThru switch specified' {
                New-ModuleProject -DestinationPath $path -PassThru -ModuleParameters @{
                    VAULT = 'VAULT'
                }
                Should -Invoke -CommandName Invoke-Plaster -Times 1 -ParameterFilter {
                    $PassThru -eq $true
                }
            } #it

            It 'should pass on the expected parameters when ModuleParameters are supplied' {
                $moduleParameters = @{
                    VAULT       = 'text'
                    ModuleName  = 'text'
                    Description = 'text'
                    Version     = '0.0.1'
                    FN          = 'user full name'
                    CICD        = 'GITHUB'
                    AWSOptions  = 'ps'
                    RepoType    = 'GITHUB'
                    License     = 'MIT'
                    Changelog   = 'CHANGELOG'
                    COC         = 'CONDUCT'
                    Contribute  = 'CONTRIBUTING'
                    Security    = 'SECURITY'
                    CodingStyle = 'Stroustrup'
                    Help        = 'Yes'
                    Pester      = '5'
                    PassThru    = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath .
                Should -Invoke -CommandName Invoke-Plaster -Times 1 -ParameterFilter {
                    $VAULT -eq 'NOTVAULT'
                    $ModuleName -eq 'text'
                    $Description -eq 'text'
                    $Version -eq '0.0.1'
                    $FN -eq 'user full name'
                    $CICD -eq 'GITHUB'
                    $AWSOptions -eq 'ps'
                    $RepoType -eq 'GITHUB'
                    $License -eq 'MIT'
                    $Changelog -eq 'CHANGELOG'
                    $COC -eq 'CONDUCT'
                    $Contribute -eq 'CONTRIBUTING'
                    $Security -eq 'SECURITY'
                    $CodingStyle -eq 'Stroustrup'
                    $Help -eq 'Yes'
                    $Pester -eq '5'
                    $PassThru -eq $true
                    $ErrorAction -eq 'Stop'
                    $TemplatePath -ne $null
                    $DestinationPath -eq '.'
                }
            } #it

        } #context_Success

    } #describe
} #inModule
