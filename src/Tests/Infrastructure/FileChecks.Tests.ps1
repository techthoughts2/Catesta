#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'Catesta'
$resourcePath1 = [System.IO.Path]::Combine( '..', '..', 'Artifacts', 'Resources')
$manifests = Get-ChildItem -Path $resourcePath1 -Include '*.xml' -Recurse
#-------------------------------------------------------------------------
Describe 'File Checks' {
    BeforeAll {
        $WarningPreference = 'Continue'
        Set-Location -Path $PSScriptRoot
        $ModuleName = 'Catesta'
        $srcRoot = [System.IO.Path]::Combine( '..', '..')
        $resourcePath = [System.IO.Path]::Combine( $srcRoot, 'Artifacts', 'Resources')
        $PathToManifest = [System.IO.Path]::Combine($srcRoot, 'Artifacts', "$ModuleName.psd1")

        $script:manifestEval = Test-ModuleManifest -Path $PathToManifest
        $directories = Get-ChildItem -Path $srcRoot -Recurse | Where-Object { $_.PSIsContainer -eq $true }
        $directoryNames = $directories | Select-Object -ExpandProperty Name | Sort-Object -Unique
        $manifestsEvalz = Get-ChildItem -Path $resourcePath -Include '*.xml' -Recurse
        $editorFiles = Get-ChildItem -Path "$resourcePath\Editor\*" -Recurse
        $repoFiles = Get-ChildItem -Path "$resourcePath\RepoFiles\*" -Recurse
        $srcFiles = Get-ChildItem -Path "$resourcePath\Module\*" -Recurse
        $vaultFiles = Get-ChildItem -Path "$resourcePath\Vault\*" -Recurse
        $gitFiles = Get-ChildItem -Path "$resourcePath\GitHubFiles\*" -Recurse
        $azureRepoFiles = Get-ChildItem -Path "$resourcePath\AzureRepoFiles\*" -Recurse
        $awsFiles = Get-ChildItem -Path "$resourcePath\AWS\*" -Recurse
        $githubFiles = Get-ChildItem -Path "$resourcePath\GitHubActions\*" -Recurse
        $azureFiles = Get-ChildItem -Path "$resourcePath\Azure\*" -Recurse
        $appVeyorFiles = Get-ChildItem -Path "$resourcePath\AppVeyor\*" -Recurse
        $bitbucketFiles = Get-ChildItem -Path "$resourcePath\Bitbucket\*" -Recurse
        $gitlabFiles = Get-ChildItem -Path "$resourcePath\GitLab\*" -Recurse -Force

        $docsPath = [System.IO.Path]::Combine( '..', '..', '..', 'docs')
        $docFiles = Get-ChildItem -Path $docsPath -Recurse
    } #beforeAll

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

    Context 'Repo Files' {
        It 'should have all license files' {
            $repoFiles.Name.Contains('GNULICENSE') | Should -BeExactly $true
            $repoFiles.Name.Contains('ISCLICENSE') | Should -BeExactly $true
            $repoFiles.Name.Contains('MITLICENSE') | Should -BeExactly $true
            $repoFiles.Name.Contains('APACHELICENSE') | Should -BeExactly $true
        } #it
        It 'should have a Contributing file' {
            $repoFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $true
        } #it
        It 'should have a Code of Conduct' {
            $repoFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $true
        } #it
        It 'should have a Changelog' {
            $repoFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $true
        } #it
        It 'should have a gitignore file' {
            $repoFiles.Name.Contains('agitignore') | Should -BeExactly $true
        } #it
    } #context_repo

    Context 'GitHub Repo' {
        It 'should have a Pull Request Template' {
            $gitFiles.Name.Contains('PULL_REQUEST_TEMPLATE.md') | Should -BeExactly $true

        } #it
        It 'should have issue templates' {
            $gitFiles.Name.Contains('bug-report.md') | Should -BeExactly $true
            $gitFiles.Name.Contains('feature_request.md') | Should -BeExactly $true
        } #it
    } #context_Github_Repo

    Context 'Azure Repo' {
        It 'should have a Pull Request Template' {
            $azureRepoFiles.Name.Contains('pull_request_template.md') | Should -BeExactly $true

        } #it
    } #context_Azure_Repo

    Context 'AWS' {
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
        } #it
    } #context_AWS

    Context 'GitHub Actions' {
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
        It 'should have a pipelines file' {
            $azureFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true
        } #it
        It 'should have a actions bootstrap file' {
            $azureFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        } #it
    } ##context_azure_pipelines

    Context 'AppVeyor' {
        It 'should have an appVeyor file' {
            $appVeyorFiles.Name.Contains('appveyor.yml') | Should -BeExactly $true

        } #it
        It 'should have a actions bootstrap file' {
            $appVeyorFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        } #it
    } #appVeyor

    Context 'Bitbucket' {
        It 'should have a Bitbucket pipeline yaml' {
            $bitbucketFiles.Name.Contains('bitbucket-pipelines.yml') | Should -BeExactly $true

        } #it
        It 'should have a actions bootstrap file' {
            $bitbucketFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        } #it
    } #bitbucket

    Context 'GitLab' {
        It 'should have a GitLab pipeline yaml' {
            $gitlabFiles.Name.Contains('.gitlab-ci.yml') | Should -BeExactly $true

        } #it
        It 'should have a actions bootstrap file' {
            $gitlabFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
        } #it
    } #bitbucket

    # Context 'ModuleOnly' {

    # } ##context_moduleOnly

    Context 'Templates' {
        It 'should have the correct number of templates' {
            $manifestCount = $manifestsEvalz | Measure-Object | Select-Object -ExpandProperty Count
            $manifestCount | Should -BeExactly 2
        } #it
        Context 'Manifest Checks' -Foreach $manifests {
            It "<_>.FullName version should match the module version" {

                [version]$scriptVersion = $script:manifestEval.Version
                [xml]$eval = $null
                $eval = Get-Content -Path $_.FullName
                $eval.plasterManifest.metadata.version | Should -BeExactly $scriptVersion
            } #it
            It "<_>.FullName should pass module manifest test" {
                { Test-PlasterManifest -Path $_.FullName } | Should -Not -Throw
                Test-PlasterManifest -Path $_.FullName | Should -Not -BeNullOrEmpty
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
            $uniqueCount | Should -BeExactly 2
        } #it
        Context 'Case Sensitivity Checks' {
            It 'should have template references that match the casing of the directory path' {
                $caseViolationCount = 0
                foreach ($manifest in $manifestsEvalz) {
                    # --------------
                    # resets
                    $zeMatches = $null
                    $content = $null
                    $content = Get-Content -Path $manifest.FullName
                    # --------------
                    foreach ($dir in $directoryNames) {
                        # --------------
                        # resets
                        $zeMatches = $null
                        $zeMatches = $content -imatch $dir
                        # --------------
                        foreach ($line in $zeMatches) {
                            if ($line -like '*<*>*') {
                                if (
                                    $line -like "*/$dir*" -or
                                    $line -like "*\$dir*" -or
                                    $line -like "*$dir/*" -or
                                    $line -like "*$dir\*"
                                ) {
                                    if ($line -like "*$dir.*" -or $line -like '*azure-pipelines.yml*') {
                                        # skip if referencing a filename
                                        continue
                                    }
                                    # evaluate case sensitivity
                                    if ($dir -like '*.*') {
                                        if (-not ($line -cmatch [regex]::Escape($dir))) {
                                            $caseViolationCount++
                                            Write-Warning -Message ('VIOLATION: {0} - {1} - {2}' -f $dir, $line, $manifest)
                                        }
                                    }
                                    else {
                                        if (-not ([regex]::Escape($line) -cmatch [regex]::Escape($dir))) {
                                            $caseViolationCount++
                                            Write-Warning -Message ('VIOLATION: {0} - {1} - {2}' -f $dir, $line, $manifest)
                                        }
                                    }
                                } #if_dir
                            } #if_reference_line
                        } #foreach_line_match
                    } #foreach_directoryName
                } #foreach_manifest
                $caseViolationCount | Should -BeExactly 0
            } #it
        } #context_case_sensitivity
    } #context_templates

    Context 'Docs' {
        It 'should have a module schema file' {
            $docFiles.Name.Contains('Catesta-ModuleSchema.md') | Should -BeExactly $true
        } #it
        It 'should have a vault schema file' {
            $docFiles.Name.Contains('Catesta-VaultSchema.md') | Should -BeExactly $true
        } #it
        It 'should have the expected readthedocs doc files' {
            $docFiles.Name.Contains('Catesta-Advanced.md') | Should -BeExactly $true
            $docFiles.Name.Contains('Catesta-Basics.md') | Should -BeExactly $true
            $docFiles.Name.Contains('Catesta-FAQ.md') | Should -BeExactly $true
            $docFiles.Name.Contains('Catesta-Vault-Extension.md') | Should -BeExactly $true
            $docFiles.Name.Contains('index.md') | Should -BeExactly $true
            $docFiles.Name.Contains('Catesta-AppVeyor.md') | Should -BeExactly $true
            $docFiles.Name.Contains('Catesta-AWS.md') | Should -BeExactly $true
            $docFiles.Name.Contains('Catesta-Azure.md') | Should -BeExactly $true
            $docFiles.Name.Contains('Catesta-GHActions.md') | Should -BeExactly $true
        }
        It 'should have the generated module docs' {
            $docFiles.Name.Contains('Catesta.md') | Should -BeExactly $true
            $docFiles.Name.Contains('New-ModuleProject.md') | Should -BeExactly $true
            $docFiles.Name.Contains('New-VaultProject.md') | Should -BeExactly $true
        }
    } #context_docs

} #describe_File_Checks
