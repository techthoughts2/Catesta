#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'Catesta'
#-------------------------------------------------------------------------
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
$resourcePath = [System.IO.Path]::Combine('..', '..', $ModuleName, 'Resources')
#-------------------------------------------------------------------------
Describe 'File Checks' {
    Context 'Editor' {
        $editorFiles = Get-ChildItem -Path "$resourcePath\Editor\*" -Recurse
        It 'should have all VSCode files' {
            $editorFiles.Name.Contains('extensions.json') | Should -BeExactly $true
            $editorFiles.Name.Contains('settings.json') | Should -BeExactly $true
            $editorFiles.Name.Contains('tasks.json') | Should -BeExactly $true
        }#it
    }#context_Editor
    Context 'Module Source Files' {
        $srcFiles = Get-ChildItem -Path "$resourcePath\Module\*" -Recurse
        It 'should have a module file' {
            $srcFiles.Name.Contains('Module.psm1') | Should -BeExactly $true
        }#it
        It 'should have build files' {
            $srcFiles.Name.Contains('PSModule.build.ps1') | Should -BeExactly $true
            $srcFiles.Name.Contains('PSModule.Settings.ps1') | Should -BeExactly $true
        }#it
        It 'should have a PSScriptAnalyzerSettings file' {
            $srcFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true
        }#it
        It 'should have a public function example' {
            $srcFiles.Name.Contains('Get-HelloWorld.ps1') | Should -BeExactly $true
        }#it
        It 'should have a private function example' {
            $srcFiles.Name.Contains('Get-PrivateHelloWorld.ps1') | Should -BeExactly $true
        }#it
    }#context_module
    Context 'Vault Source Files' {
        $srcFiles = Get-ChildItem -Path "$resourcePath\Vault\*" -Recurse
        It 'should have an extension module file' {
            $srcFiles.Name.Contains('PSVault.Extension.psm1') | Should -BeExactly $true
        }#it
        It 'should have an extension manifest file' {
            $srcFiles.Name.Contains('PSVault.Extension.psd1') | Should -BeExactly $true
        }#it
        It 'should have build files' {
            $srcFiles.Name.Contains('PSVault.build.ps1') | Should -BeExactly $true
            $srcFiles.Name.Contains('PSVault.Settings.ps1') | Should -BeExactly $true
        }#it
        It 'should have a PSScriptAnalyzerSettings file' {
            $srcFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true
        }#it
    }#context_vault
    Context 'Github' {
        $gitFiles = Get-ChildItem -Path "$resourcePath\GitHubFiles\*" -Recurse
        It 'should have all license files' {
            $gitFiles.Name.Contains('GNULICENSE') | Should -BeExactly $true
            $gitFiles.Name.Contains('ISCLICENSE') | Should -BeExactly $true
            $gitFiles.Name.Contains('MITLICENSE') | Should -BeExactly $true
            $gitFiles.Name.Contains('APACHELICENSE') | Should -BeExactly $true
        }#it
        It 'should have a Pull Request Template' {
            $gitFiles.Name.Contains('PULL_REQUEST_TEMPLATE.md') | Should -BeExactly $true

        }#it
        It 'should have a Contributing file' {
            $gitFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $true

        }#it
        It 'should have a Code of Conduct' {
            $gitFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $true

        }#it
        It 'should have a Changelog' {
            $gitFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $true

        }#it
        It 'should have issue templates' {
            $gitFiles.Name.Contains('bug-report.md') | Should -BeExactly $true
            $gitFiles.Name.Contains('feature_request.md') | Should -BeExactly $true
        }#it
    }#context_Github
    Context 'AWS' {
        $awsFiles = Get-ChildItem -Path "$resourcePath\AWS\*" -Recurse
        It 'should have a plaster manifest file' {
            $awsFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        }#it
        It 'should have all build files' {
            $awsFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true
        }#it
        It 'should have a configure aws credential file' {
            $awsFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true
        }#it
        It 'should have install modules file' {
            $awsFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
        }#it
        It 'should have all required CloudFormation files' {
            $awsFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('S3BucketsForPowerShellDevelopment.yml') | Should -BeExactly $true
        }#it
    }#context_AWS
    Context 'GitHub Actions' {
        $githubFiles = Get-ChildItem -Path "$resourcePath\GitHubActions\*" -Recurse
        It 'should have a plaster manifest file' {
            $githubFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        }#it
        It 'should have all workflow files' {
            $githubFiles.Name.Contains('wf_Linux.yml') | Should -BeExactly $true
            $githubFiles.Name.Contains('wf_MacOS.yml') | Should -BeExactly $true
            $githubFiles.Name.Contains('wf_Windows.yml') | Should -BeExactly $true
        }#it
        It 'should have a actions bootstrap file' {
            $githubFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        }#it
    }#context_githubactions
    Context 'Azure Pipelines' {
        $azureFiles = Get-ChildItem -Path "$resourcePath\Azure\*" -Recurse
        It 'should have a plaster manifest file' {
            $azureFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        }#it
        It 'should have a pipelines file' {
            $azureFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true

        }#it
        It 'should have a actions bootstrap file' {
            $azureFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        }#it
    }#azure_pipelines
    Context 'AppVeyor' {
        $appVeyorFiles = Get-ChildItem -Path "$resourcePath\AppVeyor\*" -Recurse
        It 'should have a plaster manifest file' {
            $appVeyorFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        }#it
        It 'should have an appVeyor file' {
            $appVeyorFiles.Name.Contains('appveyor.yml') | Should -BeExactly $true

        }#it
        It 'should have a actions bootstrap file' {
            $appVeyorFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        }#it
    }#appVeyor
    Context 'ModuleOnly' {
        $mOnlyFiles = Get-ChildItem -Path "$resourcePath\Vanilla\*" -Recurse
        It 'should have a plaster manifest file' {
            $mOnlyFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        }#it
    }#appVeyor
    Context 'Templates' {
        $script:manifestEval = Test-ModuleManifest -Path $PathToManifest
        [version]$scriptVersion = $script:manifestEval.Version
        $manifests = Get-ChildItem -Path $resourcePath -Include '*.xml' -Recurse
        $manifestCount = $manifests | Measure-Object | Select-Object -ExpandProperty Count
        It 'should have the correct number of templates' {
            $manifestCount | should -BeExactly 10
        }#it
        $ids = @()
        foreach ($manifest in $manifests) {
            [xml]$eval = $null
            $eval = Get-Content -Path $manifest.FullName
            $ids += $eval.plasterManifest.metadata.id
            It "$($manifest.FullName) version should match the module version" {
                $eval.plasterManifest.metadata.version | Should -BeExactly $scriptVersion
            }#it
        }
        It 'should not have any duplicate manifest ids' {
            $uniqueCount = $ids | Get-Unique | Measure-Object | Select-Object -ExpandProperty Count
            $uniqueCount | Should -BeExactly 10
        }#it
    }#templates
}#describe_File_Checks