# Catesta - Azure Pipelines Integration

## Synopsis

Scaffolds a new PowerShell module project intended for CI/CD workflow using [Azure Pipelines](https://azure.microsoft.com/services/devops/).

## Getting Started

*Note: Before getting started you should have a basic idea of what you expect your module to support. If your module is cross-platform, or you want to test different versions of PowerShell you should run multiple build types.*

| Windows PowerShell  | Windows pwsh | Linux | MacOS |
| ------------- | ------------- | ------------- | ------------- |

1. You will [need an Azure DevOps Organization](https://azure.microsoft.com/services/devops/).
1. Create a new Project:
    * ![Azure DevOps Organization New Project](../media/Azure/azure_devops_org_new_project.PNG "Azure DevOps Organization New Project")
1. Create a new pipeline and choose where your code will come from:
    * ![Azure DevOps New Pipeline](../media/Azure/azure_devops_new_pipeline.PNG "Azure DevOps New Pipeline")
    * Authenticate to your repository source as needed
1. Create your project using Catesta

    ```powershell
    New-PowerShellProject -CICDChoice 'Azure' -DestinationPath c:\path\AzurePipeline
    ```

    1. The Plaster logo will be displayed and you will see your first prompt
    1. **Enter the name of the module:** *Name of your module*
    1. **Enter a description for the module:** *Description of what your module does*
    1. **Enter the version number of the module (0.0.1)**: *Starting version #*
    1. **Enter your full name**: *Module author name*
    1. **Would you like to generate a Changelog file?**
    1. **Select a License for your module. (Help deciding: [https://choosealicense.com/](https://choosealicense.com/))**
    1. **Would you like to generate a Code of Conduct file?**
    1. **Would you like to generate a Contributing guidelines file?**
    1. **Would you like to specify a coding style for the project? [S] Stroustrup  [O] OTBS  [A] Allman  [N] None  [?] Help (default is "S"):** *The preferred coding style for the project*
    1. **Would you like to use platyPS to generate help documentation files for your project?** *Creates Markdown & external help for your module*
    1. **Select desired pipeline job configurations. (If your module is cross-platform you should select multiple)**
        * [W] Windows - PowerShell
        * [C] Core (Windows)- pwsh
        * [L] Linux
        * [M] MacOS
1. Write a kick-ass module (the hardest part)
    * All build testing can be done locally by navigating to src and running ```Invoke-Build```
    * If using VSCode as your primary editor you can use tasks to perform various local actions
      * Examples:
        * ```Press Ctrl+P, then type 'task .'``` - Runs complete build (all tasks)
        * ```Press Ctrl+P, then type 'task Test'``` - Invokes all Pester Unit Tests
        * ```Press Ctrl+P, then type 'task Analyze'``` - Invokes Script Analyzer checks
        * ```Press Ctrl+P, then type 'task DevCC'``` - Generates generate xml file to graphically display code coverage in VSCode using [Coverage Gutters](https://marketplace.visualstudio.com/items?itemName=ryanluker.vscode-coverage-gutters)
1. *The comment based help in your functions will be used to generate/update markdown docs for your module in the docs folder.*
1. Upload to your desired repository which now has a triggered/monitored build action.
1. Evaluate results of your build and display your Azure Pipelines badge proudly!

![Azure Pipelines project created by Catesta](../media/Azure/azure_pipelines_project.PNG "Azure Pipelines project created by Catesta")

## Notes

Additional Reading:

* [YAML schema reference](https://docs.microsoft.com/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema)
* [Use a Microsoft-hosted agent](https://docs.microsoft.com/azure/devops/pipelines/agents/hosted?view=azure-devops#use-a-microsoft-hosted-agent)
* [Predefined variables](https://docs.microsoft.com/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml)

## Diagrams

TBD

## Example Projects

TBD