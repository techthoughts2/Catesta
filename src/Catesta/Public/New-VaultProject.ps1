<#
.SYNOPSIS
    Scaffolds a PowerShell SecretManagement vault project for use with desired CICD platform for easy cross platform PowerShell development.
.DESCRIPTION
    Uses the Plaster framework to scaffold a PowerShell SecretManagement vault project that adheres to community best practices.
    Based on selections made, generates the files and configuration required to integrate with a variety of CI/CD platforms,
    including options for easy cross-platform verification on Windows, Linux, and MacOS.
    InvokeBuild tasks will be created for validation, analysis, testing, and build automation.
    Additional selections can generate other helpful files such as GitHub community files and VSCode project files.
    If no VaultParameters are passed in, you will be prompted by Plaster for a decision on each template choice.
    If you pass in a partial VaultParameters, you will be prompted by Plaster for any missing template decisions.
    If you pass in a full VaultParameters set, Plaster will not prompt you for any template decisions.
.EXAMPLE
    New-VaultProject -DestinationPath $outPutPath

    Initiates Plaster template to scaffold a PowerShell SecretManagement vault project with customizable CI/CD integration options. Choices made during scaffolding will result in a PowerShell project tailored to the chosen CI/CD platform, or a standard PowerShell SecretManagement vault project with no CI/CD integration.
.EXAMPLE
    New-VaultProject -DestinationPath $outPutPath -NoLogo

    Initiates Plaster template to scaffold a PowerShell SecretManagement vault project with customizable CI/CD integration options. Choices made during scaffolding will result in a PowerShell project tailored to the chosen CI/CD platform, or a standard PowerShell SecretManagement vault project with no CI/CD integration. The Plaster logo will be suppressed and not shown.
.EXAMPLE
    New-VaultProject -DestinationPath $outPutPath -PassThru

    Initiates Plaster template to scaffold a PowerShell SecretManagement vault project with customizable CI/CD integration options. Choices made during scaffolding will result in a PowerShell project tailored to the chosen CI/CD platform, or a standard PowerShell SecretManagement vault project with no CI/CD integration. An object will be returned containing details of the Plaster template deployment.
.EXAMPLE
    $vaultParameters = @{
        ModuleName       = 'SecretManagement.VaultName'
        Description      = 'My awesome vault is awesome'
        Version          = '0.0.1'
        FN               = 'user full name'
        CICD             = 'NONE'
        RepoType         = 'NONE'
        CodingStyle      = 'Stroustrup'
        Pester           = '5'
        NoLogo           = $true
    }
    New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

    Scaffolds a basic PowerShell SecretManagement vault project with no additional extras. You just get a basic PowerShell SecretManagement vault construct.
.EXAMPLE
    $vaultParameters = @{
        ModuleName       = 'SecretManagement.VaultName'
        Description      = 'My awesome vault is awesome'
        Version          = '0.0.1'
        FN               = 'user full name'
        CICD             = 'GITHUB'
        GitHubAOptions   = 'windows', 'pwshcore', 'linux', 'macos'
        RepoType         = 'GITHUB'
        License          = 'MIT'
        Changelog        = 'CHANGELOG'
        COC              = 'CONDUCT'
        Contribute       = 'CONTRIBUTING'
        Security         = 'SECURITY'
        CodingStyle      = 'Stroustrup'
        Pester           = '5'
        S3Bucket         = 'PSGallery'
        NoLogo           = $true
    }
    New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

    Scaffolds a PowerShell SecretManagement vault project for integration with GitHub Actions with the project code stored in GitHub. A full set of GitHub project supporting files is provided.
.EXAMPLE
    $vaultParameters = @{
        ModuleName       = 'SecretManagement.VaultName'
        Description      = 'My awesome vault is awesome'
        Version          = '0.0.1'
        FN               = 'user full name'
        CICD             = 'CODEBUILD'
        AWSOptions       = 'ps', 'pwshcore', 'pwsh'
        RepoType         = 'GITHUB'
        License          = 'MIT'
        Changelog        = 'CHANGELOG'
        COC              = 'CONDUCT'
        Contribute       = 'CONTRIBUTING'
        Security         = 'SECURITY'
        CodingStyle      = 'Stroustrup'
        Pester           = '5'
        S3Bucket         = 'PSGallery'
        NoLogo           = $true
    }
    New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

    Scaffolds a PowerShell SecretManagement vault project for integration with AWS CodeBuild with the project code stored in GitHub. A full set of GitHub project supporting files is provided.
.EXAMPLE
    $vaultParameters = @{
        ModuleName       = 'SecretManagement.VaultName'
        Description      = 'My awesome vault is awesome'
        Version          = '0.0.1'
        FN               = 'user full name'
        CICD             = 'AZURE'
        AzureOptions     = 'windows', 'pwshcore', 'linux', 'macos'
        RepoType         = 'GITHUB'
        License          = 'None'
        Changelog        = 'NOCHANGELOG'
        COC              = 'NOCONDUCT'
        Contribute       = 'NOCONTRIBUTING'
        Security         = 'NOSECURITY'
        CodingStyle      = 'Stroustrup'
        Pester           = '5'
        NoLogo           = $true
    }
    New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

    Scaffolds a PowerShell SecretManagement vault project for integration with Azure Pipelines with the project code stored in GitHub. No repository supporting files are included.
