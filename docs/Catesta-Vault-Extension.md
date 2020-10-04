# Catesta - Vault Extension Module

## Synopsis

Scaffolds a [PowerShell SecretManagement vault module project](https://github.com/PowerShell/SecretManagement) for use with desired CICD platform for easy cross platform PowerShell development.

## Getting Started

*Note: Before getting started you should have a basic idea of what you expect your module to support. If your module is cross-platform, or you want to test different versions of PowerShell you should run multiple build types.*

| Windows PowerShell  | Windows pwsh | Linux pwsh |
| ------------- | ------------- | ------------- |

*Note 2: Consult the CI/CD specific documentation on the main README for details on specific CI/CD workflows. This example will cover a basic Vault Extension module project creation.*

1. Create your vault extension project using Catesta

    ```powershell
    New-VaultProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly
    ```

    1. The Plaster logo will be displayed and you will see your first prompt
    1. **Enter the name of the module:** *Name of your module*
    1. **Enter a description for the module:** *Description of what your module does*
    1. **Enter the version number of the module (0.0.1)**: *Starting version #*
    1. **Enter your full name**: *Module author name*
    1. **Would you like to generate a Changelog file?**
    1. **Would you like to generate helpful repository files?** *GitHub issue/pullrequest/feature files*
    1. **Select a License for your module. (Help deciding: [https://choosealicense.com/](https://choosealicense.com/))**
    1. **Would you like to generate a Code of Conduct file?**
    1. **Would you like to generate a Contributing guidelines file?**
    1. **Would you like to specify a coding style for the project? [S] Stroustrup  [O] OTBS  [A] Allman  [N] None  [?] Help (default is "S"):** *The preferred coding style for the project*
1. Write a kick-ass vault extension module (the hardest part)
    * All build testing can be done locally by navigating to src and running ```Invoke-Build```
    * If using VSCode as your primary editor you can use tasks to perform various local actions
      * Examples:
        * ```Press Ctrl+P, then type 'task .'``` - Runs complete build (all tasks)
        * ```Press Ctrl+P, then type 'task Test'``` - Invokes all Pester Unit Tests
        * ```Press Ctrl+P, then type 'task Analyze'``` - Invokes Script Analyzer checks
        * ```Press Ctrl+P, then type 'task DevCC'``` - Generates generate xml file to graphically display code coverage in VSCode using [Coverage Gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters)

## Notes

The structure and layout of a SecretManagement Vault extension module differs quite a bit from a standard PowerShell module:

```powershell
./TestVault
./TestVault/TestVault.psd1
./TestVault/TestStoreImplementation.dll
./TestVault/TestVault.Extension
./TestVault/TestVault.Extension/TestVault.Extension.psd1
./TestVault/TestVault.Extension/TestVault.Extension.psm1
```

Because of the nested nature of the vault extension, and how user facing functions are surfaced up, Catesta does not support automated help generation via platyPS for Vault extension projects.

## Additional Reading

* [PowerShell SecretManagement module GitHub](https://github.com/PowerShell/SecretManagement)
* [SecretManagement Module Preview Design Changes](https://devblogs.microsoft.com/powershell/secretmanagement-module-preview-design-changes/)
* [Secrets Management Module Vault Extensions](https://devblogs.microsoft.com/powershell/secrets-management-module-vault-extensions/)
* [https://devblogs.microsoft.com/powershell/secretmanagement-preview-3/](https://devblogs.microsoft.com/powershell/secretmanagement-preview-3/)

## Vault Extension Examples

* [Azure Vault](https://github.com/PowerShell/SecretManagement/blob/master/ExtensionModules/AKVaultScript/AKVaultScript.Extension/AKVaultScript.Extension.psm1)
* [SecretManagement.LastPass](https://github.com/TylerLeonhardt/SecretManagement.LastPass)
* [SecretManagement.KeePass](https://github.com/JustinGrote/SecretManagement.KeePass)
* [KeybaseSecretManagementExtension](https://github.com/tiksn/KeybaseSecretManagementExtension)
