# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - *breaking changes introduced*

- Catesta template module changes
    - `New-PowerShellProject` has been removed and has been replaced with `New-ModuleProject` - ***Breaking Change***
    - `New-ModuleProject` improvements:
        - Major enhancements to `ShouldProcess` and `WhatIf` functionality
    - `New-VaultProject` - ***Breaking Change***
        - `-CICD` parameter removed, several other parameters added
        - Major enhancements to `ShouldProcess` and `WhatIf` functionality
        - Updated help verbiage
    - Separate CI/CD PowerShell module manifests have been consolidated into a single module manifest - *potential breaking change*
    - Moved generic repo file samples in `Resources` to `RepoFiles`
    - `CHANGELOG` now generates to the `docs` folder for all repository choices
        - Previous behavior was that this was only supported for GitHub repo selection and generated to the `.github` directory.
    - `tasks.json`
        - Added new task: `Infra-Single-Detailed` which is capable of running Integration tests against individual test files
    - CI/CD Changes:
        - AWS CodeBuild:
            - Significant improvements to `PowerShellCodeBuildCC.yml`
                - Added new parameter to allow primary branch name to be specified. Defaults to `main`
                - Merged S3 artifact buckets into template
                - Updated to use `${AWS::Partition}` where appropriate
                - Added more robust tagging of project resources
                - Added `AWS::Logs::LogGroup` for each trigger lambda with a 60 day retention so that logs don't persist forever
            - Removed `S3BucketsForPowerShellDevelopment.yml` as it is now combined with `PowerShellCodeBuildCC.yml`
            - Significant improvements to `PowerShellCodeBuildGit.yml`
                - Added support for Bitbucket repo source
                    - Added new CFN parameter RepositoryType
                    - CodeBuild projects will now be sourced from BITBUCKET if Bitbucket repo is chosen
        - Appveyor CI/CD changes:
            - Added Tests reports capabilities. Tests reports are now viewable from Appveyor builds.
        - GitHub Actions CI/CD changes:
            - Build will now ignore `docs` folder and all `.md` file updates. Builds will not be triggered if only these are updated.
            - Updated `checkout@v2` to `checkout@v3`
            - Updated `upload-artifact@v2` to `upload-artifact@v3`
        - Added support for Bitbucket Pipelines CI/CD choice
        - Added support for GitLab CI/CD Pipelines choice
    - Added support for Azure Repo choice
    - Added support for GitLab Repo choice
    - All scaffold projects using a repository now get a basic `README.md` generated for the project
    - Minor updates and improvements to both vault and module `*.build.ps1` files
    - Added integration for Read the Docs using two different themes: readthedocs & material
    - Pester bumped from `5.4.0` to `5.4.0`
    - After community feedback around the interchangeable use of Infrastructure/Integration test references - all references now utilize Integration - *potential breaking change*
- Catesta primary module changes
    - Complete overhaul of Catesta documentation
        - Added support for Read the Docs integration using the Material for MkDocs theme.
            - Worked on improvements to the Catesta documentation. Updated diagrams, rewrote all current documentation and added a lot of new documentation.
    - Greatly enhanced infrastructure test suite. Infra tests now actively deploy many different configurations and validate successful module and vault scaffolds.
    - Moved `CHANGELOG.md` from `.github` directory to `docs` directory
        - Updated `.psd1` to link to new CHANGELOG url
    - `tasks.json`
        - Added new task: `Infra-Single-Detailed` which is capable of running Integration tests against individual test files
    - Addressed bug in build file where `Build` task was failing if docs folder has not already been created
    - GitHub actions will now ignore `docs` folder and all `.md` file updates. `doctesting` branch will also now be ignored and will not trigger builds.
    - Pester bumped from `5.4.0` to `5.4.0`
    - All Infra/Infrastructure references changed to Integration

## [1.3.0] - (Never released)

- Catesta template module changes
    - Vanilla module (aka `ModuleOnly` CICD choice) will now prompt user to decide if they want InvokeBuild tasks for PlatyPS help generation and code style enforcement.
    - Vanilla module (aka `ModuleOnly` CICD choice) will no longer prompt for helpful VSCode files creation.
    - Added a template file for GitHub `SECURITY.md`
- Catesta primary module changes
    - Added a `SECURITY.md` file for the Catesta project

## [1.2.6]

- Catesta template module changes
    - Fixed casing issue in all templates that caused Catesta to have an issue on certain Linux distros
    - Fixed bug where vault templates were referencing an incorrect version of Microsoft.PowerShell.SecretManagement
    - InvokeBuild bumped from `5.9.11` to `5.10.2`
    - PSScriptAnalyzer bumped from `1.20.0` to `1.21.0`
