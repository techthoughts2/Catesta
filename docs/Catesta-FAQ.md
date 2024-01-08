# Catesta - FAQ

## How do I display the badges for my project

Badge examples:

- **CodeBuild**: ![AWS CodeBuild Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiL2FvTzZsNGFoL1VTTk1UOGE3WXlwSVFRT3BTWngzc1czdVZLTEpNYWJld2xSbS9Ea3R0b3ZETm96Zk5md2ZXMVUwNXZnSnlaRlpuWUJldzdGMENpemRjPSIsIml2UGFyYW1ldGVyU3BlYyI6Ikl3T3VwdU43UUxya0J1SVciLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
    - *There is a Copy badge URL on your Build project page*

    ```plain
    ![AWS CodeBuild Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiL2FvTzZsNGFoL1VTTk1UOGE3WXlwSVFRT3BTWngzc1czdVZLTEpNYWJld2xSbS9Ea3R0b3ZETm96Zk5md2ZXMVUwNXZnSnlaRlpuWUJldzdGMENpemRjPSIsIml2UGFyYW1ldGVyU3BlYyI6Ikl3T3VwdU43UUxya0J1SVciLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
    ```

- **GitHub Actions**: [![GitHub Actions Build Status Windows pwsh Main](https://github.com/techthoughts2/Catesta/workflows/Catesta-Windows-pwsh/badge.svg?branch=main)](https://github.com/techthoughts2/Catesta/actions)
    - *Just replace the link with your repo*

    ```plain
    [![GitHub Actions Build Status Windows pwsh Main](https://github.com/techthoughts2/Catesta/workflows/Catesta-Windows-pwsh/badge.svg?branch=main)](https://github.com/techthoughts2/Catesta/actions)
    ```

- **Appveyor**: [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/kech4dkqsrb9xuet/branch/master?svg=true)](https://ci.appveyor.com/project/techthoughts2/appveyortest/branch/master)
    - *Under ProjectName - Settings - Badges*

    ```plain
    [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/kech4dkqsrb9xuet/branch/master?svg=true)](https://ci.appveyor.com/project/techthoughts2/appveyortest/branch/master)
    ```

- **Azure Pipelines**: [![Azure Pipelines Build Status](https://dev.azure.com/TechThoughts2/AzureTest/_apis/build/status/techthoughts2.AzureTest?branchName=master)](https://dev.azure.com/TechThoughts2/AzureTest/_build/latest?definitionId=1&branchName=master)
    - *Found under DevOps Project - Pipelines - Builds - ... - Status Badge*
    - Unfortunately by default badge access is restricted to only authenticated access. This can be disabled at the organization and project level if you wish to display on a GitHub repo:
        - *Organization Settings - Settings - Disable anonymous access to badge*
        - *Project Settings - Settings - Disable anonymous access to badge*

    ```plain
    [![Azure Pipelines Build Status](https://dev.azure.com/TechThoughts2/AzureTest/_apis/build/status/techthoughts2.AzureTest?branchName=master)](https://dev.azure.com/TechThoughts2/AzureTest/_build/latest?definitionId=1&branchName=master)
    ```

- **Bitbucket Pipeline**: Bitbucket [does not support](https://jira.atlassian.com/browse/BCLOUD-12797) project status / build status badges at this time.
- **GitLab CICD Pipeline**: [![GitLab Pipeline Build Status](https://gitlab.com/techthoughts2/gitlabgl/badges/main/pipeline.svg)](https://gitlab.com/techthoughts2/gitlabgl/commits/main)
    - *Under ProjectName - Settings - General - Badges*
    - Create a new badge by following the [GitLab Badges](https://docs.gitlab.com/ee/user/project/badges.html) documentation.
    - Once your badge is created you can replace the variables with actual paths to your repository as shown below.
    - If your repo is private, your badge will not display on other sites or embeds
    - *Note: You don't technically need to add your badge to your README as GitLab allows you to place badges directly into the project*

    ```plain
    [![GitLab Pipeline Build Status](https://gitlab.com/techthoughts2/gitlabgl/badges/main/pipeline.svg)](https://gitlab.com/techthoughts2/gitlabgl/commits/main)
    ```

## I'm ready to publish my project

If your builds pass and you are ready to publish your module:

- In your development environment InvokeBuild either the `.`, or `BuildNoIntegration` tasks.
    - This will run all local analysis, unit tests, and prepare your module for merge and publication
    - *If you selected platyPS to generate help documentation during the build process the comment based help in your functions will be used to generate/update markdown docs for your module in the docs folder.*
- Once the build is complete your *ready to publish* project can be found in `src/Archive`
- Move your module files into a location that can be sourced by `$env:PSModulePath` and then run [Publish-Module](https://learn.microsoft.com/powershell/module/powershellget/publish-module)

## I created a fresh module project and my build process is already showing some  failures

By default a freshly created PowerShell module already violates one best practice:

The ```FunctionsToExport = '*'``` in your manifest file will be set to a wild card.

- This violates a PSScriptAnalyzer rule:

    - *PSUseToExportFieldsInManifest - Do not use wildcard or $null in this field.*
    - Typical error seen in build process:

        ```plain
        ===============================================================================
        Task /./Analyze : Invokes PSScriptAnalyzer against the Module source path
        At D:\a\ActionsTest\ActionsTest\src\ActionsTest.build.ps1:122
            Performing Module ScriptAnalyzer checks...

        RuleName                            Severity     ScriptName Line  Message
        --------                            --------     ---------- ----  -------
        PSUseToExportFieldsInManifest       Warning      ActionsTes 72    Do not use wildcard or $null in this field.
                                                        t.psd1           Explicitly specify a list for FunctionsToExport.
        PSUseToExportFieldsInManifest       Warning      ActionsTes 75    Do not use wildcard or $null in this field.
                                                        t.psd1           Explicitly specify a list for CmdletsToExport.
        PSUseToExportFieldsInManifest       Warning      ActionsTes 81    Do not use wildcard or $null in this field.
        ```

- This will also fail a Pester test for exported functions:

    ```plain
    [-] jaketest.Exported Commands.Number of commands.Exports the same number of public functions as what is listed in the Module Manifest 67ms (52ms|14ms)
    at $manifestExported.Count | Should -BeExactly $moduleExported.Count
    ```

So, if you commit a freshly created Catesta project - this is normal, and the build / test validation process is doing it's job. You'll need to correct your manifest to not use wildcards.

## How does Catesta handle help creation

Catesta leverages [platyPS](https://github.com/PowerShell/platyPS) for external help creation.

The *source of truth* for all help in your project is derived from the comment base help in your public functions (*Functions located inside your public folder*).

During the help generation process your functions in the public folders are evaluated and the comment based help is used to create markdown files using [platyPS](https://github.com/PowerShell/platyPS). Once these markdown files are created, platyPS is used again to craft an external xml based help file in MAML format (common for PowerShell use).

During the build process all functions are combined into the .psm1. All comment based help is stripped at this time and replaced with a reference to the external xml file.

Your comment based help continues to persist in your public functions folder and remains the source of truth. If help is updated or changed, it will be updated on the next build that you run in the same fashion.

Help workflow:

Craft excellent comment based help -> Run build -> markdown files generated -> xml file generated from markdown -> functions combined to psm1 -> comment based help stripped in psm1 and replaced with reference to external xml file -> parent level markdown docs updated for easy documentation reading in markdown on your repo.

## Why does Catesta not support help creation for Vault Extension projects

Because of the nested nature of the vault extension, and how user facing functions are surfaced up, Catesta does not support automated help generation via platyPS for Vault extension projects.

## I created a fresh vault extension project and my build process is already showing a failure

By default a freshly created vault extension module already violates several PSScriptAnalyzer rules:

- *PSUseToExportFieldsInManifest*
- *PSReviewUnusedParameter*

This is normal, and the build / test validation process is doing it's job. You'll need to correct your manifest to not use wildcards. You will also need to add content to your extension psm1 to actually engage the variables.

## Why is it called Catesta

It's a unique and meaningful name, combining two Latin words - "catasta" meaning scaffold, and "testa" meaning shell. This combination perfectly represents the purpose of Catesta, which is to provide a scaffold for PowerShell projects.
