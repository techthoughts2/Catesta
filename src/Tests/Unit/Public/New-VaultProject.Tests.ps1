#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'Catesta'
#-------------------------------------------------------------------------
#if the module is already in memory, remove it
Get-Module $ModuleName | Remove-Module -Force
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
InModuleScope $ModuleName {
    $functionName = 'New-VaultProject'
    Describe "$functionName Function Tests" -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
            $path = '{0}\{1}' -f $env:TEMP, 'testVault'
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
                Mock -CommandName New-VaultProject -MockWith { } #endMock
                Mock New-VaultProject {}
            }
            It 'Should process by default' {
                New-VaultProject -DestinationPath $path
                Should -Invoke -CommandName New-VaultProject -Exactly -Times 1 -Scope It
            } #it
            It 'Should not process on explicit request for confirmation (-Confirm)' {
                { New-VaultProject -DestinationPath $path -Confirm }
                Should -Invoke -CommandName New-VaultProject -Exactly -Times 0 -Scope It
            } #it
            It 'Should not process on implicit request for confirmation (ConfirmPreference)' {
                {
                    $ConfirmPreference = 'Low'
                    New-VaultProject -DestinationPath $path
                }
                Should -Invoke -CommandName New-VaultProject -Exactly -Times 0 -Scope It
            } #it
            It 'Should not process on explicit request for validation (-WhatIf)' {
                { New-VaultProject -DestinationPath $path -WhatIf }
                Should -Invoke -CommandName New-VaultProject -Exactly -Times 0 -Scope It
            } #it
            It 'Should not process on implicit request for validation (WhatIfPreference)' {
                {
                    $WhatIfPreference = $true
                    New-VaultProject -DestinationPath $path
                }
                Should -Invoke -CommandName New-VaultProject -Exactly -Times 0 -Scope It
            } #it
            It 'Should process on force' {
                $ConfirmPreference = 'Medium'
                New-VaultProject -DestinationPath $path -Force
                Should -Invoke -CommandName New-VaultProject -Exactly -Times 1 -Scope It
            } #it

        } #context_shouldprocess

        Context 'Error' {

            It 'should not throw if no issues are encountered' {
                { New-VaultProject -DestinationPath $path } | Should -Not -Throw
            } #it

            It 'should return an InvokePlasterInfo object if PassThru switch provided' {
                New-VaultProject -DestinationPath $path -PassThru | Should -Not -BeNullOrEmpty
            } #it

            It 'should return null if PassThru switch not provided' {
                New-VaultProject -DestinationPath $path | Should -BeNullOrEmpty
            } #it

            It 'should have the VAULT parameter set to VAULT even if a custom value is passed in' {
                New-VaultProject -DestinationPath $path -VaultParameters @{
                    VAULT = 'NOTVAULT'
                }
                Should -Invoke -CommandName Invoke-Plaster -Times 1 -ParameterFilter {
                    $VAULT -eq 'VAULT'
                }
            } #it

            It 'should have the PassThru parameter set properly if PassThru switch specified' {
                New-VaultProject -DestinationPath $path -PassThru -VaultParameters @{
                    VAULT = 'VAULT'
                }
                Should -Invoke -CommandName Invoke-Plaster -Times 1 -ParameterFilter {
                    $PassThru -eq $true
                }
            } #it

            It 'should pass on the expected parameters when VaultParameters are supplied' {
                $VaultParameters = @{
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
                New-VaultProject -VaultParameters $VaultParameters -DestinationPath .
                Should -Invoke -CommandName Invoke-Plaster -Times 1 -ParameterFilter {
                    $VAULT -eq 'VAULT'
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
