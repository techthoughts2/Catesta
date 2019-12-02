# Catesta - FAQ

## FAQs

### How do I display the badges for my project?

Badge examples:

* ![AWS CodeBuild Status](https://codebuild.us-west-2.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiTXdycWF3WnM4ME5Td21NVTI4bnRkS0hYMTF5aUxWUmNLNmNMc3Uyck5QZ29XNDRHZUFlaTc5Vk5vbHBVd3JOaTU1ZCtkRU5BSnYrdmlIWGhGbEEyVmhJPSIsIml2UGFyYW1ldGVyU3BlYyI6IlN5Qmx4WWovSUhtbyt3aUYiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)
  * *There is a Copy badge URL on your Build project page*
* [![GitHub Actions Build Status Windows pwsh Master](https://github.com/techthoughts2/Catesta/workflows/Catesta-Windows-pwsh/badge.svg?branch=master)](https://github.com/techthoughts2/Catesta/actions)
  * *Just replace the link with your repo*
* [![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/kech4dkqsrb9xuet/branch/master?svg=true)](https://ci.appveyor.com/project/techthoughts2/appveyortest/branch/master)
  * *Under ProjectName - Settings - Badges*
* [![Build Status](https://dev.azure.com/TechThoughts2/AzureTest/_apis/build/status/techthoughts2.AzureTest?branchName=master)](https://dev.azure.com/TechThoughts2/AzureTest/_build/latest?definitionId=1&branchName=master)
  * *Found under DevOps Project - Pipelines - Builds - ... - Status Badge*
  * Unfortunately by default badge access is restricted to only authenticated access. This can be disabled at the organization and project level if you wish to display on a GitHub repo:
    * *Organization Settings - Settings - Disable anonymous access to badge*
    * *Project Settings - Settings - Disable anonymous access to badge*

### I created a fresh project and my build process is already showing a failure

By default a freshly created module already violates one PSScriptAnalyzer rule:

*PSUseToExportFieldsInManifest - Do not use wildcard or $null in this field.*

So, if you commit a freshly created Catesta project - this is normal, and the build / test validation process is doing it's job. You'll need to correct your manifest to not use wildcards.

Typical error seen in build process:

```
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
