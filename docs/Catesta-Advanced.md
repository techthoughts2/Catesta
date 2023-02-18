# Catesta - Advanced

-------------------

*Consider exploring the [Catesta Basics](Catesta-Basics.md) page first to gain a comprehensive understanding of the tool and its features before proceeding to the advanced page. This page is designed for users with prior experience with Catesta who are interested in exploring its advanced capabilities.*

-------------------

## Creating Your Project Using Parameters Table

Catesta provides an advanced way of scaffolding your project by allowing you to pass in a hashtable of parameters instead of using the interactive prompts. This is a more efficient and customizable way of scaffolding your project.

However, it's important to be aware that some decisions made early on can influence subsequent choices in the process, due to the dynamic nature of Catesta's Plaster templates.

To avoid passing in unsupported choices, it's crucial to review the relevant manifest schema applicable to your project type before crafting the ModuleParameters table. The schema documents can be found at:

- [Catesta-ModuleSchema](Catesta-ModuleSchema.md)
- [Catesta-VaultSchema](Catesta-VaultSchema.md)

Failing to correctly craft the ModuleParameters table can result in passing in choices that are not supported. To avoid this, make sure to read the manifest schema carefully.

If any decision choice is not provided, Plaster will still prompt you for a decision.

### Module Examples

-------------------

Scaffolds a basic PowerShell module project with no additional extras.
You just get a basic PowerShell module construct.

```powershell
$moduleParameters = @{
    ModuleName  = 'ModuleName'
    Description = 'My awesome module is awesome'
    Version     = '0.0.1'
    FN          = 'user full name'
    CICD        = 'NONE'
    RepoType    = 'NONE'
    CodingStyle = 'Stroustrup'
    Help        = 'Yes'
    Pester      = '5'
    NoLogo      = $true
}
New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
```

-------------------

Scaffolds a PowerShell module project for integration with GitHub Actions with the project code stored in GitHub.
A full set of GitHub project supporting files is provided.

```powershell
$moduleParameters = @{
    ModuleName     = 'ModuleName'
    Description    = 'My awesome module is awesome'
    Version        = '0.0.1'
    FN             = 'user full name'
    CICD           = 'GITHUB'
    GitHubAOptions = 'windows', 'pwshcore', 'linux', 'macos'
    RepoType       = 'GITHUB'
    License        = 'MIT'
    Changelog      = 'CHANGELOG'
    COC            = 'CONDUCT'
    Contribute     = 'CONTRIBUTING'
    Security       = 'SECURITY'
    CodingStyle    = 'Stroustrup'
    Help           = 'Yes'
    Pester         = '5'
    S3Bucket       = 'PSGallery'
    NoLogo         = $true
}
New-ModuleProject -ModuleParameters $moduleParameters -DestinationPath $outPutPath
```

-------------------

See [New-ModuleProject](New-ModuleProject.md) for additional examples.

### Vault Examples

-------------------

Scaffolds a basic PowerShell SecretManagement vault project with no additional extras.
You just get a basic PowerShell SecretManagement vault construct.

```powershell
$vaultParameters = @{
    ModuleName       = 'SecretManagement.VaultName'
    Description      = 'My awesome vault is awesome'
    Version          = '0.0.1'
    FN               = 'user full name'
    CICD             = 'NONE'
    RepoType         = 'NONE'
    CodingStyle      = 'Stroustrup'
    Pester           = '5'
    NoLogo           = $true
}
New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
```

-------------------

Scaffolds a PowerShell SecretManagement vault project for integration with GitHub Actions with the project code stored in GitHub.
A full set of GitHub project supporting files is provided.

```powershell
$vaultParameters = @{
    ModuleName       = 'SecretManagement.VaultName'
    Description      = 'My awesome vault is awesome'
    Version          = '0.0.1'
    FN               = 'user full name'
    CICD             = 'GITHUB'
    GitHubAOptions   = 'windows', 'pwshcore', 'linux', 'macos'
    RepoType         = 'GITHUB'
    License          = 'MIT'
    Changelog        = 'CHANGELOG'
    COC              = 'CONDUCT'
    Contribute       = 'CONTRIBUTING'
    Security         = 'SECURITY'
    CodingStyle      = 'Stroustrup'
    Pester           = '5'
    S3Bucket         = 'PSGallery'
    NoLogo           = $true
}
New-VaultProject -VaultParameters $vaultParameters -DestinationPath $outPutPath
```

-------------------

See [New-VaultProject](New-VaultProject.md) for additional examples.

## Transplanting an Existing Module

If you already have a functioning PowerShell module, you may still want to consider using Catesta. With its community-driven best practices in module layout, you can bring your module in line with the latest and greatest standards. Additionally, Catesta can provide you with robust CI/CD capabilities, easily integrating this functionality into your project. If you're already using a CI/CD solution, you can even use Catesta to switch to a different CI/CD option.

To transplant an existing PowerShell module into Catesta, follow these steps:

1. Use Catesta to scaffold a new PowerShell module with the same name as your existing module, making sure to match the case.
1. Move your private functions to `src/{ModuleName}/Private`
1. Move your public functions to `src/{ModuleName}/Public`
1. If you have any script or global level variables, move them to `src/Imports.ps1`
1. Move any unit tests for your private functions to `src/Tests/Unit/Private`
   a. *Note: all tests are expected to end in `.Tests.ps1`*
1. Move any unit tests for your public functions to `src/Tests/Unit/Public`
1. Move any integration/infrastructure tests to `src/Tests/Integration`
1. Update the new module's `.psd1` file to match the details of your old `.psd1` file.
   a. Pay special attention to ensure the GUID matches!

Execute and address any build errors. (See [Catesta-Basics](Catesta-Basics.md) for details.)

It's common to encounter a few build errors when transplanting an existing PowerShell module to Catesta scaffolding, especially if the module wasn't originally built with the latest community and build best practices in mind. But, don't worry! This is actually a great opportunity to improve the quality of your module! By working through and resolving any initial build errors, you'll end up with a well-structured, maintainable, and reliable community module.

## Customizing the Build File

The [InvokeBuild](https://github.com/nightroman/Invoke-Build) build file, located at `src/{ModuleName}.build.ps1`, is a component of your Catesta scaffolded module that may require some customization to meet the specific needs of your module. Specifically, the `Analyze`, `AnalyzeTests`, and `Build` tasks in the build file are the tasks most likely to require customization.

Regarding `Analyze` and `AnalyzeTests`, [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) will analyze your code for common violations. In some cases, you may wish to suppress some of the findings. To globally suppress a [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) rule (for both tasks), you can add the rule name to the `ExcludeRules = @()` array in the `src/[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)Settings.psd1` file. If you only want to suppress a rule for either the `Analyze` or `AnalyzeTests` task, you can add the rule name to the respective `ExcludeRule = @()` array in the build file.

The `Build` task is the main task that builds and prepares your module for publication. If your module requires additional files, assets, or artifacts, you will likely need to add steps to the `Build` task to include them in the build process. For instance, you could add additional `Copy-Item` steps to copy an additional file or directory during the build process.
