---
external help file: Catesta-help.xml
Module Name: Catesta
online version: https://www.catesta.dev/en/latest/New-ModuleProject/
schema: 2.0.0
---

# New-ModuleProject

## SYNOPSIS

Scaffolds a PowerShell module project for use with desired CICD platform for easy cross platform PowerShell development.

## SYNTAX

```powershell
New-ModuleProject [-DestinationPath] <String> [-ModuleParameters <Hashtable>] [-NoLogo] [-PassThru] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Uses the Plaster framework to scaffold a PowerShell module that adheres to community best practices.
Based on selections made, generates the files and configuration required to integrate with a variety of CI/CD platforms,
including options for easy cross-platform verification on Windows, Linux, and MacOS.
InvokeBuild tasks will be created for validation, analysis, testing, and build automation.
Basic Pester tests will be generated to get you started with either Pester 4 or Pester 5.
Additional selections can generate other helpful files such as Git repository community files and VSCode project files.
If no ModuleParameters are passed in, you will be prompted by Plaster for a decision on each template choice.
If you pass in a partial ModuleParameters, you will be prompted by Plaster for any missing template decisions.
If you pass in a full ModuleParameters set, Plaster will not prompt you for any template decisions.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ModuleProject -DestinationPath $outPutPath
```

Initiates Plaster template to scaffold a PowerShell module project with customizable CI/CD integration options.
Choices made during scaffolding will result in a PowerShell project tailored to the chosen CI/CD platform, or a standard PowerShell module project with no CI/CD integration.

### EXAMPLE 2

```powershell
New-ModuleProject -DestinationPath $outPutPath -NoLogo
```

Initiates Plaster template to scaffold a PowerShell module project with customizable CI/CD integration options.
Choices made during scaffolding will result in a PowerShell project tailored to the chosen CI/CD platform, or a standard PowerShell module project with no CI/CD integration.
The Plaster logo will be suppressed and not shown.

### EXAMPLE 3

```powershell
New-ModuleProject -DestinationPath $outPutPath -PassThru
```

Initiates Plaster template to scaffold a PowerShell module project with customizable CI/CD integration options.
Choices made during scaffolding will result in a PowerShell project tailored to the chosen CI/CD platform, or a standard PowerShell module project with no CI/CD integration.
An object will be returned containing details of the Plaster template deployment.

### EXAMPLE 4

```powershell
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
```

Scaffolds a basic PowerShell module project with no additional extras.
You just get a basic PowerShell module construct.

### EXAMPLE 5

```powershell
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
```

Scaffolds a PowerShell module project for integration with GitHub Actions with the project code stored in GitHub.
A full set of GitHub project supporting files is provided.
The project is set up for integration with Read the Docs.

### EXAMPLE 6

```powershell
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
```

Scaffolds a PowerShell module project for integration with AWS CodeBuild with the project code stored in GitHub.
A full set of GitHub project supporting files is provided.

### EXAMPLE 7

```powershell
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
```

Scaffolds a PowerShell module project for integration with Azure Pipelines with the project code stored in GitHub.
No repository supporting files are included.

### EXAMPLE 8

```powershell
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
```

Scaffolds a PowerShell module project for integration with Appveyor with the project code stored in GitHub.
No repository supporting files are included.

### EXAMPLE 9

```powershell
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
```

Scaffolds a PowerShell module project for integration with Bitbucket Pipelines with the project code stored on Bitbucket.
A full set of repository supporting files are included.

### EXAMPLE 10

```powershell
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
```

Scaffolds a PowerShell module project for integration with GitLab CI/CD Pipelines with the project code stored on GitLab.
A full set of repository supporting files are included. 
The project is set up for integration with Read the Docs.

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

Provide all Plaster decisions inside a Hashtable.
If any decision choice is not provided, Plaster will still prompt you for a decision.
See NOTES for additional limitations.

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

Suppresses the display of the Plaster logo.

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

Returns an object containing details of Plaster template deployment.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction. 
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject

## NOTES

Author: Jake Morrison - @jakemorrison - https://www.techthoughts.info/

Catesta Plaster templates have dynamic choices.
This means that early choices influence subsequent choices.
This requires an understanding of the template manifest schema which is provided in the Catesta docs.
Due to the nature of the lower level Plaster engagement, this means it is possible to pass hashtable choices
in ModuleParameters that are not supported.
Read the manifest schemas to understand how to properly craft a ModuleParameters table.

## RELATED LINKS

[https://www.catesta.dev/en/latest/New-ModuleProject/](https://www.catesta.dev/en/latest/New-ModuleProject/)

[https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module](https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module)
