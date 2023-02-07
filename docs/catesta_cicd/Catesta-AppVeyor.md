# Catesta - AppVeyor Integration

## Synopsis

Scaffolds a new PowerShell module project intended for CI/CD workflow using [AppVeyor](https://www.appveyor.com/).

## Getting Started

-------------------

*Note: It is important to have a clear understanding of what your module should support before you begin your project with Catesta. IIf your module is designed to be cross-platform or you plan to test different versions of PowerShell, it is recommended to run multiple build types to cover different scenarios. This will help you validate that your module works as expected on different platforms and environments.*

![Cross Platform](https://img.shields.io/badge/Builds-Windows%20PowerShell%20%7C%20Windows%20pwsh%20%7C%20Linux%20%7C%20MacOS-lightgrey)

-------------------

1. You will need an [AppVeyor account](https://ci.appveyor.com/login).
1. Create a new Project:
    * ![AppVeyor New Project](/assets/AppVeyor/appveyor_new_project.PNG)
1. Select where your code will come from:
    * ![AppVeyor Repository Selection](/assets/AppVeyor/appveyor_select_code_source.PNG)
    * Authenticate to your repository source as needed
1. Create your project using Catesta and select `[P] Appveyor` at the CICD prompt. *([Catesta Basics](../Catesta-Basics.md))*
1. Write the logic for your module (the hardest part)
    * All build testing can be done locally by navigating to `src` and running `Invoke-Build`
        * By default, this runs all tasks in the build file.
            * If you want to run a specific task from the build file you can provide the task name. For example, to just execute Pester tests for your project: `Invoke-Build -Task Test`
    * If using VSCode as your primary editor you can use VSCode tasks to perform various local actions
        * Open the VSCode Command palette
            * Shift+Command+P (Mac) / Ctrl+Shift+P (Windows/Linux) or F1
        * Type `Tasks: Run Task`
        * Select the task to run
            * Examples:
                * `task .` - Runs complete build (all tasks)
                * `task Test` - Invokes all Pester Unit Tests
                * `task Analyze` - Invokes Script Analyzer checks
                * `task DevCC` - Generates generate xml file to graphically display code coverage in VSCode using [Coverage Gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters)
1. *The comment based help in your functions will be used to generate/update markdown docs for your module in the docs folder.*
1. Add any module dependencies to your CI/CD bootstrap file: `actions_bootstrap.ps1`
1. Upload to your desired repository which now has a triggered/monitored build action.
1. Evaluate results of your build and display your AppVeyor badge proudly!

![AppVeyor project created by Catesta](/assets/AppVeyor/appveyor_build_results.PNG)

## Notes

Additional Reading:

* [Build configuration](https://www.appveyor.com/docs/build-configuration/)
* [Build environment](https://www.appveyor.com/docs/build-environment/)
* [Specializing matrix job configuration](https://www.appveyor.com/docs/build-configuration/#specializing-matrix-job-configuration)
* [appveyor.yml reference](https://www.appveyor.com/docs/appveyor-yml/)

## Diagrams

### AppVeyor Integration with GitHub

![Catesta PowerShell AppVeyor Diagram](/assets/AppVeyor/catesta_appveyor_diagram.png)

## Example Projects

* [PoshGram](https://github.com/techthoughts2/PoshGram)
