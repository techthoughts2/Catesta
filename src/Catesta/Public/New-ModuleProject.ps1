<#
.SYNOPSIS
    Scaffolds a PowerShell module project for use with desired CICD platform for easy cross platform PowerShell development.
    TODO: tbd
.DESCRIPTION
    Leverages plaster to scaffold a PowerShell module that adheres to community best practices.
    Based on selections made this cmdlet will generate the necessary files for a variety of CICD platforms.
    Selections can also determine what CICD builds should be run enabling easy cross-platform verification (Windows/Linux/MacOS).
    InvokeBuild tasks will be created for validation / analysis / test / build automation.
    Additional selections can generate other helpful files such as GitHub community files and VSCode project files.
    TODO: tbd
.EXAMPLE
    New-ModuleProject -DestinationPath . -NoLogo -Verbose

    TODO: tbd
.EXAMPLE
    New-ModuleProject -CICDChoice 'GitHubActions' -DestinationPath c:\path\GitHubActions

    TODO: tbd
.EXAMPLE
    New-ModuleProject -CICDChoice 'Azure' -DestinationPath c:\path\AzurePipeline

    TODO: tbd
.EXAMPLE
    New-ModuleProject -CICDChoice 'AppVeyor' -DestinationPath c:\path\AppVeyor

    TODO: tbd
.EXAMPLE
    New-ModuleProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly

    TODO: tbd
.PARAMETER DestinationPath
    File path where PowerShell Module project will be created
.PARAMETER ModuleParameters
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
    https://github.com/techthoughts2/Catesta/blob/main/docs/New-ModuleProject.md
.LINK
    https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module
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
function New-ModuleProject {
    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            HelpMessage = 'File path where PowerShell Module project will be created')]
        [string]
        $DestinationPath,

        [Parameter(Mandatory = $false,
            HelpMessage = 'TBD')]
        [hashtable]
        $ModuleParameters,

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

        $path = 'Module'
        Write-Verbose -Message ('Template Path: {0}\{1}' -f $script:resourcePath, $path)

        if ($ModuleParameters) {

            # process overrides for ModuleParameters that do not permit customization
            $ModuleParameters['VAULT'] = 'NOTVAULT'
            $ModuleParameters['ErrorAction'] = 'Stop'
            $ModuleParameters['TemplatePath'] = '{0}\{1}' -f $script:resourcePath, $path
            $ModuleParameters['DestinationPath'] = $DestinationPath

            if ($PassThru -eq $true) {
                $ModuleParameters['PassThru'] = $true
            }
            $invokePlasterSplat = $ModuleParameters

            $shouldProcessMessage = 'Scaffolding PowerShell module project with provided custom module parameters: {0}' -f $($invokePlasterSplat | Out-String)

        } #if_$ModuleParameters
        else {
            $invokePlasterSplat = @{
                TemplatePath    = '{0}\{1}' -f $script:resourcePath, $path
                DestinationPath = $DestinationPath
                VAULT           = 'NOTVAULT'
                PassThru        = $PassThru
                NoLogo          = $NoLogo
                ErrorAction     = 'Stop'
            }
            # if ($NoLogo -eq $true) {
            #     $invokePlasterSplat['NoLogo'] = $NoLogo
            # }

            $shouldProcessMessage = 'Scaffolding PowerShell module project with: {0}' -f $($invokePlasterSplat | Out-String)

        } #else_$ModuleParameters

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
        if ($PassThru -or $ModuleParameters.PassThru -eq $true) {
            return $result
        }
    } #end
} #New-ModuleProject
