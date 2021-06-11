#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'Catesta'
$resourcePath1 = [System.IO.Path]::Combine( '..', '..', $ModuleName, 'Resources')
$manifests = Get-ChildItem -Path $resourcePath1 -Include '*.xml' -Recurse
#-------------------------------------------------------------------------
Describe 'File Checks' {
    BeforeAll {
        Set-Location -Path $PSScriptRoot
        $ModuleName = 'Catesta'
        $resourcePath = [System.IO.Path]::Combine( '..', '..', $ModuleName, 'Resources')
        $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
        $script:manifestEval = Test-ModuleManifest -Path $PathToManifest
        $manifestsEvalz = Get-ChildItem -Path $resourcePath -Include '*.xml' -Recurse
        $editorFiles = Get-ChildItem -Path "$resourcePath\Editor\*" -Recurse
        $srcFiles = Get-ChildItem -Path "$resourcePath\Module\*" -Recurse
        $vaultFiles = Get-ChildItem -Path "$resourcePath\Vault\*" -Recurse
        $gitFiles = Get-ChildItem -Path "$resourcePath\GitHubFiles\*" -Recurse
        $awsFiles = Get-ChildItem -Path "$resourcePath\AWS\*" -Recurse
        $githubFiles = Get-ChildItem -Path "$resourcePath\GitHubActions\*" -Recurse
        $azureFiles = Get-ChildItem -Path "$resourcePath\Azure\*" -Recurse
        $appVeyorFiles = Get-ChildItem -Path "$resourcePath\AppVeyor\*" -Recurse
        $mOnlyFiles = Get-ChildItem -Path "$resourcePath\Vanilla\*" -Recurse
    }
    Context 'Editor' {
        It 'should have all VSCode files' {
            $editorFiles.Name.Contains('extensions.json') | Should -BeExactly $true
            $editorFiles.Name.Contains('settings.json') | Should -BeExactly $true
            $editorFiles.Name.Contains('tasks.json') | Should -BeExactly $true
        } #it
    } #context_Editor
    Context 'Module Source Files' {
        It 'should have a module file' {
            $srcFiles.Name.Contains('Module.psm1') | Should -BeExactly $true
        } #it
        It 'should have build files' {
            $srcFiles.Name.Contains('PSModule.build.ps1') | Should -BeExactly $true
            $srcFiles.Name.Contains('PSModule.Settings.ps1') | Should -BeExactly $true
        } #it
        It 'should have a PSScriptAnalyzerSettings file' {
            $srcFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true
        } #it
        It 'should have a public function example' {
            $srcFiles.Name.Contains('Get-HelloWorld.ps1') | Should -BeExactly $true
        } #it
        It 'should have a private function example' {
            $srcFiles.Name.Contains('Get-Day.ps1') | Should -BeExactly $true
        } #it
    } #context_module
    Context 'Vault Source Files' {
        It 'should have an extension module file' {
            $vaultFiles.Name.Contains('PSVault.Extension.psm1') | Should -BeExactly $true
        } #it
        It 'should have an extension manifest file' {
            $vaultFiles.Name.Contains('PSVault.Extension.psd1') | Should -BeExactly $true
        } #it
        It 'should have build files' {
            $vaultFiles.Name.Contains('PSVault.build.ps1') | Should -BeExactly $true
            $vaultFiles.Name.Contains('PSVault.Settings.ps1') | Should -BeExactly $true
        } #it
        It 'should have a PSScriptAnalyzerSettings file' {
            $vaultFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true
        } #it
    } #context_vault
    Context 'Github' {
        It 'should have all license files' {
            $gitFiles.Name.Contains('GNULICENSE') | Should -BeExactly $true
            $gitFiles.Name.Contains('ISCLICENSE') | Should -BeExactly $true
            $gitFiles.Name.Contains('MITLICENSE') | Should -BeExactly $true
            $gitFiles.Name.Contains('APACHELICENSE') | Should -BeExactly $true
        } #it
        It 'should have a Pull Request Template' {
            $gitFiles.Name.Contains('PULL_REQUEST_TEMPLATE.md') | Should -BeExactly $true

        } #it
        It 'should have a Contributing file' {
            $gitFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $true

        } #it
        It 'should have a Code of Conduct' {
            $gitFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $true

        } #it
        It 'should have a Changelog' {
            $gitFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $true

        } #it
        It 'should have issue templates' {
            $gitFiles.Name.Contains('bug-report.md') | Should -BeExactly $true
            $gitFiles.Name.Contains('feature_request.md') | Should -BeExactly $true
        } #it
    } #context_Github
    Context 'AWS' {
        It 'should have a plaster manifest file' {
            $awsFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        } #it
        It 'should have all build files' {
            $awsFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true
        } #it
        It 'should have a configure aws credential file' {
            $awsFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true
        } #it
        It 'should have install modules file' {
            $awsFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
        } #it
        It 'should have all required CloudFormation files' {
            $awsFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true
            $awsFiles.Name.Contains('S3BucketsForPowerShellDevelopment.yml') | Should -BeExactly $true
        } #it
    } #context_AWS
    Context 'GitHub Actions' {
        It 'should have a plaster manifest file' {
            $githubFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        } #it
        It 'should have all workflow files' {
            $githubFiles.Name.Contains('wf_Linux.yml') | Should -BeExactly $true
            $githubFiles.Name.Contains('wf_MacOS.yml') | Should -BeExactly $true
            $githubFiles.Name.Contains('wf_Windows.yml') | Should -BeExactly $true
        } #it
        It 'should have a actions bootstrap file' {
            $githubFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        } #it
    } #context_githubactions
    Context 'Azure Pipelines' {
        It 'should have a plaster manifest file' {
            $azureFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        } #it
        It 'should have a pipelines file' {
            $azureFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true

        } #it
        It 'should have a actions bootstrap file' {
            $azureFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        } #it
    } ##context_azure_pipelines
    Context 'AppVeyor' {
        It 'should have a plaster manifest file' {
            $appVeyorFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        } #it
        It 'should have an appVeyor file' {
            $appVeyorFiles.Name.Contains('appveyor.yml') | Should -BeExactly $true

        } #it
        It 'should have a actions bootstrap file' {
            $appVeyorFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        } #it
    } #appVeyor
    Context 'ModuleOnly' {
        It 'should have a plaster manifest file' {
            $mOnlyFiles.Name.Contains('plasterManifest.xml') | Should -BeExactly $true
        } #it
    } ##context_moduleOnly
    Context 'Templates' {
        It 'should have the correct number of templates' {
            $manifestCount = $manifestsEvalz | Measure-Object | Select-Object -ExpandProperty Count
            $manifestCount | Should -BeExactly 10
        } #it
        Context 'Manifest Version' -Foreach $manifests {
            It "<_>.FullName version should match the module version" {

                [version]$scriptVersion = $script:manifestEval.Version
                [xml]$eval = $null
                $eval = Get-Content -Path $_.FullName
                $eval.plasterManifest.metadata.version | Should -BeExactly $scriptVersion
            } #it

        } #context_manifests
        It 'should not have any duplicate manifest ids' {
            $ids = @()
            foreach ($manifest in $manifestsEvalz) {
                [xml]$eval = $null
                $eval = Get-Content -Path $manifest.FullName
                $ids += $eval.plasterManifest.metadata.id
            }
            $uniqueCount = $ids | Get-Unique | Measure-Object | Select-Object -ExpandProperty Count
            $uniqueCount | Should -BeExactly 10
        } #it
    } #context_templates
} #describe_File_Checks