# Catesta - AWS CodeBuild Integration

## Synopsis

Scaffolds a new PowerShell module project intended for CI/CD workflow using [AWS CodeBuild](https://aws.amazon.com/codebuild/).

## Getting Started

*Note: Before getting started you should have a basic idea of what you expect your module to support. If your module is cross-platform, or you want to test different versions of PowerShell you should run multiple build types.*

| Windows PowerShell  | Windows pwsh | Linux pwsh |
| ------------- | ------------- | ------------- |

1. You will [need an AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).
1. Create your project using Catesta

    ```powershell
    New-PowerShellProject -CICDChoice 'AWS' -DestinationPath c:\path\AWSProject
    ```

    1. The Plaster logo will be displayed and you will see your first prompt
    1. **Enter the name of the module:** *Name of your module*
    1. **Enter a description for the module:** *Description of what your module does*
    1. **Enter the version number of the module (0.0.1)**: *Starting version #*
    1. **Enter your full name**: *Module author name*
    1. **Where will this project be hosted?** This selection influences which *CloudFormation file* is generated. Select based on where you intend to store your code, GitHub or AWS CodeCommit.
       * *NOTE: If you choose GitHub you will need to first associate your AWS account with your GitHub account (if you have never done so). See the NOTES section of this doc for details.*
    1. **Would you like to generate a Changelog file?**
    1. **Select a License for your module. (Help deciding: [https://choosealicense.com/](https://choosealicense.com/))**
    1. **Would you like to generate a Code of Conduct file?**
    1. **Would you like to generate a Contributing guidelines file?**
    1. **Would you like to specify a coding style for the project? [S] Stroustrup  [O] OTBS  [A] Allman  [N] None  [?] Help (default is "S"):** *The preferred coding style for the project*
    1. **Would you like to use platyPS to generate help documentation files for your project?** *Creates Markdown & external help for your module*
    1. **Enter S3 bucket name to download needed PS modules from S3 location. Leave blank to DL modules from PSGallery.** Your CodeBuild instance will need various modules to successfully build your PowerShell module project. By default, it does not contain them. Leaving this blank will default to having the CodeBuild instance download and install the needed modules from the PSGallery during each build. You can improve build times and performance by instead loading the required modules into an S3 bucket. If you choose to do so, you can specify the S3 bucket here. Don't forget to give your CodeBuild project permission to that S3 bucket.
    1. **Select desired buildpsec file(s) options?** This is the most important selection and determines which buildspec files are generated for the CodeBuild. You need to consider what platforms you intend for your module to support. One, or all of these can be specified. The following scenarios are possible:

        | Buildspec | Environment | PowerShell |
        | ------------- | ------------- | ------------- |
        | buildspec_powershell_windows.yml  | WINDOWS_CONTAINER  | powershell  |
        | buildspec_pwsh_windows.yml  | WINDOWS_CONTAINER  | pwsh (1) |
        | buildspec_pwsh_linux.yml  | LINUX_CONTAINER  | pwsh  |

        * (1)PowerShell 6.2.3 will be downloaded, installed, and all build tasks will run under the context of pwsh*
1. Create your CodeBuild project in your AWS account. You can do this manually, or use the generated CloudFormation template (recommended).
    * **GitHub**
      * The generated CFN template will guide you through the process. You will need a SEPERATE CodeBuild for each build type. So, if you wanted to build against all three platforms, you would deploy the template three times, specifying the desired buildspec for each stack deployment.
      * The following shows the GitHub CFN example: ![PowerShell CodeBuild CFN Example](../media/AWS/PowerShell_CodeBuild_CFN_Example.PNG "PowerShell CodeBuild CFN Example")
      * The GitHub process is not currently configured to generate artifacts. You are welcome to make adjustments to include them.
      * *Don't forget to copy your badge URL to display on your project*
    * **CodeCommit**
      * The CodeCommit does include artifacts. Use the **S3BucketsForPowerShellDevelopment.yml** to quickly create the S3 bucket stack needed to store them.
      * The generated CFN template will guide you through the process. This CFN is different than the GitHub one in that you only need to deploy it once. This CFN will be dynamically altered based on your buildspec choice specified during the plaster process. If you choose all three, the CFN will deploy all required resources to support all three build types.
1. Write a kick-ass module (the hardest part)
    * All build testing can be done locally by navigating to src and running ```Invoke-Build```
1. Upload to your desired repository which now has a triggered/monitored build action.
1. Evaluate results of your build and display your AWS CodeBuild badge proudly!

![AWS CodeBuild project created by Catesta](../media/AWS/AWSCodeBuildProjects.PNG "AWS CodeBuild project created by Catesta")

## Notes

This template currently supports two repository sources that the user can specify when invoking the template:

* [GitHub](https://github.com/)
* [AWS CodeCommit](https://aws.amazon.com/codecommit/)

If you elect to host your code in GitHub you will need to manually associate your AWS account with your GitHub account. This is a one time manual action.

[Configure GitHub Authentication](https://docs.aws.amazon.com/codepipeline/latest/userguide/GitHub-authentication.html)

> For source code in a GitHub repository, the HTTPS clone URL to the repository that contains the source and the build spec. You must connect your AWS account to your GitHub account. Use the AWS CodeBuild console to start creating a build project. When you use the console to connect (or reconnect) with GitHub, on the GitHub Authorize application page, for Organization access, choose Request access next to each repository you want to allow AWS CodeBuild to have access to, and then choose Authorize application. (After you have connected to your GitHub account, you do not need to finish creating the build project. You can leave the AWS CodeBuild console.) To instruct AWS CodeBuild to use this connection, in the source object, set the auth object's type value to OAUTH.

You may wish to use different CodeBuild projects to monitor different branches of your repository. If you are using GitHub this can be done with a WebhookFilter:

[AWS CodeBuild Project WebhookFilter](https://docs.amazonaws.cn/en_us/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-webhookfilter.html)

## Diagrams

![PowerShell CodeBuild GitHub Diagram](../media/AWS/AWSCodeBuildGitHub.png "PowerShell CodeBuild GitHub Diagram")

![PowerShell CodeBuild CodeCommit Diagram](../media/AWS/AWSCodeBuildCodeCommit.png "PowerShell CodeBuild CodeCommit Diagram")

## Example Projects

A few PowerShell module projects you can reference that are using AWS CodeBuild:

* [PoshGram](https://github.com/techthoughts2/PoshGram)
* [Diag-V](https://github.com/techthoughts2/Diag-V)
* [FastPing](https://github.com/austoonz/FastPing)