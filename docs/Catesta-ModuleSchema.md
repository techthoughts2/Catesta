# Catesta - Module Schema

## Synopsis

The Module Schema in Catesta refers to the blueprint for creating new module projects using the New-ModuleProject Plaster template. This schema outlines all of the prompts and parameters that will be encountered during the setup process for a new module project.

## Description

The schema serves as a reference for the project creator, allowing them to understand the various options and customizations available to them as they set up their new module. This information can be used to fill out the required parameters in the ModuleParameters table, ensuring that the new project is configured to meet the specific needs and requirements of the module.

## Module Schema

```text
name : VAULT
type : text
default : 

name : ModuleName
type : text
default : 

name : Description
type : text
default : 

name : Version
type : text
default : 0.0.1

name : FN
type : user-fullname
default : 

name : CICD
type : choice
choices:
    value : NONE
    help : Does not add CI/CD process files. Module scaffolding only.
    value : GITHUB
    help : CI/CD using GitHub Actions.
    value : CODEBUILD
    help : CI/CD using AWS CodeBuild
    value : APPVEYOR
    help : CI/CD using AWS Appveyor
    value : GITLAB
    help : CI/CD using GitLab CI/CD
    value : BITBUCKET
    help : CI/CD using BitBucket Pipelines
    value : AZURE
    help : CI/CD using Azure Pipelines

name : GitHubAOptions
type : multichoice
condition : $PLASTER_PARAM_CICD -eq 'GITHUB'
choices:
    value : windows
    help : Adds a Windows PowerShell based Workflow action.
    value : pwshcore
    help : Adds a Windows pwsh based pipeline job.
    value : linux
    help : Adds a Linux based Workflow action.
    value : macos
    help : Adds a MacOS based Workflow action.

name : AWSOptions
type : multichoice
condition : $PLASTER_PARAM_CICD -eq 'CODEBUILD'
choices:
    value : ps
    help : Adds a Windows PowerShell focused buildspec.yml for Windows CodeBuild.
    value : pwshcore
    help : Adds a pwsh focused buildspec.yml for Windows CodeBuild.
    value : pwsh
    help : Adds a pwsh focused buildspec.yml for Linux CodeBuild.

name : S3Bucket
type : text
default : PSGallery

name : AppveyorOptions
type : multichoice
condition : $PLASTER_PARAM_CICD -eq 'APPVEYOR'
choices:
    value : windows
    help : Adds a Windows PowerShell focused build on a Windows image.
    value : pwshcore
    help : Adds a pwsh focused build on a Windows image.
    value : linux
    help : Adds a pwsh focused build for a Linux image.
    value : macos
    help : Adds a pwsh focused build for a MacOS image.

name : GitLabOptions
type : multichoice
condition : $PLASTER_PARAM_CICD -eq 'GITLAB'
choices:
    value : windows
    help : Adds a Windows PowerShell focused build on a Windows image.
    value : pwshcore
    help : Adds a pwsh focused build on a Windows image.
    value : linux
    help : Adds a pwsh focused build for a Linux image.

name : AzureOptions
type : multichoice
condition : $PLASTER_PARAM_CICD -eq 'AZURE'
choices:
    value : windows
    help : Adds a Windows PowerShell focused job on a Windows image.
    value : pwshcore
    help : Adds a pwsh focused job on a Windows image.
    value : linux
    help : Adds a pwsh focused job for a Linux image.
    value : macos
    help : Adds a pwsh focused job for a MacOS image.

name : RepoType
type : choice
choices:
    value : NONE
    help : Does not add any repository files.
    value : GITHUB
    help : Hosted on GitHub.
    value : CODECOMMIT
    help : Hosted on AWS CodeCommit.
    value : GITLAB
    help : Hosted on GitLab.
    value : BITBUCKET
    help : Hosted on BitBucket.
    value : AZURE
    help : Hosted on Azure Repos.

name : License
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : MIT
    help : Adds a MIT License file.
    value : Apache
    help : Adds an Apache License file.
    value : GNU
    help : Adds a GNU GENERAL PUBLIC LICENSE file.
    value : ISC
    help : Adds an ISC License file.
    value : NONE
    help : Does not add a License file.

name : Changelog
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : CHANGELOG
    help : Adds a Changelog file.
    value : NONE
    help : Does not add a Changelog file.

name : COC
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : CONDUCT
    help : Adds a Code of Conduct file.
    value : NONE
    help : Does not add a Conduct file.

name : Contribute
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : CONTRIBUTING
    help : Adds a Contributing file.
    value : NONE
    help : Does not add a Contributing file.

name : Security
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : SECURITY
    help : Adds a Security policy file.
    value : NONE
    help : Does not add a Security policy file.

name : ReadtheDocs
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : READTHEDOCS
    help : Adds files for integrating your project with Read the Docs.
    value : NONE
    help : Does not add Read the Docs integration files.

name : RTDTheme
type : choice
condition : $PLASTER_PARAM_ReadtheDocs -eq 'READTHEDOCS'
choices:
    value : READTHEDOCSTHEME
    help : Creates Read the Docs integration with default readthedocs theme.
    value : MATERIALTHEME
    help : Creates Read the Docs integration with the material theme.

name : CodingStyle
type : choice
choices:
    value : Stroustrup
    help : Sets Stroustrup as the preferred coding style.
    value : OTBS
    help : Sets OTBS as the preferred coding style.
    value : Allman
    help : Sets Allman as the preferred coding style.
    value : NONE
    help : No coding style is set for the project.

name : Help
type : choice
choices:
    value : Yes
    help : platyPS will generate MarkDown help and external xml help
    value : No
    help : No help files will be generated.

name : Pester
type : choice
choices:
    value : 5
    help : Pester version 5
    value : 4
    help : Pester version 4

```

### Example

The example below showcases all the available options for the `New-ModuleProject` Plaster template in a PowerShell splat format. However, it is not meant to be used 'as-is'. Instead, you need to use the Module Schema to determine which options are compatible and appropriate for scaffolding your specific module.

```powershell
$moduleParameters = @{
    
VAULT           = 'text'
ModuleName      = 'text'
Description     = 'text'
Version         = '0.0.1'
FN              = 'user full name'
CICD            = 'GITHUB'
GitHubAOptions  = 'windows','pwshcore','linux','macos'
AWSOptions      = 'ps','pwshcore','pwsh'
AppveyorOptions = 'windows','pwshcore','linux','macos'
GitLabOptions   = 'windows','pwshcore','linux'
AzureOptions    = 'windows','pwshcore','linux','macos'
RepoType        = 'GITHUB'
License         = 'MIT'
Changelog       = 'CHANGELOG'
COC             = 'CONDUCT'
Contribute      = 'CONTRIBUTING'
Security        = 'SECURITY'
ReadtheDocs     = 'READTHEDOCS'
RTDTheme        = 'READTHEDOCSTHEME'
CodingStyle     = 'Stroustrup'
Help            = 'Yes'
Pester          = '5'



}
New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath .
```
