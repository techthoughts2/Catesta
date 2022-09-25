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
    $functionName = 'New-PowerShellProject'
    Describe "$functionName Function Tests" -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Mock -CommandName Write-Error { }
        Mock -CommandName Write-Warning { }
        Context 'ShouldProcess' {
            BeforeEach {
                Mock -CommandName Invoke-Plaster { }
                Mock -CommandName Import-Module { }
                Mock -CommandName New-PowerShellProject -MockWith { } #endMock
            } #end_beforeEach
            It 'Should process by default' {
                New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path
                # Should -Invoke New-PowerShellProject -Scope It -Exactly -Times 1
                Should -Invoke New-PowerShellProject -Scope It -Exactly -Times 1
            } #it
            It 'Should not process on explicit request for confirmation (-Confirm)' {
                { New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path -Confirm }
                Should -Invoke New-PowerShellProject -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on implicit request for confirmation (ConfirmPreference)' {
                {
                    $ConfirmPreference = 'Low'
                    New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path
                }
                Should -Invoke New-PowerShellProject -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on explicit request for validation (-WhatIf)' {
                { New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path -WhatIf }
                Should -Invoke New-PowerShellProject -Scope It -Exactly -Times 0
            } #it
            It 'Should not process on implicit request for validation (WhatIfPreference)' {
                {
                    $WhatIfPreference = $true
                    New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path
                }
                Should -Invoke New-PowerShellProject -Scope It -Exactly -Times 0
            } #it
            It 'Should process on force' {
                $ConfirmPreference = 'Medium'
                New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path -Force
                Should -Invoke New-PowerShellProject -Scope It -Exactly -Times 1
            } #it
        }
        BeforeEach {
            Mock -CommandName Import-Module { }
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
        Context 'Error' {
            It 'should return success status false if Plaster module can not be imported' {
                Mock -CommandName Import-Module -MockWith {
                    throw 'Fake Error'
                } #endMock
                { New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path } | Should -Throw
            } #it
            It 'should return success status false if an error is encountered' {
                Mock -CommandName Invoke-Plaster -MockWith {
                    throw 'Fake Error'
                }
                (New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path).Success | Should -BeExactly $false
            } #it
        } #context_Error
        Context 'Success' {
            It 'should return success status true if no issues are encountered' {
                (New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path\AWSProject).Success | Should -BeExactly $true
                (New-PowerShellProject -CICDChoice 'GitHubActions' -DestinationPath c:\path\GitHubActions).Success | Should -BeExactly $true
                (New-PowerShellProject -CICDChoice 'Azure' -DestinationPath c:\path\AzurePipeline).Success | Should -BeExactly $true
                (New-PowerShellProject -CICDChoice 'AppVeyor' -DestinationPath c:\path\AppVeyor).Success | Should -BeExactly $true
                (New-PowerShellProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly).Success | Should -BeExactly $true
            } #it
        } #context_Success
    } #describe
} #inModule
