<#
.SYNOPSIS
    Scaffolds a PowerShell SecretManagement vault project for use with desired CICD platform for easy cross platform PowerShell development.
.DESCRIPTION
    Leverages plaster to scaffold a PowerShell SecretManagement vault project that adheres to community best practices.
    Based on selections made this cmdlet will generate the necessary files for a variety of CICD platforms.
    Selections can also determine what CICD builds should be run enabling easy cross-platform verification (Windows/Linux/MacOS).
    InvokeBuild tasks will be created for validation / analysis / test / build automation.
    Additional selections can generate other helpful files such as GitHub community files and VSCode project files.
.EXAMPLE
    New-VaultProject -CICDChoice 'AWS' -DestinationPath c:\path\AWSProject

    Scaffolds a PowerShell SecretManagement vault project for integration with AWS CodeBuild.
    TODO: tbd
.EXAMPLE
    New-VaultProject -CICDChoice 'GitHubActions' -DestinationPath c:\path\GitHubActions

    Scaffolds a PowerShell SecretManagement vault project for integration with GitHub Actions Workflows.
    TODO: tbd
.EXAMPLE
    New-VaultProject -CICDChoice 'Azure' -DestinationPath c:\path\AzurePipeline

    Scaffolds a PowerShell SecretManagement vault project for integration with Azure DevOps Pipelines.
    TODO: tbd
.EXAMPLE
    New-VaultProject -CICDChoice 'AppVeyor' -DestinationPath c:\path\AppVeyor

    Scaffolds a PowerShell SecretManagement vault project for integration with AppVeyor Projects.
    TODO: tbd
.EXAMPLE
    New-VaultProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly

    Scaffolds a basic PowerShell SecretManagement vault project with no additional extras. You just get a basic PowerShell vault construct.
    TODO: tbd
.PARAMETER DestinationPath
    File path where PowerShell SecretManagement vault project will be created
.PARAMETER VaultParameters
    TODO: tbd
.PARAMETER NoLogo
    TODO: tbd
.PARAMETER PassThru
    TODO: tbd
.PARAMETER Force
    Skip Confirmation
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/
.LINK
    https://github.com/techthoughts2/Catesta/blob/main/docs/Catesta-Vault-Extension.md
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
            HelpMessage = 'TBD')]
        [hashtable]
        $VaultParameters,

        [Parameter(Mandatory = $false,
            HelpMessage = 'TBD')]
        [switch]$NoLogo,

        [Parameter(Mandatory = $false,
            HelpMessage = 'TBD')]
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

            # process overrides for ModuleParameters that do not permit customization
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
