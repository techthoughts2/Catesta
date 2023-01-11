# Catesta - Manifest Schema

## Synopsis

tbd

## Description

tbd

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

name : AWSOptions
type : multichoice
condition : $PLASTER_PARAM_CICD -eq 'CODEBUILD'
choices:
    value : ps
    help : Adds a powershell focused buildspec.yml for Windows CodeBuild.
    value : pwshcore
    help : Adds a pwsh focused buildspec.yml for Windows CodeBuild.
    value : pwsh
    help : Adds a pwsh focused buildspec.yml for Linux CodeBuild.

name : S3Bucket
type : text
default : PSGallery

name : RepoType
type : choice
choices:
    value : NONE
    help : Does not add any repository files.
    value : GITHUB
    help : Hosted on GitHub.
    value : CC
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
    value : None
    help : Does not add a License file.

name : Changelog
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : CHANGELOG
    help : Adds a Changelog file.
    value : NOCHANGELOG
    help : Does not add a Changelog file.

name : COC
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : CONDUCT
    help : Adds a Code of Conduct file.
    value : NOCONDUCT
    help : Does not add a Conduct file.

name : Contribute
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : CONTRIBUTING
    help : Adds a Contributing file.
    value : NOCONTRIBUTING
    help : Does not add a Contributing file.

name : Security
type : choice
condition : $PLASTER_PARAM_RepoType -ne 'NONE'
choices:
    value : SECURITY
    help : Adds a Security policy file.
    value : NOSECURITY
    help : Does not add a Security policy file.

name : CodingStyle
type : choice
choices:
    value : Stroustrup
    help : Sets Stroustrup as the preferred coding style.
    value : OTBS
    help : Sets OTBS as the preferred coding style.
    value : Allman
    help : Sets Allman as the preferred coding style.
    value : None
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

```powershell
$moduleParameters = @{
    
VAULT       = 'text'
ModuleName  = 'text'
Description = 'text'
Version     = '0.0.1'
FN          = 'user full name'
CICD        = 'GITHUB'
AWSOptions  = 'ps','pwshcore','pwsh'
RepoType    = 'GITHUB'
License     = 'MIT'
Changelog   = 'CHANGELOG'
COC         = 'CONDUCT'
Contribute  = 'CONTRIBUTING'
Security    = 'SECURITY'
CodingStyle = 'Stroustrup'
Help        = 'Yes'
Pester      = '5'



}
New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath .
```