.EXAMPLE
    $vaultParameters = @{
        ModuleName       = 'SecretManagement.VaultName'
        Description      = 'My awesome vault is awesome'
        Version          = '0.0.1'
        FN               = 'user full name'
        CICD             = 'APPVEYOR'
        AppveyorOptions  = 'windows', 'pwshcore', 'linux', 'macos'
        RepoType         = 'GITHUB'
        License          = 'None'
        Changelog        = 'NOCHANGELOG'
        COC              = 'NOCONDUCT'
        Contribute       = 'NOCONTRIBUTING'
        Security         = 'NOSECURITY'
        CodingStyle      = 'Stroustrup'
        Pester           = '5'
        PassThru         = $true
        NoLogo           = $true
    }
    New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath

    Scaffolds a PowerShell SecretManagement vault project for integration with Appveyor with the project code stored in GitHub. No repository supporting files are included.
.PARAMETER DestinationPath
    File path where PowerShell SecretManagement vault project will be created
.PARAMETER VaultParameters
    Provide all Plaster decisions inside a Hashtable. If any decision choice is not provided, Plaster will still prompt you for a decision. See NOTES for additional limitations.
.PARAMETER NoLogo
    Suppresses the display of the Plaster logo.
.PARAMETER PassThru
    Returns an object containing details of Plaster template deployment.
.PARAMETER Force
    Skip Confirmation
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.LINK
    https://github.com/techthoughts2/Catesta/blob/main/docs/Catesta-Vault-Extension.md
.LINK
    https://github.com/techthoughts2/Catesta/blob/main/docs/Catesta-Vault-Manifest-Schema.md
.LINK
    https://github.com/PowerShell/SecretManagement
.LINK
    https://aws.amazon.com/codebuild/
.LINK
    https://help.github.com/actions
.LINK
    https://azure.microsoft.com/services/devops/
.LINK
    https://www.appveyor.com/
.COMPONENT
    Catesta
#>
function New-VaultProject {
    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'File path where PowerShell SecretManagement vault project will be created')]
        [string]
        $DestinationPath,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Plaster choices inside hashtable')]
        [hashtable]
        $VaultParameters,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Suppresses the display of the Plaster logo')]
        [switch]$NoLogo,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Plaster template object')]
        [switch]$PassThru,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Skip confirmation')]
        [switch]$Force
    )
    Begin {

        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }

        Write-Verbose -Message ('[{0}] Confirm={1} ConfirmPreference={2} WhatIf={3} WhatIfPreference={4}' -f $MyInvocation.MyCommand, $Confirm, $ConfirmPreference, $WhatIf, $WhatIfPreference)
        Write-Verbose -Message ('ParameterSetName: {0}' -f $PSCmdlet.ParameterSetName)
    } #begin
    Process {

        Write-Verbose -Message 'Importing Plaster...'
        try {
            Import-Module -Name Plaster -ErrorAction Stop
            Write-Verbose 'Plaster Imported.'
        }
        catch {
            throw $_
        }

        $path = 'Vault'
        Write-Verbose -Message ('Template Path: {0}\{1}' -f $script:resourcePath, $path)

        if ($VaultParameters) {

            # process overrides for VaultParameters that do not permit customization
            $VaultParameters['VAULT'] = 'VAULT'
            $VaultParameters['ErrorAction'] = 'Stop'
            $VaultParameters['TemplatePath'] = '{0}\{1}' -f $script:resourcePath, $path
            $VaultParameters['DestinationPath'] = $DestinationPath

            if ($PassThru -eq $true) {
                $VaultParameters['PassThru'] = $true
            }
            $invokePlasterSplat = $VaultParameters

            $shouldProcessMessage = 'Scaffolding PowerShell vault project with provided custom vault parameters: {0}' -f $($invokePlasterSplat | Out-String)

        } #if_$VaultParameters
        else {
            $invokePlasterSplat = @{
                TemplatePath    = '{0}\{1}' -f $script:resourcePath, $path
                DestinationPath = $DestinationPath
                VAULT           = 'VAULT'
                PassThru        = $PassThru
                NoLogo          = $NoLogo
                ErrorAction     = 'Stop'
            }
            # if ($NoLogo -eq $true) {
            #     $invokePlasterSplat['NoLogo'] = $NoLogo
            # }

            $shouldProcessMessage = 'Scaffolding PowerShell vault project with: {0}' -f $($invokePlasterSplat | Out-String)

        } #else_$VaultParameters

        if ($Force -or $PSCmdlet.ShouldProcess($DestinationPath, $shouldProcessMessage)) {
            Write-Verbose -Message ('[{0}] Reached command' -f $MyInvocation.MyCommand)

            # Save current value of $ConfirmPreference
            $originalConfirmPreference = $ConfirmPreference
            # Set $ConfirmPreference to 'None'
            $ConfirmPreference = 'None'

            Write-Verbose -Message 'Deploying template...'
            $result = Invoke-Plaster @invokePlasterSplat
            Write-Verbose -Message 'Template Deployed.'

            # Set $ConfirmPreference back to original value
            $ConfirmPreference = $originalConfirmPreference
        } #if_Should

    } #process
    End {
        if ($PassThru -or $VaultParameters.PassThru -eq $true) {
            return $result
        }
    } #end
} #New-VaultProject