- Catesta primary module changes
    - Added infrastructure tests to check for casing violations
    - InvokeBuild bumped from `5.9.11` to `5.10.2`
    - PSScriptAnalyzer bumped from `1.20.0` to `1.21.0`

## [1.2.3]

- Minor spelling corrections throughout
- Catesta template module changes
    - InvokeBuild bumped from `5.9.11` to `5.9.12`
    - All build files: replaced use of `[PesterConfiguration]::new()` with `New-PesterConfiguration`
- Catesta primary module changes
    - InvokeBuild bumped from `5.9.11` to `5.9.12`
    - Build file: replaced use of `[PesterConfiguration]::new()` with `New-PesterConfiguration`
    - Removed use of `Assert-MockCalled` from all tests

## [1.2.0]

- Catesta template module changes
    - Improved plaster references throughout Catesta to better handle situations when a user choose Pester 4 vs Pester 5. While this affects a few minor files it primarily focuses on updating the way VSCode tasks are engaged.
        - `tasks.json`
            - `PesterTest`, `Pester-Single-Coverage`, `Pester-Single-Detailed`, `DevCC-Single` tasks no longer use legacy parameters for Pester 5
            - Updated to no longer reference the Module name directly. Instead `${workspaceFolderBasename}` is used throughout the tasks file now.
    - All bootstrap files:
        - Pester bumped from `5.3.1` to `5.4.0`
        - InvokeBuild bumped from `5.8.8` to `5.9.11`
        - Microsoft.PowerShell.SecretManagement bumped from `1.1.1` to `1.1.2`
    - AWS CodeBuild CI/CD changes:
        - `PowerShellCodeBuildGit.yml`
            - `aws/codebuild/windows-base:2019-1.0` to  `aws/codebuild/windows-base:2019-2.0`
            - `aws/codebuild/standard:5.0` to `aws/codebuild/standard:6.0`
            - All Lambdas updated from `Runtime: python3.6` to `Runtime: python3.9`
        - `PowerShellCodeBuildGit.yml`
            - `aws/codebuild/windows-base:2019-1.0` to  `aws/codebuild/windows-base:2019-2.0`
            - `aws/codebuild/standard:5.0` to `aws/codebuild/standard:6.0`
        - buildspec updates
            - Updated runtime version from `dotnet: 3.1` to `dotnet: 6.0`
                - `buildspec_pwsh_linux.yml`
                - `buildspec_pwsh_windows.yml`
        - `install_modules.ps1`
            - AWS.Tools.Common bumped from `4.1.17.0` to `4.1.133`
    - Minimum version of `Microsoft.PowerShell.SecretManagement` for vault builds is now `1.3.0`
- Catesta primary module changes
    - `tasks.json`
        - `PesterTest`, `Pester-Single-Coverage`, `Pester-Single-Detailed`, `DevCC-Single` tasks no longer use legacy parameters for Pester 5
    - Pester bumped from `5.3.1` to `5.4.0`
    - InvokeBuild bumped from `5.8.8` to `5.9.11`

## [1.0.0]

- Catesta template module changes
    - All build yaml files - added commented line for easily retrieving modules/variables/env variables are available in the build image
    - All bootstrap files:
        - Pester bumped from `5.2.2` to `5.3.1`
        - InvokeBuild bumped from `5.8.0` to `5.8.8`
        - PSScriptAnalyzer bumped from `1.19.1` to `1.20.0`
        - Microsoft.PowerShell.SecretManagement bumped from `1.0.0` to `1.1.1`
    - AWS CodeBuild CI/CD changes:
        - `PowerShellCodeBuildGit.yml`
            - Now enables user to specify Branch name on Webhook filter. Default is set to main.
            - Updated reference links
        - `install_modules.ps1`
            - Minor spelling correction
            - AWS.Tools.Common bumped from `4.1.3.0` to `4.1.17.0`
        - `New-PowerShellProject.ps1` & `New-VaultProject.ps1`
            - Minor formatting updates
    - Appveyor CI/CD changes:
        - `appveyor.yml`
            - Updated windows images to more recent versions
                - Windows Powershell from 2017 to 2019
                - PowerShell from 2019 to 2022
    - Azure DevOps CI/CD changes:
        - `azure-pipelines.yml`
            - ubuntu-latest
                - No longer installs PowerShell core (PowerShell 7 is now native to image)
                - switched from script using `pwsh -c ''` style to native `-pwsh: |` call
            - macOS-latest
                - switched from script using `pwsh -c ''` style to native `-pwsh: |` call
    - `tasks.json`
        - Adjusted formatting
        - Updated documentation
        - Updated references to align with new tasks requirements
