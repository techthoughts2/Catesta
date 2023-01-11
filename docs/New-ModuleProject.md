---
external help file: Catesta-help.xml
Module Name: Catesta
online version: https://github.com/techthoughts2/Catesta/blob/main/docs/New-ModuleProject.md
schema: 2.0.0
---

# New-ModuleProject

## SYNOPSIS
Scaffolds a PowerShell module project for use with desired CICD platform for easy cross platform PowerShell development.
TODO: tbd

## SYNTAX

```
New-ModuleProject [-DestinationPath] <String> [-ModuleParameters <Hashtable>] [-NoLogo] [-PassThru] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Leverages plaster to scaffold a PowerShell module that adheres to community best practices.
Based on selections made this cmdlet will generate the necessary files for a variety of CICD platforms.
Selections can also determine what CICD builds should be run enabling easy cross-platform verification (Windows/Linux/MacOS).
InvokeBuild tasks will be created for validation / analysis / test / build automation.
Additional selections can generate other helpful files such as GitHub community files and VSCode project files.
TODO: tbd

## EXAMPLES

### EXAMPLE 1
```
New-ModuleProject -DestinationPath . -NoLogo -Verbose
```

TODO: tbd

### EXAMPLE 2
```
New-ModuleProject -CICDChoice 'GitHubActions' -DestinationPath c:\path\GitHubActions
```

TODO: tbd

### EXAMPLE 3
```
New-ModuleProject -CICDChoice 'Azure' -DestinationPath c:\path\AzurePipeline
```

TODO: tbd

### EXAMPLE 4
```
New-ModuleProject -CICDChoice 'AppVeyor' -DestinationPath c:\path\AppVeyor
```

TODO: tbd

### EXAMPLE 5
```
New-ModuleProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly
```

TODO: tbd

## PARAMETERS

### -DestinationPath
File path where PowerShell Module project will be created

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

### -ModuleParameters
TODO: tbd

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoLogo
TODO: tbd

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

### -PassThru
TODO: tbd

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
Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

## RELATED LINKS

[https://github.com/techthoughts2/Catesta/blob/main/docs/New-ModuleProject.md](https://github.com/techthoughts2/Catesta/blob/main/docs/New-ModuleProject.md)

[https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module](https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module)

[https://aws.amazon.com/codebuild/](https://aws.amazon.com/codebuild/)

[https://help.github.com/actions](https://help.github.com/actions)

[https://azure.microsoft.com/services/devops/](https://azure.microsoft.com/services/devops/)

[https://www.appveyor.com/](https://www.appveyor.com/)

