# Catesta - The Basics

## Getting Started with Catesta

To use Catesta, you first need to install it from the PowerShell Gallery using the following command:

```powershell
Install-Module -Name Catesta -Repository PSGallery -Scope CurrentUser
```

Once you have installed Catesta, you can start using it to create your project. You can choose to create either a PowerShell module project or a SecretManagement vault extension project.

### Scaffolding a PowerShell Module Project

To create a PowerShell module project, use the following command:

```powershell
New-ModuleProject -DestinationPath $outPutPath
```

### Scaffolding a SecretManagement Vault Extension Project

To create a SecretManagement vault extension project, use the following command:

```powershell
New-VaultProject -DestinationPath $outPutPath
```

### Choices

* The Plaster logo may be displayed and you will see your first prompt
* **Enter the name of the module:** *Name of your module*
* **Enter a description for the module:** *Description of what your module does*
* **Enter the version number of the module (0.0.1)**: *Starting version #*
* **Enter your full name**: *Module author name*
* **Will you use classes in your module?**
    * [N] No
    * [Y] Yes
* **Which CICD tool will you use to build and deploy your project?**: *Choose CI/CD tool for automated project build and deployment.*
    * [M] Module Only
    * [G] GitHub Actions
    * [C] AWS CodeBuild
    * [S] GitHub Actions on AWS CodeBuild
    * [P] Appveyor
    * [L] GitLab CI/CD
    * [B] BitBucket Pipelines
    * [A] Azure Pipelines
* **Select desired job configurations. (If your module is cross-platform you should select multiple)**
    * [W] Windows - PowerShell
    * [C] Core (Windows)- pwsh
    * [L] Linux
    * [M] MacOS
