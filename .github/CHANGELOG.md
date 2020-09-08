# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.4]

- Catesta template module changes
  - Fixed missing !Sub Intrinsic function reference in PowerShellCodeBuildGit.yml
  - Improved error message when modules fail to install with install_modules.ps1 and actions_bootstrap.ps1
  - Improved output message when missing help information found during *.build.ps1
  - Improved PSModule.build.ps1
    - Resolved bug where CreateMarkdownHelp fails if module not imported
    - Added additional checks for missing markdown documentation
    - Added build steps which import the module manifest explicitly
- Catesta primary module changes
  - Improved PSModule.build.ps1
    - Resolved bug where CreateMarkdownHelp fails if module not imported
    - Added additional checks for missing markdown documentation
    - Added build steps which import the module manifest explicitly

## [0.9.0]

- Catesta primary module changes
  - ExportedFunctions.Tests.ps1 - Corrected 2 bugs in Exported Commands test
    - Didn't correctly identify all commands
    - Didn't support example checks in PowerShell 5.1
  - Catesta manifest updates
    - Updated to use more recent versions of required modules
    - Sorted tags alphabetically
  - Catesta.build.ps1
    - Updated verbiage in ValidateRequirements to correctly reflect version of PowerShell required
    - Updated Add-BuildTask Test to output Pester test outputfile to testOutput location
    - Updated Add-BuildTask Test to correctly output Pester code coverage file
  - Updated tasks.json to reference ${workspaceFolder}
- Catesta template module changes
  - Build updates
    - Corrected 2 bugs in Exported Commands test
      - Didn't correctly identify all commands
      - Didn't support example checks in PowerShell 5.1
    - PSModule.build.ps1
      - Updated verbiage in ValidateRequirements to correctly reflect version of PowerShell required
      - Updated Add-BuildTask Test to output Pester test outputfile to testOutput location
      - Updated Add-BuildTask Test to correctly output Pester code coverage file
  - AWS Updates
    - Updated CFN deployments to use latest CodeBuild Images (2019)
      - windows-base:1.0 --> windows-base:2019-1.0
    - Updated buildspec_pwsh_windows.yml to download PowerShell 7.0.3 instead of 7.0.0
    - Updated module references to latest version
    - Added AWS.Tools.Common to install_modules.ps1
    - Added $PSVersionTable to pre_build commands of all yml files
    - Added support for Pester report groups in CodeBuild
    - Added support for Code Coverage reports groups in CodeBuild
  - Azure Updates
    - Added clarifying display names to each task
    - Added support for publishing test results
    - Added support for Code Coverage report
    - Updated actions_bootstrap.ps1 to install latest module versions
    - For windows powershell based build added line to remove Pester 5 and Import Pester 4.10.1 specifically.
    - Added support for attaching build artifact of Archived module build
  - GitHub Actions
    - Updated actions_bootstrap.ps1 to install latest module versions
    - Added name to all workflows for check out step
    - Changed checkout on all workflows from v1 to v2
    - Added pester test results artifact upload to all workflows
    - Renamed windows workflow that was using pwsh to ActionsTest-Windows-pwsh-Build
    - For windows powershell based build added line to remove Pester 5 and Import Pester 4.10.1 specifically.
  - Appveyor Updates
    - Updated actions_bootstrap.ps1 to install latest module versions
    - For windows powershell based build added line to remove Pester 5 and Import Pester 4.10.1 specifically.
    - Added support for all appveyor builds to include PesterTest, CodeCoverage, and build artifacts
- Editor updates
  - Added InvokeBuild tasks to tasks.json

## [0.8.12]

- Updated Pester and InvokeBuild module references to latest versions
- AWS:
  - buildspec_pwsh_windows.yml now uses PowerShell 7 instead of PowerShell 6.3
- Minor build updates:
  - Updated tasks.json for better integration with InvokeBuild
1
## [0.8.10]

- Added link to the online function documentation for New-PowerShellProject as its first link so it will open directly when `Get-Help -Name New-PowerShellProject -Online` is called.

## [0.8.9]

- Bug fix - After build the Imports.ps1 file was being left in the artifacts folder. It will now be removed after build is completed.
- Bug fix - when AWS CI/CD was chosen and an S3 bucket was provided for module install the modules were not correctly downloading to the build container. Fixed temp path issue and bucket name quotes added.
- Bug fix - Build file when running in 5.1 was not honoring the "*.ps1" filter and would pick up files like ps1xml. Changed to a regex so that both 5.1 and higher versions work. This was causing ps1xml files to merged into the psm1 during build.
- Bug fix - Fixed Module name not being replaced in SampleInfraTest.Tests.ps1

## [0.8.5]

- Corrected bug where AWS CI/CD choice was not correctly populating S3 bucketname for install_modules.ps1
- Bumped module references to latest versions

## [0.8.4]

- Added Manifest File to Invoke-Build buildheader
- Added Manifest version to Invoke-Build buildheader
- Corrected bug in Catesta's build process that wasn't displaying Manifest info in the buildheader

## [0.8.3]

- Moved Infrastructure tests from pre-build to post build
  - Included sample Infrastructure test that references artifacts location for import for post-build import.
- Corrected spelling error in Tests folder: Infrastrcuture to Infrastructure

## [0.8.0]

- Initial release.
