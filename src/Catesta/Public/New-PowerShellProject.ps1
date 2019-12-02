<#
.SYNOPSIS
    Scaffolds a PowerShell module project for use with desired CICD platform for easy cross platform PowerShell development.
.DESCRIPTION
    Leverages plaster to scaffold a PowerShell module that adheres to community best practices.
    Based on selections made this cmdlet will generate the necessary files for a variety of CICD platforms.
    Selections can also determine what CICD builds should be run enabling easy cross-platform verification (Windows/Linux/MacOS).
    InvokeBuild tasks will be created for validation / analysis / test / build automation.
    Additional selections can generate other helpful files such as GitHub community files and VSCode project files.
.EXAMPLE
    New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path\AWSProject

    Scaffolds a PowerShell module project for integration with AWS CodeBuild.
.EXAMPLE
    New-PowerShellProject -CICDChoice 'GitHubActions' -DestinationPath c:\path\GitHubActions

    Scaffolds a PowerShell module project for integration with GitHub Actions Workflows.
.EXAMPLE
    New-PowerShellProject -CICDChoice 'Azure' -DestinationPath c:\path\AzurePipeline

    Scaffolds a PowerShell module project for integration with Azure DevOps Pipelines.
.EXAMPLE
    New-PowerShellProject -CICDChoice 'AppVeyor' -DestinationPath c:\path\AppVeyor

    Scaffolds a PowerShell module project for integration with AppVeyor Projects.
.EXAMPLE
    New-PowerShellProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly

    Scaffolds a basic PowerShell module project with no additional extras. You just get a basic PowerShell module construct.
.PARAMETER CICDChoice
    CICD Platform Choice
    AWS - AWS CodeBuild
    GitHubActions - GitHub Actions Workflows
    Azure - Azure DevOps Pipelines
    AppVeyor - AppVeyor Projects
    ModuleOnly - Just a Vanilla PowerShell module scaffold
.PARAMETER DestinationPath
    File path where PowerShell Module project will be created
.PARAMETER Force
    Skip Confirmation
.OUTPUTS
    System.Management.Automation.PSCustomObject
.NOTES
    General notes
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
function New-PowerShellProject {
    [CmdletBinding(ConfirmImpact = 'Low',
        SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'CICD Platform Choice')]
        [ValidateSet('AWS', 'GitHubActions', 'Azure', 'AppVeyor','ModuleOnly')]
        [string]
        $CICDChoice,
        [Parameter(Mandatory = $true,
            HelpMessage = 'File path where PowerShell Module project will be created')]
        [string]
        $DestinationPath,
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

    }#begin
    Process {
        # -Confirm --> $ConfirmPreference = 'Low'
        # ShouldProcess intercepts WhatIf* --> no need to pass it on
        if ($Force -or $PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Write-Verbose -Message ('[{0}] Reached command' -f $MyInvocation.MyCommand)
            $ConfirmPreference = 'None'

            Write-Verbose -Message 'Importing Plaster...'
            try {
                Import-Module -Name Plaster -ErrorAction Stop
                Write-Verbose 'Plaster Imported.'
            }
            catch {
                throw $_
            }

            Write-Verbose -Message 'Sourcing correct template...'
            switch ($CICDChoice) {
                'AWS' {
                    Write-Verbose -Message 'AWS Template Selected.'
                    $path = '\AWS'
                }#aws
                'GitHubActions' {
                    Write-Verbose -Message 'GitHub Actions Template Selected.'
                    $path = '\GitHubActions'
                }#githubactions
                'Azure' {
                    Write-Verbose -Message 'Azure Pipelines Template Selected.'
                    $path = '\Azure'
                }#githubactions
                'AppVeyor' {
                    Write-Verbose -Message 'AppVeyor Template Selected.'
                    $path = '\AppVeyor'
                }#appveyor
                'ModuleOnly' {
                    Write-Verbose -Message 'Module Only Template Selected.'
                    $path = '\Vanilla'
                }#moduleonly
            }#switch

            Write-Verbose -Message 'Deploying template...'
            try {
                $results = Invoke-Plaster -TemplatePath "$script:resourcePath\$path" -DestinationPath $DestinationPath -PassThru -ErrorAction Stop
                Write-Verbose -Message 'Template Deployed.'
            }
            catch {
                Write-Error $_
                $results = [PSCustomObject]@{
                    Success = $false
                }
            }

        }#if_Should
    }#process
    End {
        return $results
    }#end
}#New-PowerShellProject