- Catesta primary module changes
    - **Updated primary branch name from master to main**
        - Updated references from master to main throughout repository
    - Pester bumped from `5.2.2` to `5.4.0`
    - InvokeBuild bumped from `5.8.0` to `5.9.11`
    - PSScriptAnalyzer bumped from `1.19.1` to `1.20.0`
    - `tasks.json`
        - Adjusted formatting
        - Updated documentation
        - Updated references to align with new tasks requirements
    - `Catesta.build.ps1`
        - Updated pester module import to use a min/max value
    - Documentation updates
        - Minor README corrections/updates
        - AWS
            - Updated `Catesta-AWS.md`
            - Re-did several AWS diagrams and included raw drawio diagrams
            - Updated screenshots
        - AppVeyor
            - Updated `Catesta-AppVeyor.md`
            - Added diagram
            - Updated screenshots
        - GitHub Actions
            - Updated `Catesta-GHActions.md`
            - Added diagram
        - Azure DevOps
            - Updated `Catesta-Azure.md`
            - Added diagram
        - Updated `Catesta-FAQ.md`
        - Updated `Catesta-Vault-Extension.md`

## [0.12.4]

- `*.build.ps1`
    - Test task now correctly references `$script:UnitTestsPath` instead of overall `$script:TestsPath`
    - DevCC task now correctly references `$script:UnitTestsPath` instead of `'Tests\Unit'`
    - Infra task now correctly references `$script:InfraTestsPath` instead of `'Tests\Infrastructure'`
    - Adjusted ValidateRequirements task to work with `[version]` type when verifying minimum version of PowerShell to validate
    - Added new BuildNoInfra task for building module without running Infra tests
- `tasks.json`
    - Added new VSCode tasks
        - BuildNoInfra - runs BuildNoInfra tasks
        - Pester-Single-Coverage - enables user to run pester test for single function and get code coverage report
        - Pester-Single-Detailed - enables user to run pester test for single function and get detailed results
        - DevCC-Single - enables user to generate cov.xml coverage file for single function

## [0.12.1]

- Changed the Pester 5 minimum version requirement from `v5.0.0` to `v5.2.2`
- Updated CloudFormation GitHub template to use CodeBuild image version 5.0.

## [0.12.0]