* **Which service will host this projects code repository?**: Choosing code repository hosting platform for your project.
* **Select a License for your module. (Help deciding: [https://choosealicense.com/](https://choosealicense.com/))**
* **Would you like to generate a Changelog file?**
* **Would you like to generate a Code of Conduct file?**
* **Would you like to generate a Contributing guidelines file?**
* **Would you like to generate a Security policy file?**
* **Would you like to specify a coding style for the project?**: *The preferred coding style for the project*
    * [S] Stroustrup
    * [O] OTBS
    * [A] Allman
    * [N] None
* **Would you like to use platyPS to generate help documentation files for your project?** *Creates Markdown & external help for your module*
* **Which version of Pester would you like to use?**: *Pester 4 or Pester 5*

#### Understanding CI/CD Tool Selection

When you run the `New-ModuleProject` \ `New-VaultProject` command, Catesta will prompt you with the question "*Which CICD tool will you use to build and deploy your project?*". This question is asking which Continuous Integration and Continuous Deployment (CI/CD) integration you would like to use to automate the building and deploying of your project.

The options listed in the prompt represent the different CI/CD tools that Catesta supports, including:

```powershell
[M] Module Only
[G] GitHub Actions
[C] AWS CodeBuild
[S] GitHub Actions on AWS CodeBuild
[P] Appveyor
[L] GitLab CI/CD
[B] BitBucket Pipelines
[A] Azure Pipelines
```

*NOTE: Selecting **Module Only** generates a module that is not integrated with CI/CD. This option is suitable if you want to quickly create a project and plan to only conduct local development, build, and testing.*

The default option is "G" for GitHub Actions, but you can choose the option that best fits your needs and setup.

It's important to note that the choice you make here will impact the setup and configuration of your project. Catesta will generate the necessary files and integrations for the selected CI/CD tool, so it's important to choose wisely.

If you need help with the options or are unsure which to choose, you can review additional Catesta documentation that covers the process of each CI/CD integration in depth:

* [Catesta - GitHub Actions Doc](catesta_cicd/Catesta-GHActions.md)
* [Catesta - AWS CodeBuild Doc](catesta_cicd/Catesta-AWS.md)
* [Catesta - GitHub Actions on AWS CodeBuild Doc](catesta_cicd/Catesta-GHActionsAWSCodeBuild.md)
* [Catesta - AppVeyor Doc](catesta_cicd/Catesta-AppVeyor.md)
* [Catesta - GitLab Doc](catesta_cicd/Catesta-GitLab.md)
* [Catesta - Bitbucket Doc](catesta_cicd/Catesta-Bitbucket.md)
* [Catesta - Azure Pipelines Doc](catesta_cicd/Catesta-Azure.md)

#### Understanding Build Configuration Selection

When you run the `New-ModuleProject` \ `New-VaultProject` command in Catesta, you'll be prompted with the question "*Select desired workflow action options?*" This question asks which operating systems you would like your project to be tested and built on.

The options listed in the prompt represent the different operating systems that Catesta supports:

```powershell
[W] Windows - PowerShell
[C] Core (Windows) - pwsh
[L] Linux
[M] MacOS
```

*NOTE: Not all CI/CD platforms support building on every operating system.*

If your project is cross-platform and needs to run on multiple operating systems, you can select multiple options. However, if your project is only meant to run on one operating system, then you can select the appropriate option.

The choice you make here will impact the setup and configuration of your project, as Catesta will generate the necessary files and integrations for the selected operating systems.

It's important to consider the target environment for your project and select the appropriate operating systems to ensure proper testing and deployment.

#### Understanding Code Repository Selection

When you run the `New-ModuleProject` \ `New-VaultProject` command in Catesta, you will be asked "*Which service will host this project's code repository?*". This question is asking where you want to store the source code of your project.

The options listed in the prompt represent the different code repository hosting platforms that Catesta supports, including:

```powershell
[N] None
[G] GitHub
[C] AWS CodeCommit
[L] GitLab
[B] BitBucket
[A] Azure Repos
```

You have the option to choose from a variety of code repository hosting platforms, or to choose "None" if you have a different hosting solution in mind.

The choice you make here will impact the subsequent questions in the setup process, particularly related to helpful repository files like issue templates and community files. Some of the hosting solutions offer advanced features that Catesta can assist you in setting up, while others are basic and therefore Catesta may not prompt you for additional questions.

#### Understanding Repository File Selections

Dependent upon previous selections you may be presented with a series of questions related to the generation of repository files for your project.

Community files, such as licenses, changelogs, code of conduct, contributing guidelines, and security policies, can greatly enhance the maturity and professionalism of a project. These files provide important information about how the project can be used, who is responsible for its development and maintenance, and what kind of contributions are welcome. Having these files in place can also help attract and retain contributors, and demonstrate a commitment to quality and security.

#### Understanding Read the Docs Selections

If you chose to host your project on a repository, Catesta will prompt you to decide if you'd like to integrate your project with Read the Docs. If you're not familiar with Read the Docs, it's a widely used documentation hosting platform that allows you to create and host documentation for your projects.

When you choose to integrate your project with Read the Docs using Catesta, it will automatically generate all the necessary components, such as a configuration file (mkdocs.yml) and basic documentation setup, to help you quickly get started. You'll also have the option to choose between two different themes: the default theme, called "readthedocs," or the material theme, which provides a modern, responsive design that's popular among Read the Docs users.

Integrating your project with Read the Docs can be a great way to create professional-looking documentation that's easily accessible to your users. It's a powerful tool that can help you streamline your documentation process and make your project more user-friendly.

#### Understanding Project Coding Style Selection

The purpose of specifying a coding style in Catesta is to ensure consistency and standardization throughout the project. By choosing one of the options (Stroustrup, OTBS, Allman, or None), Catesta will scaffold InvokeBuild tasks that validate and enforce the selected coding style, keeping the project's code neat and well-organized. Having a clear and consistent coding style can make the project easier to read, understand, and maintain, leading to a more mature and professional codebase.

#### Understanding platyPS Selection

When you choose `Y` for the question on whether to use platyPS in your project, Catesta will automatically integrate it into the build task phase. platyPS will take the inline help documentation of your public module functions and convert it into Markdown for easy publication and reference. Additionally, it will generate an external xml-based help file, which is a commonly used format in PowerShell.

*Why Use platyPS?*

Using platyPS simplifies the process of creating clear and effective inline help documentation for your module functions. All of your help documentation will be based on the comment-based help in your public functions, located in the public folder. During the build process, the inline help will be stripped out and replaced with references to the generated external help file. The comment-based help will still remain in your public functions folder and act as the source of truth for your help documentation. If you ever need to update or change your help documentation, simply run the next build and it will be automatically updated. This is a much more efficient solution than trying to manually manage and update help documentation on your own.

#### Understanding Pester Selection

Catesta offers the option to select between version 4 and 5 of Pester, the leading testing framework for PowerShell.

By selecting either 4 or 5, you determine which version of Pester will be included in your project. Both versions have their own set of features and capabilities, so it is important to consider your project's specific needs when making a choice.

Choosing version 4 will include Pester version 4 in your project, allowing you to write and run tests for your PowerShell code. This version has been widely adopted and tested, and offers a solid foundation for your testing needs.

Choosing version 5, on the other hand, will include Pester version 5 in your project. This version offers several new features and improvements over version 4, including improved support for parallel testing, a simplified syntax for writing tests, and better performance.

By selecting the appropriate version of Pester for your project, you can ensure that you have the tools you need to thoroughly test your code and make sure that it is working as expected.

### Next Steps

1. Use Catesta to scaffold your Module/Vault project with your desired CI/CD platform and builds.
1. Write your module (the hardest part)
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
1. Add any module dependencies to your CI/CD bootstrap file:
    * AWS: `install_modules.ps1`
    * GitHub Actions: `actions_bootstrap.ps1`
    * Azure: `actions_bootstrap.ps1`
    * AppVeyor: `actions_bootstrap.ps1`
1. Commit your project to desired repository that is integrated with your CI/CD platform. This will trigger the build actions.
1. Evaluate results of your builds and [display your README badges](Catesta-FAQ.md#how-do-i-display-the-badges-for-my-project) proudly!
1. If your builds pass and you are ready to Publish your module:
     * In your development environment InvokeBuild either the `.`, or `BuildNoIntegration` tasks.
         * This will run all local analysis, unit tests, and prepare your module for merge and publication
         * *If you selected platyPS to generate help documentation during the build process the comment based help in your functions will be used to generate/update markdown docs for your module in the docs folder.*
     * Once the build is complete your *ready to publish* project can be found in `src/Archive`
     * Move your module files into a location that can be sourced by `$env:PSModulePath` and then run [Publish-Module](https://learn.microsoft.com/powershell/module/powershellget/publish-module)
