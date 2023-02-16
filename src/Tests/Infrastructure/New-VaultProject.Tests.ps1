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
Describe 'Vault Infra Tests' {

    BeforeAll {
        $WarningPreference = 'Continue'
        Set-Location -Path $PSScriptRoot
        $ModuleName = 'Catesta'
        # $resourcePath = [System.IO.Path]::Combine( '..', '..', $ModuleName, 'Resources')
        # $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
        # $srcRoot = [System.IO.Path]::Combine( '..', '..')
        $outPutPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'catesta_infra_testing')
        $outPutPathStar = "$outPutPath$([System.IO.Path]::DirectorySeparatorChar)*"
        $buildFile = [System.IO.Path]::Combine($outPutPath, 'src', 'SecretManagement.MyVault.build.ps1')
        New-Item -Path $outPutPath -ItemType Directory  -ErrorAction SilentlyContinue
    } #beforeAll

    Context 'Vault Checks' {

        BeforeEach {
            Remove-Item -Path $outPutPathStar -Recurse -Force
            # $codeBuildVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force
        } #beforeEach
        # BeforeAll {
        #     Remove-Item -Path $outPutPathStar -Recurse -Force
        # }

        Context 'CI/CD' {

            Context 'Vault Only' {

                It 'should generate a vault only scaffold with base elements' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'NONE'
                        CodingStyle = 'Stroustrup'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $vaultOnlyFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $vaultOnlyFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $false

                    # VAULT
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault.psd1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault.psm1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault.Extension.psd1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault.Extension.psm1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault.build.ps1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault.Settings.ps1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('PSScriptAnalyzerSettings.psd1') | Should -BeExactly $true

                    # Module - not present
                    $vaultOnlyFiles.Name.Contains('Get-HelloWorld.ps1') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('Get-Day.ps1') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('Imports.ps1') | Should -BeExactly $false

                    # Tests
                    $vaultOnlyFiles.Name.Contains('ExportedFunctions.Tests.ps1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault-Module.Tests.ps1') | Should -BeExactly $true
                    $vaultOnlyFiles.Name.Contains('SecretManagement.MyVault-Function.Tests.ps1') | Should -BeExactly $true

                    # LICENSE
                    $vaultOnlyFiles.Name.Contains('GNULICENSE') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('ISCLICENSE') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('MITLICENSE') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('APACHELICENSE') | Should -BeExactly $false

                    # REPO
                    $vaultOnlyFiles.Name.Contains('CHANGELOG.md') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('CODE_OF_CONDUCT.md') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('CONTRIBUTING.md') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('SECURITY.md') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('.gitignore') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('PULL_REQUEST_TEMPLATE.md') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('bug-report.md') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('feature_request.md') | Should -BeExactly $false

                    # AWS
                    $vaultOnlyFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $false

                    $vaultOnlyFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false

                    # GitHub
                    $vaultOnlyFiles.Name.Contains('wf_Linux.yml') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('wf_MacOS.yml') | Should -BeExactly $false
                    $vaultOnlyFiles.Name.Contains('wf_Windows.yml') | Should -BeExactly $false

                    # Azure
                    $vaultOnlyFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $false

                    # AppVeyor
                    $vaultOnlyFiles.Name.Contains('appveyor.yml') | Should -BeExactly $false

                    $buildContent = Get-Content -Path $buildFile -Raw

                    # Styling
                    $buildContent | Should -BeLike '*Stroustrup*'

                    # Pester
                    $buildContent | Should -BeLike '*5.2.2*'

                    # Help
                    $buildContent | Should -Not -BeLike '*CreateHelpStart*'

                } #it

            } #context_vault_only

            Context 'AWS-CodeBuild' {

                It 'should generate a CodeBuild based vault project stored on GitHub with all required elements' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
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
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $codeBuildVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildVaultFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true
                    $powershellContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_powershell_windows.yml')
                    $powershellContent = Get-Content -Path $powershellContentPath -Raw
                    $powershellContent | Should -BeLike '*SecretManagement.MyVault*'
                    $linuxContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_linux.yml')
                    $linuxContent = Get-Content -Path $linuxContentPath -Raw
                    $linuxContent | Should -BeLike '*SecretManagement.MyVault*'
                    $pwshContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_windows.yml')
                    $pwshContent = Get-Content -Path $pwshContentPath -Raw
                    $pwshContent | Should -BeLike '*SecretManagement.MyVault*'

                    $codeBuildVaultFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildVaultFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildGit.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildpsProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshcoreProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshProject*"
                    $cfnContent | Should -BeLike "*GITHUB*"
                } #it

                It 'should generate a CodeBuild based vault project stored on Bitbucket with all required elements' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps', 'pwshcore', 'pwsh'
                        RepoType    = 'BITBUCKET'
                        License     = 'MIT'
                        Changelog   = 'CHANGELOG'
                        COC         = 'CONDUCT'
                        Contribute  = 'CONTRIBUTING'
                        Security    = 'SECURITY'
                        CodingStyle = 'Stroustrup'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $codeBuildVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildVaultFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true
                    $powershellContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_powershell_windows.yml')
                    $powershellContent = Get-Content -Path $powershellContentPath -Raw
                    $powershellContent | Should -BeLike '*SecretManagement.MyVault*'
                    $linuxContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_linux.yml')
                    $linuxContent = Get-Content -Path $linuxContentPath -Raw
                    $linuxContent | Should -BeLike '*SecretManagement.MyVault*'
                    $pwshContentPath = [System.IO.Path]::Combine($outPutPath, 'buildspec_pwsh_windows.yml')
                    $pwshContent = Get-Content -Path $pwshContentPath -Raw
                    $pwshContent | Should -BeLike '*SecretManagement.MyVault*'

                    $codeBuildVaultFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildVaultFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $true

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildGit.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildpsProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshcoreProject*"
                    $cfnContent | Should -BeLike "*CodeBuildpwshProject*"
                    $cfnContent | Should -BeLike "*BITBUCKET*"
                } #it

                It 'should generate a CodeBuild based vault project stored on CodeCommit with all required elements' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
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
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $codeBuildVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildVaultFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true

                    $codeBuildVaultFiles.Name.Contains('configure_aws_credential.ps1') | Should -BeExactly $true

                    $codeBuildVaultFiles.Name.Contains('install_modules.ps1') | Should -BeExactly $true
                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'install_modules.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*$galleryDownload = $true*'
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false

                    $cfnContentPath = [System.IO.Path]::Combine($outPutPath, 'CloudFormation', 'PowerShellCodeBuildCC.yml')
                    $cfnContent = Get-Content -Path $cfnContentPath -Raw
                    $cfnContent | Should -BeLike "*CodeBuildProjectWPS*"
                    $cfnContent | Should -BeLike "*CodeBuildProjectWPwsh*"
                    $cfnContent | Should -BeLike "*CodeBuildProjectLPwsh*"
                } #it

                It 'should not generate CFN if a non-supported repo type is chosen' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'CODEBUILD'
                        AWSOptions  = 'ps', 'pwshcore', 'pwsh'
                        RepoType    = 'AZURE'
                        License     = 'MIT'
                        Changelog   = 'CHANGELOG'
                        COC         = 'CONDUCT'
                        Contribute  = 'CONTRIBUTING'
                        Security    = 'SECURITY'
                        CodingStyle = 'Stroustrup'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $codeBuildVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $codeBuildVaultFiles.Name.Contains('buildspec_powershell_windows.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_linux.yml') | Should -BeExactly $true
                    $codeBuildVaultFiles.Name.Contains('buildspec_pwsh_windows.yml') | Should -BeExactly $true

                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildCC.yml') | Should -BeExactly $false
                    $codeBuildVaultFiles.Name.Contains('PowerShellCodeBuildGit.yml') | Should -BeExactly $false
                } #it

            } #aws_codeBuild

            Context 'Azure Pipelines' {

                It 'should generate an Azure Pipelines based vault project stored on GitHub with all required elements' {
                    $vaultParameters = @{
                        VAULT        = 'text'
                        ModuleName   = 'SecretManagement.MyVault'
                        Description  = 'text'
                        Version      = '0.0.1'
                        FN           = 'user full name'
                        CICD         = 'AZURE'
                        AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType     = 'GITHUB'
                        License      = 'None'
                        Changelog    = 'NOCHANGELOG'
                        COC          = 'NOCONDUCT'
                        Contribute   = 'NOCONTRIBUTING'
                        Security     = 'NOSECURITY'
                        CodingStyle  = 'Stroustrup'
                        Pester       = '5'
                        PassThru     = $true
                        NoLogo       = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $azureVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $azureVaultFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true
                    $azureVaultFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
                    $azureVaultFiles.Name.Contains('pull_request_template.md') | Should -BeExactly $false

                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'actions_bootstrap.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $azureYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'azure-pipelines.yml')
                    $azureYMLContent = Get-Content -Path $azureYMLContentPath -Raw
                    $azureYMLContent | Should -BeLike "*build_ps_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_ubuntuLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_macOSLatest*"
                } #it

                It 'should generate an Azure Pipelines based vault project stored on Azure Repos with all required elements' {
                    $vaultParameters = @{
                        VAULT        = 'text'
                        ModuleName   = 'SecretManagement.MyVault'
                        Description  = 'text'
                        Version      = '0.0.1'
                        FN           = 'user full name'
                        CICD         = 'AZURE'
                        AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType     = 'AZURE'
                        License      = 'None'
                        Changelog    = 'NOCHANGELOG'
                        COC          = 'NOCONDUCT'
                        Contribute   = 'NOCONTRIBUTING'
                        Security     = 'NOSECURITY'
                        CodingStyle  = 'Stroustrup'
                        Pester       = '5'
                        PassThru     = $true
                        NoLogo       = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $azureVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $azureVaultFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true
                    $azureVaultFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
                    $azureVaultFiles.Name.Contains('pull_request_template.md') | Should -BeExactly $true

                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'actions_bootstrap.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $azureYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'azure-pipelines.yml')
                    $azureYMLContent = Get-Content -Path $azureYMLContentPath -Raw
                    $azureYMLContent | Should -BeLike "*build_ps_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_ubuntuLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_macOSLatest*"
                } #it

                It 'should generate an Azure Pipelines based vault project stored on Bitbucket with all required elements' {
                    $vaultParameters = @{
                        VAULT        = 'text'
                        ModuleName   = 'SecretManagement.MyVault'
                        Description  = 'text'
                        Version      = '0.0.1'
                        FN           = 'user full name'
                        CICD         = 'AZURE'
                        AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType     = 'BITBUCKET'
                        License      = 'None'
                        Changelog    = 'NOCHANGELOG'
                        COC          = 'NOCONDUCT'
                        Contribute   = 'NOCONTRIBUTING'
                        Security     = 'NOSECURITY'
                        CodingStyle  = 'Stroustrup'
                        Pester       = '5'
                        PassThru     = $true
                        NoLogo       = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $azureVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $azureVaultFiles.Name.Contains('azure-pipelines.yml') | Should -BeExactly $true
                    $azureVaultFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true
                    $azureVaultFiles.Name.Contains('pull_request_template.md') | Should -BeExactly $false

                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'actions_bootstrap.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $azureYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'azure-pipelines.yml')
                    $azureYMLContent = Get-Content -Path $azureYMLContentPath -Raw
                    $azureYMLContent | Should -BeLike "*build_ps_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_WinLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_ubuntuLatest*"
                    $azureYMLContent | Should -BeLike "*build_pwsh_macOSLatest*"
                } #it

            } #azure_pipelines

            Context 'Appveyor Build' {

                It 'should generate an Appveyor based vault project stored on GitHub with all required elements' {
                    $vaultParameters = @{
                        VAULT           = 'text'
                        ModuleName      = 'SecretManagement.MyVault'
                        Description     = 'text'
                        Version         = '0.0.1'
                        FN              = 'user full name'
                        CICD            = 'APPVEYOR'
                        AppveyorOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType        = 'GITHUB'
                        License         = 'None'
                        Changelog       = 'NOCHANGELOG'
                        COC             = 'NOCONDUCT'
                        Contribute      = 'NOCONTRIBUTING'
                        Security        = 'NOSECURITY'
                        CodingStyle     = 'Stroustrup'
                        Pester          = '5'
                        PassThru        = $true
                        NoLogo          = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $appveyorVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $appveyorVaultFiles.Name.Contains('appveyor.yml') | Should -BeExactly $true
                    $appveyorVaultFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true

                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'actions_bootstrap.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $appveyorYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'appveyor.yml')
                    $appveyorYMLContent = Get-Content -Path $appveyorYMLContentPath -Raw
                    $appveyorYMLContent | Should -BeLike "*Visual Studio 2019*"
                    $appveyorYMLContent | Should -BeLike "*Visual Studio 2022*"
                    $appveyorYMLContent | Should -BeLike "*Ubuntu2004*"
                    $appveyorYMLContent | Should -BeLike "*macOS*"
                } #it

            } #appveyor

            Context 'GitHub Actions' {

                It 'should generate a GitHub Actions based vault project stored on GitHub with all required elements' {
                    $vaultParameters = @{
                        VAULT          = 'text'
                        ModuleName     = 'SecretManagement.MyVault'
                        Description    = 'text'
                        Version        = '0.0.1'
                        FN             = 'user full name'
                        CICD           = 'GITHUB'
                        GitHubAOptions = 'windows', 'pwshcore', 'linux', 'macos'
                        RepoType       = 'GITHUB'
                        License        = 'None'
                        Changelog      = 'NOCHANGELOG'
                        COC            = 'NOCONDUCT'
                        Contribute     = 'NOCONTRIBUTING'
                        Security       = 'NOSECURITY'
                        CodingStyle    = 'Stroustrup'
                        Pester         = '5'
                        PassThru       = $true
                        NoLogo         = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $ghaVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $ghaVaultFiles.Name.Contains('wf_Linux.yml') | Should -BeExactly $true
                    $ghaVaultFiles.Name.Contains('wf_MacOS.yml') | Should -BeExactly $true
                    $ghaVaultFiles.Name.Contains('wf_Windows_Core.yml') | Should -BeExactly $true
                    $ghaVaultFiles.Name.Contains('wf_Windows.yml') | Should -BeExactly $true

                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'actions_bootstrap.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $wfLinuxContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_Linux.yml')
                    $wfLinuxContent = Get-Content -Path $wfLinuxContentPath -Raw
                    $wfLinuxContent | Should -BeLike '*SecretManagement.MyVault*'

                    $wfMacOSContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_MacOS.yml')
                    $wfMacOSContent = Get-Content -Path $wfMacOSContentPath -Raw
                    $wfMacOSContent | Should -BeLike '*SecretManagement.MyVault*'

                    $wfWindowsCoreContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_Windows_Core.yml')
                    $wfWindowsCoreContent = Get-Content -Path $wfWindowsCoreContentPath -Raw
                    $wfWindowsCoreContent | Should -BeLike '*SecretManagement.MyVault*'

                    $wfWindowsContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'workflows', 'wf_Windows.yml')
                    $wfWindowsContent = Get-Content -Path $wfWindowsContentPath -Raw
                    $wfWindowsContent | Should -BeLike '*SecretManagement.MyVault*'

                } #it

            } #github_actions

            Context 'Bitbucket Build' {

                It 'should generate a Bitbucket based vault project stored on Bitbucket with all required elements' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'BITBUCKET'
                        RepoType    = 'BITBUCKET'
                        License     = 'None'
                        Changelog   = 'NOCHANGELOG'
                        COC         = 'NOCONDUCT'
                        Contribute  = 'NOCONTRIBUTING'
                        Security    = 'NOSECURITY'
                        CodingStyle = 'Stroustrup'
                        Pester      = '5'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $bitbucketVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $bitbucketVaultFiles.Name.Contains('bitbucket-pipelines.yml') | Should -BeExactly $true
                    $bitbucketVaultFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true

                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'actions_bootstrap.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $bitbucketYMLContentPath = [System.IO.Path]::Combine($outPutPath, 'bitbucket-pipelines.yml')
                    $bitbucketYMLContent = Get-Content -Path $bitbucketYMLContentPath -Raw
                    $bitbucketYMLContent | Should -BeLike '*SecretManagement.MyVault*'
                } #it

            } #bitbucket

            Context 'GitLab Build' {

                It 'should generate a GitLab based vault project stored on GitLab with all required elements' {
                    $vaultParameters = @{
                        VAULT         = 'text'
                        ModuleName    = 'SecretManagement.MyVault'
                        Description   = 'text'
                        Version       = '0.0.1'
                        FN            = 'user full name'
                        CICD          = 'GITLAB'
                        GitLabOptions = 'windows', 'pwshcore', 'linux'
                        RepoType      = 'GITLAB'
                        License       = 'None'
                        Changelog     = 'NOCHANGELOG'
                        COC           = 'NOCONDUCT'
                        Contribute    = 'NOCONTRIBUTING'
                        Security      = 'NOSECURITY'
                        CodingStyle   = 'Stroustrup'
                        Pester        = '5'
                        PassThru      = $true
                        NoLogo        = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $gitlabVaultFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

                    $gitlabVaultFiles.Name.Contains('.gitlab-ci.yml') | Should -BeExactly $true
                    $gitlabVaultFiles.Name.Contains('actions_bootstrap.ps1') | Should -BeExactly $true

                    $installContentPath = [System.IO.Path]::Combine($outPutPath, 'actions_bootstrap.ps1')
                    $installContent = Get-Content -Path $installContentPath -Raw
                    $installContent | Should -BeLike '*Microsoft.PowerShell.SecretManagement*'

                    $gitlabYMLContentPath = [System.IO.Path]::Combine($outPutPath, '.gitlab-ci.yml')
                    $gitlabYMLContent = Get-Content -Path $gitlabYMLContentPath -Raw
                    $gitlabYMLContent | Should -BeLike '*SecretManagement.MyVault*'
                    $gitlabYMLContent | Should -BeLike '*windows_powershell_job*'
                    $gitlabYMLContent | Should -BeLike '*windows_pwsh_job*'
                    $gitlabYMLContent | Should -BeLike '*linux_pwsh_job*'
                } #it

            } #gitlab

        } #context_cicd

        Context 'Repo Checks' {

            Context 'CodeCommit' {

                It 'should generate the appropriate repo files for CodeCommit' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
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
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
                    $eval | Should -Not -BeNullOrEmpty

                    $repoFiles = Get-ChildItem -Path $outPutPathStar -Recurse -Force

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
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
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
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
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
                    $contributingContent | Should -BeLike '*SecretManagement.MyVault*'
                    $repoFiles.Name.Contains('SECURITY.md') | Should -BeExactly $true
                    $securityContentPath = [System.IO.Path]::Combine($outPutPath, '.github', 'SECURITY.md')
                    $securityContent = Get-Content -Path $securityContentPath -Raw
                    $securityContent | Should -BeLike '*SecretManagement.MyVault*'
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

            Context 'GitLab' {

                It 'should generate the appropriate repo files for GitLab' {
                    $vaultParameters = @{
                        VAULT       = 'text'
                        ModuleName  = 'SecretManagement.MyVault'
                        Description = 'text'
                        Version     = '0.0.1'
                        FN          = 'user full name'
                        CICD        = 'NONE'
                        RepoType    = 'GITLAB'
                        License     = 'MIT'
                        Changelog   = 'CHANGELOG'
                        COC         = 'CONDUCT'
                        Contribute  = 'CONTRIBUTING'
                        Security    = 'SECURITY'
                        CodingStyle = 'Stroustrup'
                        Pester      = '5'
                        S3Bucket    = 'PSGallery'
                        PassThru    = $true
                        NoLogo      = $true
                    }
                    $eval = New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
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
                    $contributingContent | Should -BeLike '*SecretManagement.MyVault*'
                    $repoFiles.Name.Contains('SECURITY.md') | Should -BeExactly $true
                    $securityContentPath = [System.IO.Path]::Combine($outPutPath, 'SECURITY.md')
                    $securityContent = Get-Content -Path $securityContentPath -Raw
                    $securityContent | Should -BeLike '*SecretManagement.MyVault*'
                    $repoFiles.Name.Contains('.gitignore') | Should -BeExactly $true
                    $repoFiles.Name.Contains('Default.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('bug-report.md') | Should -BeExactly $true
                    $repoFiles.Name.Contains('feature-request.md') | Should -BeExactly $true

                    $dotGitLabFiles = @(
                        'Default.md'
                        'bug-report.md'
                        'feature-request.md'
                        'insights.yml'
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

        Context 'Help Examples' {

            It 'should have a working example for vanilla vault project' {
                $vaultParameters = @{
                    ModuleName  = 'SecretManagement.VaultName'
                    Description = 'My awesome vault is awesome'
                    Version     = '0.0.1'
                    FN          = 'user full name'
                    CICD        = 'NONE'
                    RepoType    = 'NONE'
                    CodingStyle = 'Stroustrup'
                    Pester      = '5'
                    NoLogo      = $true
                }
                New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'SecretManagement.VaultName', 'SecretManagement.VaultName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome vault is awesome*'
            } #it

            It 'should have a working example for GitHub Actions vault project' {
                $vaultParameters = @{
                    ModuleName     = 'SecretManagement.VaultName'
                    Description    = 'My awesome vault is awesome'
                    Version        = '0.0.1'
                    FN             = 'user full name'
                    CICD           = 'GITHUB'
                    GitHubAOptions = 'windows', 'pwshcore', 'linux', 'macos'
                    RepoType       = 'GITHUB'
                    License        = 'MIT'
                    Changelog      = 'CHANGELOG'
                    COC            = 'CONDUCT'
                    Contribute     = 'CONTRIBUTING'
                    Security       = 'SECURITY'
                    CodingStyle    = 'Stroustrup'
                    Pester         = '5'
                    S3Bucket       = 'PSGallery'
                    NoLogo         = $true
                }
                New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'SecretManagement.VaultName', 'SecretManagement.VaultName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome vault is awesome*'
            } #it

            It 'should have a working example for AWS vault project' {
                $vaultParameters = @{
                    ModuleName  = 'SecretManagement.VaultName'
                    Description = 'My awesome vault is awesome'
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
                    Pester      = '5'
                    S3Bucket    = 'PSGallery'
                    NoLogo      = $true
                }
                New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'SecretManagement.VaultName', 'SecretManagement.VaultName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome vault is awesome*'
            } #it

            It 'should have a working example for Azure vault project' {
                $vaultParameters = @{
                    ModuleName   = 'SecretManagement.VaultName'
                    Description  = 'My awesome vault is awesome'
                    Version      = '0.0.1'
                    FN           = 'user full name'
                    CICD         = 'AZURE'
                    AzureOptions = 'windows', 'pwshcore', 'linux', 'macos'
                    RepoType     = 'GITHUB'
                    License      = 'None'
                    Changelog    = 'NOCHANGELOG'
                    COC          = 'NOCONDUCT'
                    Contribute   = 'NOCONTRIBUTING'
                    Security     = 'NOSECURITY'
                    CodingStyle  = 'Stroustrup'
                    Pester       = '5'
                    NoLogo       = $true
                }
                New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'SecretManagement.VaultName', 'SecretManagement.VaultName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome vault is awesome*'
            } #it

            It 'should have a working example for Appveyor vault project' {
                $vaultParameters = @{
                    ModuleName      = 'SecretManagement.VaultName'
                    Description     = 'My awesome vault is awesome'
                    Version         = '0.0.1'
                    FN              = 'user full name'
                    CICD            = 'APPVEYOR'
                    AppveyorOptions = 'windows', 'pwshcore', 'linux', 'macos'
                    RepoType        = 'GITHUB'
                    License         = 'None'
                    Changelog       = 'NOCHANGELOG'
                    COC             = 'NOCONDUCT'
                    Contribute      = 'NOCONTRIBUTING'
                    Security        = 'NOSECURITY'
                    CodingStyle     = 'Stroustrup'
                    Pester          = '5'
                    PassThru        = $true
                    NoLogo          = $true
                }
                New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

                $manifestContentPath = [System.IO.Path]::Combine($outPutPath, 'src', 'SecretManagement.VaultName', 'SecretManagement.VaultName.psd1')
                $manifestContent = Get-Content -Path $manifestContentPath -Raw
                $manifestContent | Should -BeLike '*My awesome vault is awesome*'
            } #it
        }

    } #context_vault_checks

} #describe_vault_tests
