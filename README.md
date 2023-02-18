# Catesta

[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1+-purple.svg)](https://github.com/PowerShell/PowerShell) [![PowerShell Gallery][psgallery-img]][psgallery-site] ![Cross Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey) [![License][license-badge]](LICENSE) [![Documentation Status](https://readthedocs.org/projects/catesta/badge/?version=latest)](https://catesta.readthedocs.io/en/latest/?badge=latest)

[psgallery-img]:   https://img.shields.io/powershellgallery/dt/Catesta?label=Powershell%20Gallery&logo=powershell
[psgallery-site]:  https://www.powershellgallery.com/packages/Catesta
[license-badge]:   https://img.shields.io/github/license/techthoughts2/Catesta

<p align="center">
    <img src="./docs/assets/Catesta.PNG" alt="Catesta Logo" >
</p>

Branch | Windows - PowerShell | Windows - pwsh | Linux | MacOS
--- | --- | --- | --- | --- |
main | ![Build Status Windows PowerShell Main](https://github.com/techthoughts2/Catesta/workflows/Catesta-Windows-PowerShell/badge.svg?branch=main) | ![Build Status Windows pwsh Main](https://github.com/techthoughts2/Catesta/workflows/Catesta-Windows-pwsh/badge.svg?branch=main) | ![Build Status Linux Main](https://github.com/techthoughts2/Catesta/workflows/Catesta-Linux/badge.svg?branch=main) | ![Build Status MacOS Main](https://github.com/techthoughts2/Catesta/workflows/Catesta-MacOS/badge.svg?branch=main)
Enhancements | ![Build Status Windows PowerShell Enhancements](https://github.com/techthoughts2/Catesta/workflows/Catesta-Windows-PowerShell/badge.svg?branch=Enhancements) | ![Build Status Windows pwsh Enhancements](https://github.com/techthoughts2/Catesta/workflows/Catesta-Windows-pwsh/badge.svg?branch=Enhancements) | ![Build Status Linux Enhancements](https://github.com/techthoughts2/Catesta/workflows/Catesta-Linux/badge.svg?branch=Enhancements) | ![Build Status MacOS Enhancements](https://github.com/techthoughts2/Catesta/workflows/Catesta-MacOS/badge.svg?branch=Enhancements)

## Synopsis

Catesta is a PowerShell module and vault project generator. It uses templates to rapidly scaffold test and build integration for a variety of CI/CD platforms.

## Description

Catesta enables you to quickly scaffold a [PowerShell module](https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-script-module?view=powershell-7) or [Vault extension](https://github.com/PowerShell/SecretManagement) project with proper formatting, test + build automation, CI/CD integration, with just one line of code.

### Features

* Quickly scaffold a new PowerShell module or SecretManagement vault project that adheres to best practices and community guidelines.
* Easily integrate your project with a variety of CI/CD platforms, including AWS, Azure, GitHub, AppVeyor, Bitbucket, and GitLab.
* Cross-platform testing to ensure functionality across different environments.
* Generate [Pester](https://github.com/pester/Pester) tests to help you get started with unit testing.
* Automatically create a build file to analyze your code for best practices and styling, run Pester tests, create PowerShell help, and combine your functions together to build your project for publication.
* Generate resources you need to trigger CI/CD builds for your module and configure it with your preferred platform.
* Scaffold your project for hosting on your preferred platform and provide easy integration with Read the Docs for professional-looking documentation.

## Getting Started

### Documentation

Documentation for Catesta is available at: [https://www.catesta.dev](https://www.catesta.dev)

### Installation

```powershell
# Install Catesta from the PowerShell Gallery
Install-Module -Name Catesta -Repository PSGallery -Scope CurrentUser
```

### Quick start

### PowerShell Module

```powershell
# Scaffolds a PowerShell module project with customizable CI/CD integration options
New-ModuleProject -DestinationPath $outPutPath
```

### SecretManagement Vault Extension Module

```powershell
# Scaffolds a PowerShell SecretManagement vault project with customizable CI/CD integration options
New-VaultProject -DestinationPath $outPutPath
```

## Contributing

If you'd like to contribute to Catesta, please see the [contribution guidelines](.github/CONTRIBUTING.md).

## License

Catesta is licensed under the [MIT license](LICENSE).
