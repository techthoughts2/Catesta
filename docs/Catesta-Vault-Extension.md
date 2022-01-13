# Catesta - Vault Extension Module

## Synopsis

Scaffolds a [PowerShell SecretManagement vault module project](https://github.com/PowerShell/SecretManagement) for use with desired CICD platform for easy cross platform PowerShell development.

## Getting Started

*Note: Before getting started you should have a basic idea of what you expect your module to support. If your module is cross-platform, or you want to test different versions of PowerShell you should run multiple build types.*

| Windows PowerShell  | Windows pwsh | Linux pwsh |
| ------------- | ------------- | ------------- |

*Note 2: Consult the CI/CD specific documentation on the main README for details on specific CI/CD workflows. This example will cover a basic Vault Extension module project creation.*

1. Create your vault extension project using Catesta

* *NOTE: As a community best practice SecretManagement projects have SecretManagement.VaultName added to a project name. Catesta will automatically accomplish this for you. Just select a name for your vault project and let Catesta do the rest*

    ```powershell
    New-VaultProject -CICDChoice 'ModuleOnly' -DestinationPath c:\path\ModuleOnly
    ```

    1. The Plaster logo will be displayed and you will see your first prompt
    2. **Enter the name of the module:** *Name of your module*
    3. **Enter a description for the module:** *Description of what your module does*
    4. **Enter the version number of the module (0.0.1)**: *Starting version #*
    5. **Enter your full name**: *Module author name*
    6. **Would you like to generate a Changelog file?**
    7. **Would you like to generate helpful repository files?** *GitHub issue/pullrequest/feature files*
    8. **Select a License for your module. (Help deciding: [https://choosealicense.com/](https://choosealicense.com/))**
    9. **Would you like to generate a Code of Conduct file?**
    10. **Would you like to generate a Contributing guidelines file?**
    11. **Would you like to specify a coding style for the project? [S] Stroustrup  [O] OTBS  [A] Allman  [N] None  [?] Help (default is "S"):** *The preferred coding style for the project*
2. Write a kick-ass vault extension module (the hardest part)
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
./SecretManagement.TestVault
./SecretManagement.TestVault/SecretManagement.TestVault.psd1
./SecretManagement.TestVault/SecretManagement.TestVault.psm1
./SecretManagement.TestVault/TestStoreImplementation.dll
./SecretManagement.TestVault/SecretManagement.TestVault.Extension
./SecretManagement.TestVault/SecretManagement.TestVault.Extension/SecretManagement.TestVault.Extension.psd1
./SecretManagement.TestVault/SecretManagement.TestVault.Extension/SecretManagement.TestVault.Extension.psm1
```

*NOTE: Because of the nested nature of the vault extension, and how user facing functions are surfaced up, Catesta does not support automated help generation via platyPS for Vault extension projects.*

## PowerShell SecretManagement Diagram

![PowerShell SecretManagement Diagram](../media/powershell_secretmanagement_diagram.png)

## Additional Reading

* [Announcing SecretManagement 1.1 GA](https://devblogs.microsoft.com/powershell/announcing-secretmanagement-1-1-ga/)
* [SecretManagement and SecretStore are Generally Available](https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/)
* [SecretManagement Module v1.1.0 preview update](https://devblogs.microsoft.com/powershell/secretmanagement-module-v1-1-0-preview-update/)
* [PowerShell SecretManagement Module Design](https://github.com/PowerShell/SecretManagement/blob/main/Docs/DesignDoc.md)
* [PowerShell Secrets Management – Part 1: Introduction](https://www.powershell.co.at/powershell-secrets-management-part-1-introduction/)
* [PowerShell Secrets Management – Part 2: Installation and first steps](https://www.powershell.co.at/powershell-secrets-management-part-2-installation-and-first-steps/)
* [SecretManagement and SecretStore Release Candidate 2](https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-release-candidate-2/)
  * [SecretManagement Module Preview Design Changes](https://devblogs.microsoft.com/powershell/secretmanagement-module-preview-design-changes/)
  * [SecretManagement and SecretStore Updates](https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-updates-2/)
* [Secrets Management Module Vault Extensions](https://devblogs.microsoft.com/powershell/secrets-management-module-vault-extensions/)

## SecretManagement and SecretStore Repos

* [SecretManagement](https://github.com/PowerShell/SecretManagement)
* [SecretStore](https://github.com/PowerShell/SecretStore)
* [Azure Vault](https://github.com/PowerShell/SecretManagement/blob/main/ExtensionModules/AKVaultScript/AKVaultScript.Extension/AKVaultScript.Extension.psm1)

## Vault Extension Examples

* [SecretManagement.1Password](https://github.com/cdhunt/SecretManagement.1Password)
* [SecretManagement.BitWarden](https://github.com/Gaspack/SecretManagement.BitWarden)
* [SecretManagement.Chromium](https://github.com/JustinGrote/SecretManagement.Chromium)
* [SecretManagement.CyberArk](https://github.com/aaearon/SecretManagement.CyberArk)
* [SecretManagement.Hashicorp.Vault.KV](https://github.com/joshcorr/SecretManagement.Hashicorp.Vault.KV)
* [SecretManagement.KeePass](https://github.com/JustinGrote/SecretManagement.KeePass)
* [KeybaseSecretManagementExtension](https://github.com/tiksn/KeybaseSecretManagementExtension)
* [SecretManagement.KeyChain](https://github.com/SteveL-MSFT/SecretManagement.KeyChain)
* [SecretManagement.LastPass](https://github.com/TylerLeonhardt/SecretManagement.LastPass)
