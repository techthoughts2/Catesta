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
# $manifests = Get-ChildItem -Path $resourcePath1 -Include '*.xml' -Recurse -Force
#-------------------------------------------------------------------------
Describe 'Module Integration Tests' {

    BeforeAll {
        $WarningPreference = 'Continue'
        Set-Location -Path $PSScriptRoot
        $ModuleName = 'Catesta'
        # $resourcePath = [System.IO.Path]::Combine( '..', '..', $ModuleName, 'Resources')
        # $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
        # $srcRoot = [System.IO.Path]::Combine( '..', '..')
        $outPutPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'catesta_integration_testing')
        $outPutPathStar = "$outPutPath$([System.IO.Path]::DirectorySeparatorChar)*"
        $buildFile = [System.IO.Path]::Combine($outPutPath, 'src', 'modulename.build.ps1')
        New-Item -Path $outPutPath -ItemType Directory  -ErrorAction SilentlyContinue
    } #beforeAll

    Context 'Module Checks' {

        BeforeEach {
            Remove-Item -Path $outPutPathStar -Recurse -Force
            # $codeBuildModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force
        } #beforeEach
        # BeforeAll {
        #     Remove-Item -Path $outPutPathStar -Recurse -Force
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

                    $moduleOnlyFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $moduleOnlyFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $false

                    # MODULE
                    $moduleOnlyFiles.Name.Contains('modulename.psd1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('modulename.psm1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Imports.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('modulename.build.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('modulename.Settings.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('MarkdownRepair.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-HelloWorld.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-Day.ps1') | Should -BeExactly $true

                    # Tests
                    $moduleOnlyFiles.Name.Contains('SampleIntegrationTest.Tests.ps1') | Should -BeExactly $true
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
                    $moduleOnlyFiles.Name.Contains('README.md') | Should -BeExactly $false

                    # ReadtheDocs
                    $moduleOnlyFiles.Name.Contains('mkdocs.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('requirements.txt') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('.readthedocs.yaml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('index.md') | Should -BeExactly $false


                    # AWS
                    $moduleOnlyFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $false

                    $moduleOnlyFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false

                    # GitHub
                    $moduleOnlyFiles.Name.Contains('wf_Linux.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('wf_MacOS.yml') | Should -BeExactly $false
                    $moduleOnlyFiles.Name.Contains('wf_Windows.yml') | Should -BeExactly $false

                    # Azure
                    $moduleOnlyFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $false

                    # AppVeyor
                    $moduleOnlyFiles.Name.Contains('appveyor.yml') | Should -BeExactly $false

                    $buildContent = Get-Content -Path $buildFile -Raw

                    # Styling
                    $buildContent | Should -BeLike '*Stroustrup*'

                    # Pester
                    $buildContent | Should -BeLike '*5.2.2*'

                    # Help
                    $buildContent | Should -BeLike '*CreateHelpStart*'

                } #it

                It 'should generate a module only scaffold with base elements with no MarkdownRepair if help is not selected' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'NONE'
                        CodingStyle = 'Stroustrup'
                        Help        = 'No'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $moduleOnlyFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $moduleOnlyFiles.Name.Contains('MarkdownRepair.ps1') | Should -BeExactly $false

                } #it

                It 'should generate a namespaced module only scaffold with base elements' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'module.name'
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

                    $moduleOnlyFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    # MODULE
                    $moduleOnlyFiles.Name.Contains('module.name.psd1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('module.name.psm1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Imports.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('module.name.build.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('module.name.Settings.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('MarkdownRepair.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-HelloWorld.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-Day.ps1') | Should -BeExactly $true

                    # Tests
                    $moduleOnlyFiles.Name.Contains('SampleIntegrationTest.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('ExportedFunctions.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('module.name-Module.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-HelloWorld.Tests.ps1') | Should -BeExactly $true
                    $moduleOnlyFiles.Name.Contains('Get-Day.Tests.ps1') | Should -BeExactly $true
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
                        ReadtheDocs = 'NONE'
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

                    $codeBuildModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true
                    $powershellContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_powershell_windows.yml')
                    $powershellContent = Get-Content -Path $powershellContentPath -Raw
                    $powershellContent | Should -BeLike '*modulename*'
                    $linuxContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_linux.yml')
                    $linuxContent = Get-Content -Path $linuxContentPath -Raw
                    $linuxContent | Should -BeLike '*modulename*'
                    $pwshContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_windows.yml')
                    $pwshContent = Get-Content -Path $pwshContentPath -Raw
                    $pwshContent | Should -BeLike '*modulename*'

                    $codeBuildModuleFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildGit.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildpsProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshcoreProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpsProjectLogGroup*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshcoreProjectLogGroup*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshProjectLogGroup*"
                    $cfnContent | Should -BeLike "*GITHUB*"
                } #it

                It 'should generate a CodeBuild based module stored on Bitbucket with all required elements' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps', 'pwshcore', 'pwsh'
                        RepoType    = 'BITBUCKET'
                        ReadtheDocs = 'NONE'
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

                    $codeBuildModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true
                    $powershellContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_powershell_windows.yml')
                    $powershellContent = Get-Content -Path $powershellContentPath -Raw
                    $powershellContent | Should -BeLike '*modulename*'
                    $linuxContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_linux.yml')
                    $linuxContent = Get-Content -Path $linuxContentPath -Raw
                    $linuxContent | Should -BeLike '*modulename*'
                    $pwshContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_windows.yml')
                    $pwshContent = Get-Content -Path $pwshContentPath -Raw
                    $pwshContent | Should -BeLike '*modulename*'

                    $codeBuildModuleFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildGit.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildpsProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshcoreProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshProject*"
                    $cfnContent | Should -BeLike "*BITBUCKET*"
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
                        ReadtheDocs = 'NONE'
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

                    $codeBuildModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildCC.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildProjectWPS*"
                    $cfnContent | Should -BeLike "*CodeBuildProjectWPwsh*"
                    $cfnContent | Should -BeLike "*CodeBuildProjectLPwsh*"
                    $cfnContent | Should -BeLike "*CodeBuildpsProjectLogGroup*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshcoreProjectLogGroup*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshProjectLogGroup*"
                } #it

                It 'should not generate CFN if a non-supported repo type is chosen' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps', 'pwshcore', 'pwsh'
                        RepoType    = 'AZURE'
                        ReadtheDocs = 'NONE'
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

                    $codeBuildModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false

                } #it

                It 'should only generate CodeBuild projects for the project type specified for a GitHub based module' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps'
                        RepoType    = 'GITHUB'
                        ReadtheDocs = 'NONE'
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

                    $codeBuildModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $false
                    $powershellContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_powershell_windows.yml')
                    $powershellContent = Get-Content -Path $powershellContentPath -Raw
                    $powershellContent | Should -BeLike '*modulename*'

                    $codeBuildModuleFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildGit.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildpsProject*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildpwshcoreProject*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildpwshProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpsProjectLogGroup*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildpwshcoreProjectLogGroup*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildpwshProjectLogGroup*"
                    $cfnContent | Should -BeLike "*GITHUB*"
                } #it

                It 'should only generate CodeBuild projects for the project type specified for a CodeCommit based module' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps'
                        RepoType    = 'CodeCommit'
                        ReadtheDocs = 'NONE'
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

                    $codeBuildModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildModuleFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $false
                    $codeBuildModuleFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $false

                    $codeBuildModuleFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildModuleFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'

                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $true
                    $codeBuildModuleFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildCC.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildProjectWPS*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildProjectWPwsh*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildProjectLPwsh*"
                    $cfnContent | Should -BeLike "*CodeBuildpsProjectLogGroup*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildpwshcoreProjectLogGroup*"
                    $cfnContent | Should -Not -BeLike "*CodeBuildpwshProjectLogGroup*"
                } #it

            } #aws_codeBuild

            Context 'Azure Pipelines' {

                It 'should generate an Azure Pipelines based module stored on GitHub with all required elements' {
                    $moduleParameters = @{
                        VAULT        = 'text'
                        ModuleName   = 'modulename'
                        Description  = 'text'
                        Version      = '0.0.1'
                        FN           = 'user full name'
                        CICD         = 'AZURE'
                        AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType     = 'GITHUB'
                        ReadtheDocs  = 'NONE'
                        License      = 'NONE'
                        Changelog    = 'NONE'
                        COC          = 'NONE'
                        Contribute   = 'NONE'
                        Security     = 'NONE'
                        CodingStyle  = 'Stroustrup'
                        Help         = 'Yes'
                        Pester       = '5'
                        PassThru     = $true
                        NoLogo       = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $azureModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $azureModuleFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true
                    $azureModuleFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
                    $azureModuleFiles.Name.Contains('pull_request_template.md') | Should -BeExactly $false

                    $azureYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'azure-pipelines.yml')
                    $azureYMLContent = Get-Content -Path $azureYMLContentPath -Raw
                    $azureYMLContent | Should -BeLike "*build_ps_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_ubuntuLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_macOSLatest*"
                } #it

                It 'should generate an Azure Pipelines based module stored on Azure Repos with all required elements' {
                    $moduleParameters = @{
                        VAULT        = 'text'
                        ModuleName   = 'modulename'
                        Description  = 'text'
                        Version      = '0.0.1'
                        FN           = 'user full name'
                        CICD         = 'AZURE'
                        AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType     = 'AZURE'
                        ReadtheDocs  = 'NONE'
                        License      = 'NONE'
                        Changelog    = 'NONE'
                        COC          = 'NONE'
                        Contribute   = 'NONE'
                        Security     = 'NONE'
                        CodingStyle  = 'Stroustrup'
                        Help         = 'Yes'
                        Pester       = '5'
                        PassThru     = $true
                        NoLogo       = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $azureModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $azureModuleFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true
                    $azureModuleFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
                    $azureModuleFiles.Name.Contains('pull_request_template.md') | Should -BeExactly $true

                    $azureYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'azure-pipelines.yml')
                    $azureYMLContent = Get-Content -Path $azureYMLContentPath -Raw
                    $azureYMLContent | Should -BeLike "*build_ps_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_ubuntuLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_macOSLatest*"
                } #it

                It 'should generate an Azure Pipelines based module stored on Bitbucket Repos with all required elements' {
                    $moduleParameters = @{
                        VAULT        = 'text'
                        ModuleName   = 'modulename'
                        Description  = 'text'
                        Version      = '0.0.1'
                        FN           = 'user full name'
                        CICD         = 'AZURE'
                        AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType     = 'BITBUCKET'
                        ReadtheDocs  = 'NONE'
                        License      = 'NONE'
                        Changelog    = 'NONE'
                        COC          = 'NONE'
                        Contribute   = 'NONE'
                        Security     = 'NONE'
                        CodingStyle  = 'Stroustrup'
                        Help         = 'Yes'
                        Pester       = '5'
                        PassThru     = $true
                        NoLogo       = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $azureModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $azureModuleFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true
                    $azureModuleFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
                    $azureModuleFiles.Name.Contains('pull_request_template.md') | Should -BeExactly $false

                    $azureYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'azure-pipelines.yml')
                    $azureYMLContent = Get-Content -Path $azureYMLContentPath -Raw
                    $azureYMLContent | Should -BeLike "*build_ps_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_ubuntuLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_macOSLatest*"
                } #it

            } #azure_pipelines

            Context 'Appveyor Build' {

                It 'should generate an Appveyor based module stored on GitHub with all required elements' {
                    $moduleParameters = @{
                        VAULT           = 'text'
                        ModuleName      = 'modulename'
                        Description     = 'text'
                        Version         = '0.0.1'
                        FN              = 'user full name'
                        CICD            = 'APPVEYOR'
                        AppveyorOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType        = 'GITHUB'
                        ReadtheDocs     = 'NONE'
                        License         = 'NONE'
                        Changelog       = 'NONE'
                        COC             = 'NONE'
                        Contribute      = 'NONE'
                        Security        = 'NONE'
                        CodingStyle     = 'Stroustrup'
                        Help            = 'Yes'
                        Pester          = '5'
                        PassThru        = $true
                        NoLogo          = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $appveyorModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $appveyorModuleFiles.Name.Contains('appveyor.yml') | Should -BeExactly $true
                    $appveyorModuleFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true

                    $appveyorYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'appveyor.yml')
                    $appveyorYMLContent = Get-Content -Path $appveyorYMLContentPath -Raw
                    $appveyorYMLContent | Should -BeLike "*Visual Studio 2019*"
                    $appveyorYMLContent | Should -BeLike "*Visual Studio 2022*"
                    $appveyorYMLContent | Should -BeLike "*Ubuntu2004*"
                    $appveyorYMLContent | Should -BeLike "*macOS*"
                } #it

            } #appveyor

            Context 'GitHub Actions' {

                It 'should generate a GitHub Actions based module stored on GitHub with all required elements' {
                    $moduleParameters = @{
                        VAULT          = 'text'
                        ModuleName     = 'modulename'
                        Description    = 'text'
                        Version        = '0.0.1'
                        FN             = 'user full name'
                        CICD           = 'GITHUB'
                        GitHubAOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType       = 'GITHUB'
                        ReadtheDocs    = 'NONE'
                        License        = 'NONE'
                        Changelog      = 'NONE'
                        COC            = 'NONE'
                        Contribute     = 'NONE'
                        Security       = 'NONE'
                        CodingStyle    = 'Stroustrup'
                        Help           = 'Yes'
                        Pester         = '5'
                        PassThru       = $true
                        NoLogo         = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $ghaModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $ghaModuleFiles.Name.Contains('wf_Linux.yml') | Should -BeExactly $true
                    $ghaModuleFiles.Name.Contains('wf_MacOS.yml') | Should -BeExactly $true
                    $ghaModuleFiles.Name.Contains('wf_Windows_Core.yml') | Should -BeExactly $true
                    $ghaModuleFiles.Name.Contains('wf_Windows.yml') | Should -BeExactly $true

                    $wfLinuxContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_Linux.yml')
                    $wfLinuxContent = Get-Content -Path $wfLinuxContentPath -Raw
                    $wfLinuxContent | Should -BeLike '*modulename*'

                    $wfMacOSContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_MacOS.yml')
                    $wfMacOSContent = Get-Content -Path $wfMacOSContentPath -Raw
                    $wfMacOSContent | Should -BeLike '*modulename*'

                    $wfWindowsCoreContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_Windows_Core.yml')
                    $wfWindowsCoreContent = Get-Content -Path $wfWindowsCoreContentPath -Raw
                    $wfWindowsCoreContent | Should -BeLike '*modulename*'

                    $wfWindowsContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_Windows.yml')
                    $wfWindowsContent = Get-Content -Path $wfWindowsContentPath -Raw
                    $wfWindowsContent | Should -BeLike '*modulename*'

                } #it

            } #github_actions

            Context 'Bitbucket Build' {

                It 'should generate a Bitbucket based module stored on Bitbucket with all required elements' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'BITBUCKET'
                        RepoType    = 'BITBUCKET'
                        ReadtheDocs = 'NONE'
                        License     = 'NONE'
                        Changelog   = 'NONE'
                        COC         = 'NONE'
                        Contribute  = 'NONE'
                        Security    = 'NONE'
                        CodingStyle = 'Stroustrup'
                        Help        = 'Yes'
                        Pester      = '5'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $bitbucketModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $bitbucketModuleFiles.Name.Contains('bitbucket-pipelines.yml') | Should -BeExactly $true
                    $bitbucketModuleFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true

                    $bitbucketYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'bitbucket-pipelines.yml')
                    $bitbucketYMLContent = Get-Content -Path $bitbucketYMLContentPath -Raw
                    $bitbucketYMLContent | Should -BeLike '*modulename*'
                } #it

            } #bitbucket

            Context 'GitLab Build' {

                It 'should generate a GitLab based module stored on GitLab with all required elements' {
                    $moduleParameters = @{
                        VAULT         = 'text'
                        ModuleName    = 'modulename'
                        Description   = 'text'
                        Version       = '0.0.1'
                        FN            = 'user full name'
                        CICD          = 'GITLAB'
                        GitLabOptions = 'windows', 'pwshcore', 'linux'
                        RepoType      = 'GITLAB'
                        ReadtheDocs   = 'NONE'
                        License       = 'NONE'
                        Changelog     = 'NONE'
                        COC           = 'NONE'
                        Contribute    = 'NONE'
                        Security      = 'NONE'
                        CodingStyle   = 'Stroustrup'
                        Help          = 'Yes'
                        Pester        = '5'
                        PassThru      = $true
                        NoLogo        = $true
                    }
                    $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $gitlabModuleFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $gitlabModuleFiles.Name.Contains('.gitlab-ci.yml') | Should -BeExactly $true
                    $gitlabModuleFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true

                    $gitlabYMLContentPath = [System.IO.Path]::Combine($outPutPath, '.gitlab-ci.yml')
                    $gitlabYMLContent = Get-Content -Path $gitlabYMLContentPath -Raw
                    $gitlabYMLContent | Should -BeLike '*modulename*'
                    $gitlabYMLContent | Should -BeLike '*windows_powershell_job*'
                    $gitlabYMLContent | Should -BeLike '*windows_pwsh_job*'
                    $gitlabYMLContent | Should -BeLike '*linux_pwsh_job*'
                } #it

            } #gitlab

        } #context_cicd

        Context 'Repo Checks' {

            Context 'CodeCommit' {

                It 'should generate the appropriate repo files for CodeCommit' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'CODECOMMIT'
                        ReadtheDocs = 'NONE'
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

                    $repoFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    # REPO
                    $repoFiles.Name.Contains('.gitignore') | Should -BeExactly $true
                    $repoFiles.Name.Contains('README.md') | Should -BeExactly $true
                    $readmeContentPath = [System.IO.Path]::Combine($outPutPath, 'README.md')
                    $readmeContent = Get-Content -Path $readmeContentPath -Raw
                    $readmeContent | Should -BeLike '*modulename*'

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
                        ReadtheDocs = 'NONE'
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

                    $repoFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    # LICENSE
                    $repoFiles.Name.Contains('LICENSE') | Should -BeExactly $true
                    $licenseContentPath = [System.IO.Path]::Combine($outPutPath, 'LICENSE')
                    $licenseContent = Get-Content -Path $licenseContentPath -Raw
                    $licenseContent | Should -BeLike '*mit*'

                    # REPO
                    $repoFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $true
                    $changelogContentPath = [System.IO.Path]::Combine($outPutPath, 'docs', 'CHANGELOG.md')
                    $changelogContent = Get-Content -Path $changelogContentPath -Raw
                    $changelogContent | Should -BeLike '*0.0.1*'
                    $repoFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $true
                    $contributingContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'CONTRIBUTING.md')
                    $contributingContent = Get-Content -Path $contributingContentPath -Raw
                    $contributingContent | Should -BeLike '*modulename*'
                    $repoFiles.Name.Contains('SECURITY.md') | Should -BeExactly $true
                    $securityContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'SECURITY.md')
                    $securityContent = Get-Content -Path $securityContentPath -Raw
                    $securityContent | Should -BeLike '*modulename*'
                    $repoFiles.Name.Contains('.gitignore') | Should -BeExactly $true
                    $repoFiles.Name.Contains('README.md') | Should -BeExactly $true
                    $readmeContentPath = [System.IO.Path]::Combine($outPutPath, 'README.md')
                    $readmeContent = Get-Content -Path $readmeContentPath -Raw
                    $readmeContent | Should -BeLike '*modulename*'
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

            Context 'GitLab' {

                It 'should generate the appropriate repo files for GitLab' {
                    $moduleParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'modulename'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'GITLAB'
                        ReadtheDocs = 'NONE'
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

                    $repoFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    # LICENSE
                    $repoFiles.Name.Contains('LICENSE') | Should -BeExactly $true
                    $licenseContentPath = [System.IO.Path]::Combine($outPutPath, 'LICENSE')
                    $licenseContent = Get-Content -Path $licenseContentPath -Raw
                    $licenseContent | Should -BeLike '*mit*'

                    # REPO
                    $repoFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $true
                    $changelogContentPath = [System.IO.Path]::Combine($outPutPath, 'docs', 'CHANGELOG.md')
                    $changelogContent = Get-Content -Path $changelogContentPath -Raw
                    $changelogContent | Should -BeLike '*0.0.1*'
                    $repoFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $true
                    $contributingContentPath = [System.IO.Path]::Combine($outPutPath, 'CONTRIBUTING.md')
                    $contributingContent = Get-Content -Path $contributingContentPath -Raw
                    $contributingContent | Should -BeLike '*modulename*'
                    $repoFiles.Name.Contains('SECURITY.md') | Should -BeExactly $true
                    $securityContentPath = [System.IO.Path]::Combine($outPutPath, 'SECURITY.md')
                    $securityContent = Get-Content -Path $securityContentPath -Raw
                    $securityContent | Should -BeLike '*modulename*'
                    $repoFiles.Name.Contains('.gitignore') | Should -BeExactly $true
                    $repoFiles.Name.Contains('README.md') | Should -BeExactly $true
                    $readmeContentPath = [System.IO.Path]::Combine($outPutPath, 'README.md')
                    $readmeContent = Get-Content -Path $readmeContentPath -Raw
                    $readmeContent | Should -BeLike '*modulename*'
                    $repoFiles.Name.Contains('Default.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('bug-report.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('feature-request.md') | Should -BeExactly $true

                    $dotGitLabFiles = @(
                        'Default.md'
                        'bug-report.md'
                        'feature-request.md'
                    )
                    $docFiles = @(
                        'CHANGELOG.md'
                    )
                    foreach ($file in $dotGitLabFiles) {
                    ($repoFiles | Where-Object { $_.name -eq $file }).Directory | Should -BeLike '*.gitlab*'
                    }
                    foreach ($file in $docFiles) {
                    ($repoFiles | Where-Object { $_.name -eq $file }).Directory | Should -BeLike '*docs*'
                    }

                } #it

            } #context_gitlab

        } #context_repo

        Context 'Read the Docs' {

            It 'should generate the appropriate files for the standard readthedocs theme' {
                $moduleParameters = @{
                    VAULT       = 'text'
                    ModuleName  = 'modulename'
                    Description = 'text'
                    Version     = '0.0.1'
                    FN          = 'user full name'
                    CICD        = 'NONE'
                    RepoType    = 'GITHUB'
                    ReadtheDocs = 'READTHEDOCS'
                    RTDTheme    = 'READTHEDOCSTHEME'
                    License     = 'NONE'
                    Changelog   = 'NONE'
                    COC         = 'NONE'
                    Contribute  = 'NONE'
                    Security    = 'NONE'
                    CodingStyle = 'Stroustrup'
                    Help        = 'Yes'
                    Pester      = '5'
                    S3Bucket    = 'PSGallery'
                    PassThru    = $true
                    NoLogo      = $true
                }
                $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                $eval | Should -Not -BeNullOrEmpty

                $rtdFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                # read the docs
                $rtdFiles.Name.Contains('mkdocs.yml') | Should -BeExactly $true
                $rtdFiles.Name.Contains('requirements.txt') | Should -BeExactly $true
                $rtdFiles.Name.Contains('.readthedocs.yaml') | Should -BeExactly $true
                $rtdFiles.Name.Contains('index.md') | Should -BeExactly $true

                $mkdocsContentPath = [System.IO.Path]::Combine($outPutPath, 'mkdocs.yml')
                $mkdocsContent = Get-Content -Path $mkdocsContentPath -Raw
                $mkdocsContent | Should -Not -BeLike '*material*'
                $mkdocsContent | Should -BeLike '*modulename*'

                $reqContentPath = [System.IO.Path]::Combine($outPutPath, 'docs', 'requirements.txt')
                $reqContent = Get-Content -Path $reqContentPath -Raw
                $reqContent | Should -Not -BeLike '*material*'

            } #it

            It 'should generate the appropriate files for the material theme' {
                $moduleParameters = @{
                    VAULT       = 'text'
                    ModuleName  = 'modulename'
                    Description = 'text'
                    Version     = '0.0.1'
                    FN          = 'user full name'
                    CICD        = 'NONE'
                    RepoType    = 'GITHUB'
                    ReadtheDocs = 'READTHEDOCS'
                    RTDTheme    = 'MATERIALTHEME'
                    License     = 'NONE'
                    Changelog   = 'NONE'
                    COC         = 'NONE'
                    Contribute  = 'NONE'
                    Security    = 'NONE'
                    CodingStyle = 'Stroustrup'
                    Help        = 'Yes'
                    Pester      = '5'
                    S3Bucket    = 'PSGallery'
                    PassThru    = $true
                    NoLogo      = $true
                }
                $eval = New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
                $eval | Should -Not -BeNullOrEmpty

                $rtdFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                # read the docs
                $rtdFiles.Name.Contains('mkdocs.yml') | Should -BeExactly $true
                $rtdFiles.Name.Contains('requirements.txt') | Should -BeExactly $true
                $rtdFiles.Name.Contains('.readthedocs.yaml') | Should -BeExactly $true
                $rtdFiles.Name.Contains('index.md') | Should -BeExactly $true

                $mkdocsContentPath = [System.IO.Path]::Combine($outPutPath, 'mkdocs.yml')
                $mkdocsContent = Get-Content -Path $mkdocsContentPath -Raw
                $mkdocsContent | Should -BeLike '*material*'

                $reqContentPath = [System.IO.Path]::Combine($outPutPath, 'docs', 'requirements.txt')
                $reqContent = Get-Content -Path $reqContentPath -Raw
                $reqContent | Should -BeLike '*material*'

            } #it

        } #context_readthedocs

        Context 'Help Examples' {

            It 'should have a working example for vanilla module' {
                $moduleParameters = @{
                    ModuleName  = 'ModuleName'
                    Description = 'My awesome module is awesome'
                    Version     = '0.0.1'
                    FN          = 'user full name'
                    CICD        = 'NONE'
                    RepoType    = 'NONE'
                    CodingStyle = 'Stroustrup'
                    Help        = 'Yes'
                    Pester      = '5'
                    NoLogo      = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'ModuleName', 'ModuleName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome module is awesome*'
            } #it

            It 'should have a working example for GitHub Actions module' {
                $moduleParameters = @{
                    ModuleName     = 'ModuleName'
                    Description    = 'My awesome module is awesome'
                    Version        = '0.0.1'
                    FN             = 'user full name'
                    CICD           = 'GITHUB'
                    GitHubAOptions = 'windows', 'pwshcore', 'linux', 'macos'
                    RepoType       = 'GITHUB'
                    ReadtheDocs    = 'READTHEDOCS'
                    RTDTheme       = 'READTHEDOCSTHEME'
                    License        = 'MIT'
                    Changelog      = 'CHANGELOG'
                    COC            = 'CONDUCT'
                    Contribute     = 'CONTRIBUTING'
                    Security       = 'SECURITY'
                    CodingStyle    = 'Stroustrup'
                    Help           = 'Yes'
                    Pester         = '5'
                    S3Bucket       = 'PSGallery'
                    NoLogo         = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'ModuleName', 'ModuleName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome module is awesome*'
            } #it

            It 'should have a working example for AWS module' {
                $moduleParameters = @{
                    ModuleName  = 'ModuleName'
                    Description = 'My awesome module is awesome'
                    Version     = '0.0.1'
                    FN          = 'user full name'
                    CICD        = 'CODEBUILD'
                    AWSOptions  = 'ps', 'pwshcore', 'pwsh'
                    RepoType    = 'GITHUB'
                    ReadtheDocs = 'NONE'
                    License     = 'MIT'
                    Changelog   = 'CHANGELOG'
                    COC         = 'CONDUCT'
                    Contribute  = 'CONTRIBUTING'
                    Security    = 'SECURITY'
                    CodingStyle = 'Stroustrup'
                    Help        = 'Yes'
                    Pester      = '5'
                    S3Bucket    = 'PSGallery'
                    NoLogo      = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'ModuleName', 'ModuleName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome module is awesome*'
            } #it

            It 'should have a working example for Azure module' {
                $moduleParameters = @{
                    ModuleName   = 'ModuleName'
                    Description  = 'My awesome module is awesome'
                    Version      = '0.0.1'
                    FN           = 'user full name'
                    CICD         = 'AZURE'
                    AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                    RepoType     = 'GITHUB'
                    ReadtheDocs  = 'NONE'
                    License      = 'NONE'
                    Changelog    = 'NONE'
                    COC          = 'NONE'
                    Contribute   = 'NONE'
                    Security     = 'NONE'
                    CodingStyle  = 'Stroustrup'
                    Help         = 'Yes'
                    Pester       = '5'
                    NoLogo       = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'ModuleName', 'ModuleName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome module is awesome*'
            } #it

            It 'should have a working example for Appveyor module' {
                $moduleParameters = @{
                    ModuleName      = 'ModuleName'
                    Description     = 'My awesome module is awesome'
                    Version         = '0.0.1'
                    FN              = 'user full name'
                    CICD            = 'APPVEYOR'
                    AppveyorOptions = 'windows', 'pwshcore', 'linux', 'macos'
                    RepoType        = 'GITHUB'
                    ReadtheDocs     = 'NONE'
                    License         = 'NONE'
                    Changelog       = 'NONE'
                    COC             = 'NONE'
                    Contribute      = 'NONE'
                    Security        = 'NONE'
                    CodingStyle     = 'Stroustrup'
                    Help            = 'Yes'
                    Pester          = '5'
                    PassThru        = $true
                    NoLogo          = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'ModuleName', 'ModuleName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome module is awesome*'
            } #it

            It 'should have a working example for Bitbucket module' {
                $moduleParameters = @{
                    ModuleName  = 'ModuleName'
                    Description = 'My awesome module is awesome'
                    Version     = '0.0.1'
                    FN          = 'user full name'
                    CICD        = 'BITBUCKET'
                    RepoType    = 'BITBUCKET'
                    ReadtheDocs = 'NONE'
                    License     = 'NONE'
                    Changelog   = 'CHANGELOG'
                    COC         = 'CONDUCT'
                    Contribute  = 'CONTRIBUTING'
                    Security    = 'SECURITY'
                    CodingStyle = 'Stroustrup'
                    Help        = 'Yes'
                    Pester      = '5'
                    PassThru    = $true
                    NoLogo      = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'ModuleName', 'ModuleName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome module is awesome*'
            } #it

            It 'should have a working example for GitLab module' {
                $moduleParameters = @{
                    ModuleName    = 'ModuleName'
                    Description   = 'My awesome module is awesome'
                    Version       = '0.0.1'
                    FN            = 'user full name'
                    CICD          = 'GITLAB'
                    RepoType      = 'GITLAB'
                    ReadtheDocs   = 'READTHEDOCS'
                    RTDTheme      = 'READTHEDOCSTHEME'
                    GitLabOptions = 'windows', 'pwshcore', 'linux'
                    License       = 'MIT'
                    Changelog     = 'CHANGELOG'
                    COC           = 'CONDUCT'
                    Contribute    = 'CONTRIBUTING'
                    Security      = 'SECURITY'
                    CodingStyle   = 'Stroustrup'
                    Help          = 'Yes'
                    Pester        = '5'
                    PassThru      = $true
                    NoLogo        = $true
                }
                New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'ModuleName', 'ModuleName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome module is awesome*'
            } #it

        } #context_help_examples

    } #context_module_checks

} #describe_module_tests
