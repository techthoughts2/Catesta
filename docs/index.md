# Catesta

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-purple.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE) [![Documentation Status](https://readthedocs.org/projects/rtdtest222222/badge/?version=latest)](https://rtdtest222222.readthedocs.io/en/latest/?badge=latest)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/Catesta?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/Catesta
[license-badge]:   https://img.shields.io/github/license/techthoughts2/Catesta

## What is Catesta?

Catesta is a PowerShell module and vault project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.

<p align="left">
    <img src="assets/Catesta.PNG" alt="Catesta Logo" >
</p>

## Why Catesta?

Catesta streamlines the process of structuring your PowerShell module or Vault extension project, allowing you to focus on creating a top-quality project without getting bogged down in formatting, testing, and build automation. With Catesta, you can generate all the necessary build files, configurations, and integrations for your project with just a single command.

## Getting Started

### Installation

```powershell
# Install Catesta from the PowerShell Gallery
Install-Module -Name Catesta -Repository PSGallery -Scope CurrentUser
```

### Quick start

#### PowerShell Module

```powershell
# Scaffolds a PowerShell module project with customizable CI/CD integration options
New-ModuleProject -DestinationPath $outPutPath
```

#### SecretManagement Vault Extension Project

```powershell
# Scaffolds a PowerShell SecretManagement vault project with customizable CI/CD integration options
New-VaultProject -DestinationPath $outPutPath
```

## How Catesta Works

Catesta uses customized Plaster templates to enable you to quickly scaffold a [PowerShell module](https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-script-module?view=powershell-7) or [Vault extension](https://github.com/PowerShell/SecretManagement) project with proper formatting, test + build automation, CI/CD integration, with just one line of code.

* Catesta scaffolds an empty Module/Vault project that adheres to PowerShell community guidelines.
* It generates a few [Pester](https://github.com/pester/Pester) tests to get you started.
* It makes a [build file](https://github.com/nightroman/Invoke-Build) that analyzes your code for best practices and styling, runs Pester tests, creates PowerShell help, and combines your functions together to build your project for publication.
* It will create resources you need to trigger CI/CD builds for your project.
* When you commit your code to your chosen repository, the build(s) will run, and you can view the results.

## Features

Catesta can build two types of projects:

1. [PowerShell module](https://docs.microsoft.com/powershell/scripting/developer/module/writing-a-windows-powershell-module?view=powershell-7) layout following PowerShell community practices
1. [SecretManagement Vault extension module](https://github.com/PowerShell/SecretManagement) layout following PowerShell community practices

Selections

* *[Selection]* CI/CD build integration:
    * [AWS](https://aws.amazon.com/codebuild/)
    * [GitHub Actions](https://help.github.com/actions)
    * [Azure Pipelines](https://azure.microsoft.com/services/devops/)
    * [AppVeyor](https://www.appveyor.com/)
    * [Bitbucket Pipelines](https://bitbucket.org/)
* *[Selection]* Build types for easy cross-platform testing
    * Windows PowerShell
    * Windows pwsh
    * Linux
    * MacOS
* [InvokeBuild](https://github.com/nightroman/Invoke-Build) tasks for validation / analysis / test / build automation
    * [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) code checks
        * *[Optional]* Code Style Enforcement (Stroustrup, OTBS, Allman)
    * [Pester](https://github.com/pester/Pester) Tests
        * Will run Unit / Infrastructure Tests if available
        * Generates Code Coverage Report
        * [Coverage Gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters) support
    * *[Optional]* Create Help using [platyPS](https://github.com/PowerShell/platyPS)
        * Markdown-based help
        * External XML help file generation
    * Build and artifact creation
* Helpful VSCode editor files
* *[Optional]* Helpful repository files
    * .gitignore
    * Project LICENSE (MIT / APACHE / GNU / ISC)
    * [Changelog](https://keepachangelog.com/en/1.0.0/)
    * Community files:
        * Code of Conduct
        * Contributing guidelines
        * Templates *(if supported)*
            * Issue Bug Report
            * Issue Feature Request
            * Pull Request
* *[Selection]* [Pester](https://github.com/pester/Pester) version selection. Choose between Pester version 5 or Pester version 4 for testing your project.
