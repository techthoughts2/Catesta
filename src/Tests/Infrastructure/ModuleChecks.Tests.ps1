#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'Catesta'
#-------------------------------------------------------------------------
#if the module is already in memory, remove it
Get-Module $ModuleName | Remove-Module -Force
$PathToManifest = [System.IO.Path]::Combine('..', '..', 'Artifacts', "$ModuleName.psd1")
#-------------------------------------------------------------------------
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
$resourcePath1 = [System.IO.Path]::Combine( '..', '..', $ModuleName, 'Resources')
# $manifests = Get-ChildItem -Path $resourcePath1 -Include '*.xml' -Recurse
#-------------------------------------------------------------------------
Describe 'File Checks' {

    BeforeAll {
        $WarningPreference = 'Continue'
        Set-Location -Path $PSScriptRoot
        $ModuleName = 'Catesta'
        # $resourcePath = [System.IO.Path]::Combine( '..', '..', $ModuleName, 'Resources')
        # $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
        # $srcRoot = [System.IO.Path]::Combine( '..', '..')
        $outPutPath = '{0}\{1}' -f $env:TEMP, 'catesta_infra_testing'
        New-Item -Path $outPutPath -ItemType Directory  -ErrorAction SilentlyContinue
    } #beforeAll

    Context 'Module Checks' {
        BeforeEach {
            Remove-Item -Path "$outPutPath\*" -Recurse -Force
            # $codeBuildModuleFiles = Get-ChildItem -Path "$outPutPath\*" -Recurse
        } #beforeEach
        # BeforeAll {
        #     Remove-Item -Path "$outPutPath\*" -Recurse -Force
        # }

        Context 'CI/CD' {

            Context 'Module Only' {

                It 'should generate a module only scaffold with base elements' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'NONE'
                        CodingStyle = 'Stroustrup'
                        Help        = 'Yes'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $moduleOnlyFiles = Get-ChildItem -Path "$outPutPath\*" -Recurse

                    $moduleOnlyFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $false

                    # MODULE
                    $moduleOnlyFiles.Name.Contains('modulename.psd1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('modulename.psm1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Imports.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('modulename.build.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('modulename.Settings.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-HelloWorld.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-Day.ps1') | Should -BeExactly $true

                    # Tests
                    $moduleOnlyFiles.Name.Contains('SampleInfraTest.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('ExportedFunctions.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('modulename-Module.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-HelloWorld.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-Day.Tests.ps1') | Should -BeExactly $true

                    # LICENSE
                    $moduleOnlyFiles.Name.Contains('GNULICENSE') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('ISCLICENSE') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('MITLICENSE') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('APACHELICENSE') | Should -BeExactly $false

                    # REPO
                    $moduleOnlyFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('SECURITY.md') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('.gitignore') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('PULL_REQUEST_TEMPLATE.md') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('bug-report.md') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('feature_request.md') | Should -BeExactly $false

                    # AWS
                    $moduleOnlyFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $false

                    $moduleOnlyFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('S3BucketsForPowerShellDevelopment.yml') | Should -BeExactly $false

                    # GitHub
                    $moduleOnlyFiles.Name.Contains('wf_Linux.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('wf_MacOS.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('wf_Windows.yml') | Should -BeExactly $false

                    # Azure
                    $moduleOnlyFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $false

                    # AppVeyor
                    $moduleOnlyFiles.Name.Contains('appveyor.yml') | Should -BeExactly $false

                    $buildContent = Get-Content -Path "$outPutPath\src\modulename.build.ps1" -Raw

                    # Styling
                    $buildContent | Should -BeLike '*Stroustrup*'

                    # Pester
                    $buildContent | Should -BeLike '*5.2.2*'

                    # Help
                    $buildContent | Should -BeLike '*CreateHelpStart*'

                } #it

            } #context_module_only

            Context 'AWS-CodeBuild' {

                It 'should generate a CodeBuild based module stored on GitHub with all required elements' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps', 'pwshcore', 'pwsh'
                        RepoType    = 'GITHUB'
                        License     = 'MIT'
                        Changelog   = 'CHANGELOG'
                        COC         = 'CONDUCT'
                        Contribute  = 'CONTRIBUTING'
                        Security    = 'SECURITY'
                        CodingStyle = 'Stroustrup'
                        Help        = 'Yes'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $codeBuildModuleFiles = Get-ChildItem -Path "$outPutPath\*" -Recurse

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true
                    $powershellContent = Get-Content -Path "$outPutPath\buildspec_powershell_windows.yml" -Raw
                    $powershellContent | Should -BeLike '*modulename*'
                    $linuxContent = Get-Content -Path "$outPutPath\buildspec_pwsh_linux.yml" -Raw
                    $linuxContent | Should -BeLike '*modulename*'
                    $pwshContent = Get-Content -Path "$outPutPath\buildspec_pwsh_windows.yml" -Raw
                    $pwshContent | Should -BeLike '*modulename*'

                    $codeBuildModuleFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContent = Get-Content -Path "$outPutPath\install_modules.ps1" -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('S3BucketsForPowerShellDevelopment.yml') | Should -BeExactly $true

                    $cfnContent = Get-Content -Path "$outPutPath\CloudFormation\PowerShellCodeBuildGit.yml" -Raw
                    $cfnContent | Should -BeLike "*CodeBuildpsProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshcoreProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshProject*"
                } #it

                It 'should generate a CodeBuild based module stored on CodeCommit with all required elements' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps', 'pwshcore', 'pwsh'
                        RepoType    = 'CodeCommit'
                        License     = 'MIT'
                        Changelog   = 'CHANGELOG'
                        COC         = 'CONDUCT'
                        Contribute  = 'CONTRIBUTING'
                        Security    = 'SECURITY'
                        CodingStyle = 'Stroustrup'
                        Help        = 'Yes'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $codeBuildModuleFiles = Get-ChildItem -Path "$outPutPath\*" -Recurse

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContent = Get-Content -Path "$outPutPath\install_modules.ps1" -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('S3BucketsForPowerShellDevelopment.yml') | Should -BeExactly $true

                    $cfnContent = Get-Content -Path "$outPutPath\CloudFormation\PowerShellCodeBuildCC.yml" -Raw
                    $cfnContent | Should -BeLike "*CodeBuildProjectWPS*"
                    $cfnContent | Should -BeLike "*CodeBuildProjectWPwsh*"
                    $cfnContent | Should -BeLike "*CodeBuildProjectLPwsh*"
                } #it

            } #aws_CodeBuild

        } #context_cicd

        Context 'Repo Checks' {

            Context 'CodeCommit' {

                It 'should generate the appropriate repo files for GitHub' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'CODECOMMIT'
                        License     = 'MIT'
                        Changelog   = 'CHANGELOG'
                        COC         = 'CONDUCT'
                        Contribute  = 'CONTRIBUTING'
                        Security    = 'SECURITY'
                        CodingStyle = 'Stroustrup'
                        Help        = 'Yes'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $repoFiles = Get-ChildItem -Path "$outPutPath\*" -Recurse

                    # REPO
                    $repoFiles.Name.Contains('.gitignore') | Should -BeExactly $true

                    $repoFiles.Name.Contains('PULL_REQUEST_TEMPLATE.md') | Should -BeExactly $false
                    $repoFiles.Name.Contains('bug-report.md') | Should -BeExactly $false
                    $repoFiles.Name.Contains('feature_request.md') | Should -BeExactly $false

                    $rootRepoFiles = Get-ChildItem -Path $outPutPath
                    $rootRepoFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $true
                    $rootRepoFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $true
                    $rootRepoFiles.Name.Contains('SECURITY.md') | Should -BeExactly $true

                    $docFiles = @(
                        'CHANGELOG.md'
                    )
                    foreach ($file in $dotGitHubFiles) {
                        ($repoFiles | Where-Object { $_.name -eq $file }).Directory | Should -BeLike '*.github*'
                    }
                    foreach ($file in $docFiles) {
                        ($repoFiles | Where-Object { $_.name -eq $file }).Directory | Should -BeLike '*docs*'
                    }

                } #it

            } #context_codecommit

            Context 'GitHub' {

                It 'should generate the appropriate repo files for GitHub' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'GITHUB'
                        License     = 'MIT'
                        Changelog   = 'CHANGELOG'
                        COC         = 'CONDUCT'
                        Contribute  = 'CONTRIBUTING'
                        Security    = 'SECURITY'
                        CodingStyle = 'Stroustrup'
                        Help        = 'Yes'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $repoFiles = Get-ChildItem -Path "$outPutPath\*" -Recurse

                    # LICENSE
                    $repoFiles.Name.Contains('LICENSE') | Should -BeExactly $true
                    $licenseContent = Get-Content -Path "$outPutPath\LICENSE" -Raw
                    $licenseContent | Should -BeLike '*mit*'

                    # REPO
                    $repoFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $true
                    $changelogContent = Get-Content -Path "$outPutPath\docs\CHANGELOG.md" -Raw
                    $changelogContent | Should -BeLike '*0.0.1*'
                    $repoFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $true
                    $contributingContent = Get-Content -Path "$outPutPath\.github\CONTRIBUTING.md" -Raw
                    $contributingContent | Should -BeLike '*modulename*'
                    $repoFiles.Name.Contains('SECURITY.md') | Should -BeExactly $true
                    $securityContent = Get-Content -Path "$outPutPath\.github\SECURITY.md" -Raw
                    $securityContent | Should -BeLike '*modulename*'
                    $repoFiles.Name.Contains('.gitignore') | Should -BeExactly $true
                    $repoFiles.Name.Contains('PULL_REQUEST_TEMPLATE.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('bug-report.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('feature_request.md') | Should -BeExactly $true

                    $dotGitHubFiles = @(
                        'CODE_OF_CONDUCT.md'
                        'CONTRIBUTING.md'
                        'SECURITY.md'
                        'PULL_REQUEST_TEMPLATE.md'
                        'bug-report.md'
                        'feature_request.md'
                    )
                    $docFiles = @(
                        'CHANGELOG.md'
                    )
                    foreach ($file in $dotGitHubFiles) {
                        ($repoFiles | Where-Object { $_.name -eq $file }).Directory | Should -BeLike '*.github*'
                    }
                    foreach ($file in $docFiles) {
                        ($repoFiles | Where-Object { $_.name -eq $file }).Directory | Should -BeLike '*docs*'
                    }

                } #it

            } #context_github

        } #context_repo

    } #context_module_checks

}
