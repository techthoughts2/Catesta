---
external help file: Catesta-help.xml
Module Name: Catesta
online version: https://github.com/techthoughts2/Catesta/blob/main/docs/New-PowerShellProject.md
schema: 2.0.0
---

# New-PowerShellProject

## SYNOPSIS
Scaffolds a PowerShell module project for use with desired CICD platform for easy cross platform PowerShell development.

## SYNTAX

```
New-PowerShellProject [-CICDChoice] <String> [-DestinationPath] <String> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Leverages plaster to scaffold a PowerShell module that adheres to community best practices.
Based on selections made this cmdlet will generate the necessary files for a variety of CICD platforms.
Selections can also determine what CICD builds should be run enabling easy cross-platform verification (Windows/Linux/MacOS).
InvokeBuild tasks will be created for validation / analysis / test / build automation.
Additional selections can generate other helpful files such as GitHub community files and VSCode project files.

## EXAMPLES

### EXAMPLE 1
```
New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path\AWSProject
```

Scaffolds a PowerShell module project for integration with AWS CodeBuild.

### EXAMPLE 2
```
New-PowerShellProject -CICDChoice 'GitHubActions' -DestinationPath c:\path\GitHubActions
```

Scaffolds a PowerShell module project for integration with GitHub Actions Workflows.

### EXAMPLE 3
```
New-PowerShellProject -CICDChoice 'Azure' -DestinationPath c:\path\AzurePipeline
```

Scaffolds a PowerShell module project for integration with Azure DevOps Pipelines.

### EXAMPLE 4
```
New-PowerShellProject -CICDChoice 'AppVeyor' -DestinationPath c:\path\AppVeyor
```

Scaffolds a PowerShell module project for integration with AppVeyor Projects.

### EXAMPLE 5
```
New-PowerShellProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly
```

Scaffolds a basic PowerShell module project with no additional extras.
You just get a basic PowerShell module construct.

## PARAMETERS

### -CICDChoice
CICD Platform Choice
AWS - AWS CodeBuild
GitHubActions - GitHub Actions Workflows
Azure - Azure DevOps Pipelines
AppVeyor - AppVeyor Projects
ModuleOnly - Just a Vanilla PowerShell module scaffold

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationPath
File path where PowerShell Module project will be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Skip Confirmation

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject
## NOTES
General notes

## RELATED LINKS

[https://github.com/techthoughts2/Catesta/blob/main/docs/New-PowerShellProject.md](https://github.com/techthoughts2/Catesta/blob/main/docs/New-PowerShellProject.md)

[https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module](https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module)

[https://aws.amazon.com/codebuild/](https://aws.amazon.com/codebuild/)

[https://help.github.com/actions](https://help.github.com/actions)

[https://azure.microsoft.com/services/devops/](https://azure.microsoft.com/services/devops/)

[https://www.appveyor.com/](https://www.appveyor.com/)