- Catesta template module changes
    - **Added support for Pester 5** - you can now choose either Pester 4 or Pester 5 in a prompt when creating a module or vault with Catesta.
        - Some CICD containers have the Pester module loaded into memory. Added explicit remove in the build file to account for this.
        - Moved Pester import handling from the buildspec/yaml to InvokeBuild
    - Updated pester tests that were using legacy Should syntax (without dashes)
    - Fixed `tasks.json` VSCode file to be valid json (was missing comma)
    - Added prompt on ModuleOnly module type to prompt user if they want helpful .vscode files for their module project
    - Catesta now deploys the initial sample module in a style that better reflects a real-world module
        - The private sample function was renamed to Get-Day and gets the day of the week
        - The public sample function now returns hello world with the day of the week included
        - Sample tests are now created for these sample functions in the appropriate public/private folders under the Tests/Unit folder
        - Sample tests now actually test the sample functions
    - AppVeyor CI/CD changes:
        - Updated Ubuntu image from `Ubuntu1804` to `Ubuntu2004`
    - Azure DevOps CI/CD changes:
        - The latest macOS image [now includes PowerShell](https://github.com/actions/virtual-environments/blob/main/images/macos/macos-10.15-Readme.md) by default - removed step in yaml to install PowerShell.
    - AWS CodeBuild CI/CD changes:
        - CB Linux Image updated in CFN from `Image: aws/codebuild/standard:4.0` to use latest: `Image: aws/codebuild/standard:5.0`
        - Updated buildspec_pwsh_windows.yml to use the new syntax for installing PowerShell 7.

      ```bash
      runtime-versions:
        dotnet: 3.1
      ```

        - Added additional documentation links to the buildspec files
    - InvokeBuild bumped from `5.6.1` to `5.8.0`
- Catesta primary module changes
    - Updated pester tests that were using Legacy Should syntax (without dashes)
    - Updated pester tests to support v5+
    - InvokeBuild bumped from `5.6.1` to `5.8.0`

## [0.11.0]

- Adjusted vault templates to include the new capabilities in SecretManagement RC2
    - New optional cmdlets
    - New metadata parameter on several cmdlets
- Added new optional vault parent .psm1 example file
- Catesta now references the GA version of `Microsoft.PowerShell.SecretManagement`
- Added best practice naming suggestion to `New-VaultProject`
- Corrected verbiage on several commands to properly reflect which module project was being scaffold
- Fixed bug where module would fail to scaffold on Linux systems due to case sensitivity of path

## [0.10.2]

- Adjusted addition of .gitignore file to be indirectly referenced due to PSGallery behavior of not including the .gitignore in the resource files

## [0.10.1]

- No change, redeployment due to missing .gitignore file in PowerShell gallery 0.10.2 version.

## [0.10.0]

- New features:
    - Added **New-VaultProject** - Catesta now supports creating a PowerShell SecretManagement vault module project that adheres to community best practices.
- Bug fixes:
    - Fixed bug in plaster manifests where repository template options were not being presented as a choice
    - Fixed bug in *.build.ps1 causing build to fail
        - This bug was related to the overwrite of the parent level md docs. Build would fail if run before markdown help had been generated.
- Updates:
    - plaster manifest versions will now match Catesta module version
    - Added additional basic manifest checks to *PSModule*-Module.Tests.ps1
    - Updated buildspec_pwsh_windows.yml to utilize dotnet pwsh 7 install
    - For all CI/CD actions using Windows PowerShell the latest NuGet and PowerShellGet will be installed.

## [0.9.7]

- Catesta template module changes
    - Fixed missing !Sub Intrinsic function reference in PowerShellCodeBuildGit.yml
    - Improved error message when modules fail to install with install_modules.ps1 and actions_bootstrap.ps1
    - Improved output message when missing help information found during *.build.ps1
    - Improved PSModule.build.ps1
        - Resolved bug where CreateMarkdownHelp fails if module not imported
        - Added additional checks for missing markdown documentation
        - Added build steps which import the module manifest explicitly
        - Corrected output in AnalyzeTests to not write out the word green
        - Parent level markdown docs will now be updated on each build
    - Adjusted ExportedFunctions.Tests.ps1 to check for included example rather than example count
- Catesta primary module changes
    - Improved PSModule.build.ps1
        - Resolved bug where CreateMarkdownHelp fails if module not imported
        - Added additional checks for missing markdown documentation
        - Added build steps which import the module manifest explicitly
        - Adjusted ExportedFunctions.Tests.ps1 to check for included example rather than example count
- Updated a few areas of documentation/help to provide more clarification
- Updated .vscode settings to use `${workspaceFolderBasename}` instead of hard-coded Catesta name

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
        - For windows PowerShell based build added line to remove Pester 5 and Import Pester 4.10.1 specifically.
        - Added support for attaching build artifact of Archived module build
    - GitHub Actions
        - Updated actions_bootstrap.ps1 to install latest module versions
        - Added name to all workflows for check out step
        - Changed checkout on all workflows from v1 to v2
        - Added pester test results artifact upload to all workflows
        - Renamed windows workflow that was using pwsh to ActionsTest-Windows-pwsh-Build
        - For windows PowerShell based build added line to remove Pester 5 and Import Pester 4.10.1 specifically.
    - Appveyor Updates
        - Updated actions_bootstrap.ps1 to install latest module versions
        - For windows PowerShell based build added line to remove Pester 5 and Import Pester 4.10.1 specifically.
        - Added support for all appveyor builds to include PesterTest, CodeCoverage, and build artifacts
- Editor updates
    - Added InvokeBuild tasks to tasks.json

## [0.8.12]

- Updated Pester and InvokeBuild module references to latest versions
- AWS:
    - buildspec_pwsh_windows.yml now uses PowerShell 7 instead of PowerShell 6.3
- Minor build updates:
    - Updated tasks.json for better Infrastructure with InvokeBuild

## [0.8.10]

- Added link to the online function documentation for New-PowerShellProject as its first link so it will open directly when `Get-Help -Name New-PowerShellProject -Online` is called.

## [0.8.9]

- Bug fix - After build the Imports.ps1 file was being left in the artifacts folder. It will now be removed after build is completed.
- Bug fix - when AWS CI/CD was chosen and an S3 bucket was provided for module install the modules were not correctly downloading to the build container. Fixed temp path issue and bucket name quotes added.
- Bug fix - Build file when running in 5.1 was not honoring the "*.ps1" filter and would pick up files like ps1xml. Changed to a regex so that both 5.1 and higher versions work. This was causing ps1xml files to merged into the psm1 during build.
- Bug fix - Fixed Module name not being replaced in SampleInfraTest.Tests.ps1

## [0.8.5]

- Corrected bug where AWS CI/CD choice was not correctly populating S3 bucket name for install_modules.ps1
- Bumped module references to latest versions

## [0.8.4]

- Added Manifest File to Invoke-Build buildheader
- Added Manifest version to Invoke-Build buildheader
- Corrected bug in Catesta's build process that wasn't displaying Manifest info in the buildheader

## [0.8.3]

- Moved Infrastructure tests from pre-build to post build
    - Included sample Infrastructure test that references artifacts location for import for post-build import.
- Corrected spelling error in Tests folder: Infrastructure to Infrastructure

## [0.8.0]

- Initial release.
