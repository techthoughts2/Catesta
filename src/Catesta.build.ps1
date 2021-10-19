<#
.SYNOPSIS
    An Invoke-Build Build file.
.DESCRIPTION
    Build steps can include:
        - ValidateRequirements
        - ImportModuleManifest
        - Clean
        - Analyze
        - FormattingCheck
        - Test
        - DevCC
        - CreateHelpStart
        - Build
        - InfraTest
        - Archive
.EXAMPLE
    Invoke-Build

    This will perform the default build Add-BuildTasks: see below for the default Add-BuildTask execution
.EXAMPLE
    Invoke-Build -Add-BuildTask Analyze,Test

    This will perform only the Analyze and Test Add-BuildTasks.
.NOTES
    This build will pull in configurations from the "<module>.Settings.ps1" file as well, where users can more easily customize the build process if required.
    https://github.com/nightroman/Invoke-Build
    https://github.com/nightroman/Invoke-Build/wiki/Build-Scripts-Guidelines
    If using VSCode you can use the generated tasks.json to execute the various tasks in this build file.
        Ctrl + P | then type task (add space) - you will then be presented with a list of available tasks to run
    The 'InstallDependencies' Add-BuildTask isn't present here.
        Module dependencies are installed at a previous step in the pipeline.
        If your manifest has module dependencies include all required modules in your CI/CD bootstrap file:
            AWS - install_modules.ps1
            Azure - actions_bootstrap.ps1
            GitHub Actions - actions_bootstrap.ps1
            AppVeyor  - actions_bootstrap.ps1
#>

#Include: Settings
$ModuleName = (Split-Path -Path $BuildFile -Leaf).Split('.')[0]
. "./$ModuleName.Settings.ps1"

function Test-ManifestBool ($Path) {
    Get-ChildItem $Path | Test-ModuleManifest -ErrorAction SilentlyContinue | Out-Null; $?
}

#Default Build
$str = @()
$str = 'Clean', 'ValidateRequirements', 'ImportModuleManifest'
$str += 'FormattingCheck'
$str += 'Analyze', 'Test'
$str += 'CreateHelpStart'
$str += 'Build', 'InfraTest', 'Archive'
Add-BuildTask -Name . -Jobs $str

#Local testing build process
Add-BuildTask TestLocal Clean, ImportModuleManifest, Analyze, Test

#Local help file creation process
Add-BuildTask HelpLocal Clean, ImportModuleManifest, CreateHelpStart

# Pre-build variables to be used by other portions of the script
Enter-Build {
    $script:ModuleName = (Split-Path -Path $BuildFile -Leaf).Split('.')[0]

    # Identify other required paths
    $script:ModuleSourcePath = Join-Path -Path $BuildRoot -ChildPath $script:ModuleName
    $script:ModuleFiles = Join-Path -Path $script:ModuleSourcePath -ChildPath '*'

    $script:ModuleManifestFile = Join-Path -Path $script:ModuleSourcePath -ChildPath "$($script:ModuleName).psd1"

    $manifestInfo = Import-PowerShellDataFile -Path $script:ModuleManifestFile
    $script:ModuleVersion = $manifestInfo.ModuleVersion
    $script:ModuleDescription = $manifestInfo.Description
    $script:FunctionsToExport = $manifestInfo.FunctionsToExport

    $script:TestsPath = Join-Path -Path $BuildRoot -ChildPath 'Tests'
    $script:UnitTestsPath = Join-Path -Path $script:TestsPath -ChildPath 'Unit'
    $script:InfraTestsPath = Join-Path -Path $script:TestsPath -ChildPath 'Infrastructure'

    # $script:ArtifactsPath = Join-Path -Path $BuildRoot -ChildPath "$script:ModuleName\Artifacts"
    # $script:ArchivePath = Join-Path -Path $BuildRoot -ChildPath "$script:ModuleName\Archive"

    $script:ArtifactsPath = Join-Path -Path $BuildRoot -ChildPath 'Artifacts'
    $script:ArchivePath = Join-Path -Path $BuildRoot -ChildPath 'Archive'

    $script:BuildModuleRootFile = Join-Path -Path $script:ArtifactsPath -ChildPath "$($script:ModuleName).psm1"

    # Ensure our builds fail until if below a minimum defined code test coverage threshold
    $script:coverageThreshold = 95

    [version]$script:PesterVersion = '5.2.2'
} #Enter-Build

# Define headers as separator, task path, synopsis, and location, e.g. for Ctrl+Click in VSCode.
# Also change the default color to Green. If you need task start times, use `$Task.Started`.
Set-BuildHeader {
    param($Path)
    # separator line
    Write-Build DarkMagenta ('=' * 79)
    # default header + synopsis
    Write-Build DarkGray "Task $Path : $(Get-BuildSynopsis $Task)"
    # task location in a script
    Write-Build DarkGray "At $($Task.InvocationInfo.ScriptName):$($Task.InvocationInfo.ScriptLineNumber)"
    Write-Build Yellow "Manifest File: $script:ModuleManifestFile"
    Write-Build Yellow "Manifest Version: $($manifestInfo.ModuleVersion)"
} #Set-BuildHeader

# Define footers similar to default but change the color to DarkGray.
Set-BuildFooter {
    param($Path)
    Write-Build DarkGray "Done $Path, $($Task.Elapsed)"
    # # separator line
    # Write-Build Gray ('=' * 79)
} #Set-BuildFooter

#Synopsis: Validate system requirements are met
Add-BuildTask ValidateRequirements {
    # this setting comes from the *.Settings.ps1
    Write-Build White "      Verifying at least PowerShell $script:requiredPSVersion..."
    Assert-Build ($PSVersionTable.PSVersion.Major.ToString() -ge $script:requiredPSVersion) "At least Powershell $script:requiredPSVersion is required for this build to function properly"
    Write-Build Green '      ...Verification Complete!'
} #ValidateRequirements

# Synopsis: Import the current module manifest file for processing
Add-BuildTask TestModuleManifest -Before ImportModuleManifest {
    Write-Build White '      Running module manifest tests...'
    Assert-Build (Test-Path $script:ModuleManifestFile) 'Unable to locate the module manifest file.'
    Assert-Build (Test-ManifestBool -Path $script:ModuleManifestFile) 'Module Manifest test did not pass verification.'
    Write-Build Green '      ...Module Manifest Verification Complete!'
}

# Synopsis: Load the module project
Add-BuildTask ImportModuleManifest {
    Write-Build White '      Attempting to load the project module.'
    try {
        Import-Module $script:ModuleManifestFile -Force -PassThru -ErrorAction Stop
    }
    catch {
        throw 'Unable to load the project module'
    }
    Write-Build Green "      ...$script:ModuleName imported successfully"
}

#Synopsis: Clean and reset Artifacts/Archive Directory
Add-BuildTask Clean {
    Write-Build White '      Clean up our Artifacts/Archive directory...'

    $null = Remove-Item $script:ArtifactsPath -Force -Recurse -ErrorAction 0
    $null = New-Item $script:ArtifactsPath -ItemType:Directory
    $null = Remove-Item $script:ArchivePath -Force -Recurse -ErrorAction 0
    $null = New-Item $script:ArchivePath -ItemType:Directory

    Write-Build Green '      ...Clean Complete!'
} #Clean

#Synopsis: Invokes PSScriptAnalyzer against the Module source path
Add-BuildTask Analyze {

    $scriptAnalyzerParams = @{
        # Path    = $script:ModuleSourcePath
        Setting = 'PSScriptAnalyzerSettings.psd1'
        # Recurse = $true
        # Verbose = $false
    }

    $filesToAnalyze = Get-ChildItem -Path $script:ModuleSourcePath -Exclude "PSVault.Extension*" -Recurse

    Write-Build White '      Performing Module ScriptAnalyzer checks...'
    foreach ($file in $filesToAnalyze) {
        $scriptAnalyzerResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams -Path $file.FullName
    }
    # $scriptAnalyzerResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

    if ($scriptAnalyzerResults) {
        $scriptAnalyzerResults | Format-Table
        throw '      One or more PSScriptAnalyzer errors/warnings where found.'
    }
    else {
        Write-Build Green '      ...Module Analyze Complete!'
    }
} #Analyze

#Synopsis: Invokes Script Analyzer against the Tests path if it exists
Add-BuildTask AnalyzeTests -After Analyze {
    if (Test-Path -Path $script:TestsPath) {

        $scriptAnalyzerParams = @{
            Path        = $script:TestsPath
            Setting     = 'PSScriptAnalyzerSettings.psd1'
            ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
            Recurse     = $true
            Verbose     = $false
        }

        Write-Build White '      Performing Test ScriptAnalyzer checks...'
        $scriptAnalyzerResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

        if ($scriptAnalyzerResults) {
            $scriptAnalyzerResults | Format-Table
            throw '      One or more PSScriptAnalyzer errors/warnings where found.'
        }
        else {
            Write-Build Green '      ...Test Analyze Complete!'
        }
    }
} #AnalyzeTests

#Synopsis: Analyze scripts to verify if they adhere to desired coding format (Stroustrup / OTBS / Allman)
Add-BuildTask FormattingCheck {
    $scriptAnalyzerParams = @{
        Setting     = 'CodeFormattingStroustrup'
        ExcludeRule = @(
            'PSUseConsistentIndentation',
            'PSUseConsistentWhitespace',
            'PSUseCorrectCasing'
        )
        Recurse     = $true
        Verbose     = $false
    }

    Write-Build White '      Performing script formatting checks...'
    $scriptAnalyzerResults = Get-ChildItem -Path $script:ModuleSourcePath -Exclude "*.psd1" | Invoke-ScriptAnalyzer @scriptAnalyzerParams

    if ($scriptAnalyzerResults) {
        $scriptAnalyzerResults | Format-Table
        throw '      PSScriptAnalyzer code formatting check did not adhere to {0} standards' -f $scriptAnalyzerParams.Setting
    }
    else {
        Write-Build Green '      ...Formatting Analyze Complete!'
    }
} #FormattingCheck

#Synopsis: Invokes all Pester Unit Tests in the Tests\Unit folder (if it exists)
Add-BuildTask Test {

    Write-Build White "      Importing desired Pester version: $script:PesterVersion..."
    Remove-Module -Name Pester -Force -ErrorAction 'SilentlyContinue'# there are instances where some containers have Pester already in the session
    Import-Module -Name Pester -MinimumVersion $script:PesterVersion -ErrorAction 'Stop'

    $codeCovPath = "$script:ArtifactsPath\ccReport\"
    $testOutPutPath = "$script:ArtifactsPath\testOutput\"
    if (-not(Test-Path $codeCovPath)) {
        New-Item -Path $codeCovPath -ItemType Directory | Out-Null
    }
    if (-not(Test-Path $testOutPutPath)) {
        New-Item -Path $testOutPutPath -ItemType Directory | Out-Null
    }
    if (Test-Path -Path $script:UnitTestsPath) {
        $pesterConfiguration = [PesterConfiguration]::new()
        $pesterConfiguration.run.Path = $script:UnitTestsPath
        $pesterConfiguration.Run.PassThru = $true
        $pesterConfiguration.Run.Exit = $false
        $pesterConfiguration.CodeCoverage.Enabled = $true
        $pesterConfiguration.CodeCoverage.CoveragePercentTarget = $script:coverageThreshold
        $pesterConfiguration.CodeCoverage.OutputPath = "$codeCovPath\CodeCoverage.xml"
        $pesterConfiguration.CodeCoverage.OutputFormat = 'JaCoCo'
        if ($env:CI -and $IsMacOS) {
            # the MacOS github action does not properly detect the relative path.
            Write-Build White "           CI: $env:CI and MacOS action detected. Hard coding path."
            $pesterConfiguration.CodeCoverage.Path = "/Users/runner/work/Catesta/Catesta/src/Catesta/*/*.ps1"
        }
        else {
            $pesterConfiguration.CodeCoverage.Path = "..\..\..\$ModuleName\*\*.ps1"
        }
        $pesterConfiguration.TestResult.Enabled = $true
        $pesterConfiguration.TestResult.OutputPath = "$testOutPutPath\PesterTests.xml"
        $pesterConfiguration.TestResult.OutputFormat = 'NUnitXml'
        $pesterConfiguration.Output.Verbosity = 'Detailed'

        Write-Build White '      Performing Pester Unit Tests...'
        # Publish Test Results as NUnitXml
        $testResults = Invoke-Pester -Configuration $pesterConfiguration

        # This will output a nice json for each failed test (if running in CodeBuild)
        if ($env:CODEBUILD_BUILD_ARN) {
            $testResults.TestResult | ForEach-Object {
                if ($_.Result -ne 'Passed') {
                    ConvertTo-Json -InputObject $_ -Compress
                }
            }
        }

        $numberFails = $testResults.FailedCount
        Assert-Build($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)

        if ($testResults.CodeCoverage.CommandsExecutedCount -ne 0 -and $coverageThreshold -ne 0) {
            $coveragePercent = '{0:N2}' -f ($testResults.CodeCoverage.CommandsExecutedCount / $testResults.CodeCoverage.CommandsAnalyzedCount * 100)

            <#
            if ($testResults.CodeCoverage.NumberOfCommandsMissed -gt 0) {
                'Failed to analyze "{0}" commands' -f $testResults.CodeCoverage.NumberOfCommandsMissed
            }
            Write-Host "PowerShell Commands not tested:`n$(ConvertTo-Json -InputObject $testResults.CodeCoverage.MissedCommands)"
            #>
            if ([Int]$coveragePercent -lt $coverageThreshold) {
                throw ('Failed to meet code coverage threshold of {0}% with only {1}% coverage' -f $coverageThreshold, $coveragePercent)
            }
            else {
                Write-Build Cyan "      $('Covered {0}% of {1} analyzed commands in {2} files.' -f $coveragePercent,$testResults.CodeCoverage.CommandsAnalyzedCount,$testResults.CodeCoverage.FilesAnalyzedCount)"
                Write-Build Green '      ...Pester Unit Tests Complete!'

            }
        }
        else {
            # account for new module build condition
            Write-Build Yellow '      Code coverage check skipped. No commands to execute...'
        }

    }
} #Test

#Synopsis: Used primarily during active development to generate xml file to graphically display code coverage in VSCode using Coverage Gutters
Add-BuildTask DevCC {
    Write-Build White '      Generating code coverage report at root...'
    Remove-Module -Name Pester -Force -ErrorAction 'SilentlyContinue'# there are instances where some containers have Pester already in the session
    Import-Module -Name Pester -MinimumVersion $script:PesterVersion -ErrorAction 'Stop'

    $pesterConfiguration = [PesterConfiguration]::new()
    $pesterConfiguration.run.Path = $script:UnitTestsPath
    $pesterConfiguration.CodeCoverage.Enabled = $true
    $pesterConfiguration.CodeCoverage.Path = "$PSScriptRoot\$ModuleName\*\*.ps1"
    $pesterConfiguration.CodeCoverage.CoveragePercentTarget = $script:coverageThreshold
    $pesterConfiguration.CodeCoverage.OutputPath = '..\..\..\cov.xml'
    $pesterConfiguration.CodeCoverage.OutputFormat = 'CoverageGutters'

    Invoke-Pester -Configuration $pesterConfiguration
    Write-Build Green '      ...Code Coverage report generated!'
} #DevCC

# Synopsis: Build help for module
Add-BuildTask CreateHelpStart {
    Write-Build White '      Performing all help related actions.'

    Write-Build Gray '           Importing platyPS v0.12.0 ...'
    Import-Module platyPS -RequiredVersion 0.12.0 -ErrorAction Stop
    Write-Build Gray '           ...platyPS imported successfully.'
} #CreateHelpStart

# Synopsis: Build markdown help files for module and fail if help information is missing
Add-BuildTask CreateMarkdownHelp -After CreateHelpStart {
    $ModulePage = "$script:ArtifactsPath\docs\$($ModuleName).md"

    $markdownParams = @{
        Module         = $ModuleName
        OutputFolder   = "$script:ArtifactsPath\docs\"
        Force          = $true
        WithModulePage = $true
        Locale         = 'en-US'
        FwLink         = "NA"
        HelpVersion    = $script:ModuleVersion
    }

    Write-Build Gray '           Generating markdown files...'
    $null = New-MarkdownHelp @markdownParams
    Write-Build Gray '           ...Markdown generation completed.'

    Write-Build Gray '           Replacing markdown elements...'
    # Replace multi-line EXAMPLES
    $OutputDir = "$script:ArtifactsPath\docs\"
    $OutputDir | Get-ChildItem -File | ForEach-Object {
        # fix formatting in multiline examples
        $content = Get-Content $_.FullName -Raw
        $newContent = $content -replace '(## EXAMPLE [^`]+?```\r\n[^`\r\n]+?\r\n)(```\r\n\r\n)([^#]+?\r\n)(\r\n)([^#]+)(#)', '$1$3$2$4$5$6'
        if ($newContent -ne $content) {
            Set-Content -Path $_.FullName -Value $newContent -Force
        }
    }
    # Replace each missing element we need for a proper generic module page .md file
    $ModulePageFileContent = Get-Content -Raw $ModulePage
    $ModulePageFileContent = $ModulePageFileContent -replace '{{Manually Enter Description Here}}', $script:ModuleDescription
    $script:FunctionsToExport | ForEach-Object {
        Write-Build DarkGray "             Updating definition for the following function: $($_)"
        $TextToReplace = "{{Manually Enter $($_) Description Here}}"
        $ReplacementText = (Get-Help -Detailed $_).Synopsis
        $ModulePageFileContent = $ModulePageFileContent -replace $TextToReplace, $ReplacementText
    }

    $ModulePageFileContent | Out-File $ModulePage -Force -Encoding:utf8
    Write-Build Gray '           ...Markdown replacements complete.'

    Write-Build Gray '           Verifying GUID...'
    $MissingGUID = Select-String -Path "$script:ArtifactsPath\docs\*.md" -Pattern "(00000000-0000-0000-0000-000000000000)"
    if ($MissingGUID.Count -gt 0) {
        Write-Build Yellow '             The documentation that got generated resulted in a generic GUID. Check the GUID entry of your module manifest.'
        throw 'Missing GUID. Please review and rebuild.'
    }

    Write-Build Gray '           Checking for missing documentation in md files...'
    $MissingDocumentation = Select-String -Path "$script:ArtifactsPath\docs\*.md" -Pattern "({{.*}})"
    if ($MissingDocumentation.Count -gt 0) {
        Write-Build Yellow '             The documentation that got generated resulted in missing sections which should be filled out.'
        Write-Build Yellow '             Please review the following sections in your comment based help, fill out missing information and rerun this build:'
        Write-Build Yellow '             (Note: This can happen if the .EXTERNALHELP CBH is defined for a function before running this build.)'
        Write-Build Yellow "             Path of files with issues: $script:ArtifactsPath\docs\"
        $MissingDocumentation | Select-Object FileName, LineNumber, Line | Format-Table -AutoSize
        throw 'Missing documentation. Please review and rebuild.'
    }

    Write-Build Gray '           Checking for missing SYNOPSIS in md files...'
    $fSynopsisOutput = @()
    $synopsisEval = Select-String -Path "$script:ArtifactsPath\docs\*.md" -Pattern "^## SYNOPSIS$" -Context 0, 1
    $synopsisEval | ForEach-Object {
        $chAC = $_.Context.DisplayPostContext.ToCharArray()
        if ($null -eq $chAC) {
            $fSynopsisOutput += $_.FileName
        }
    }
    if ($fSynopsisOutput) {
        Write-Build Yellow "             The following files are missing SYNOPSIS:"
        $fSynopsisOutput
        throw 'SYNOPSIS information missing. Please review.'
    }

    # Write-Host '      Creating markdown documentation with PlatyPS'
    # Write-Host -ForegroundColor Green '...Complete!'
    Write-Build Gray '           ...Markdown generation complete.'
} #CreateMarkdownHelp

# Synopsis: Build the external xml help file from markdown help files with PlatyPS
Add-BuildTask CreateExternalHelp -After CreateMarkdownHelp {
    Write-Build Gray '           Creating external xml help file...'
    $null = New-ExternalHelp "$script:ArtifactsPath\docs" -OutputPath "$script:ArtifactsPath\en-US\" -Force
    Write-Build Gray '           ...External xml help file created!'
} #CreateExternalHelp

Add-BuildTask CreateHelpComplete -After CreateExternalHelp {
    Write-Build Green '      ...CreateHelp Complete!'
} #CreateHelpStart

# Synopsis: Replace comment based help (CBH) with external help in all public functions for this project
Add-BuildTask UpdateCBH -After AssetCopy {
    $ExternalHelp = @"
<#
.EXTERNALHELP $($ModuleName)-help.xml
#>
"@

    $CBHPattern = "(?ms)(\<#.*\.SYNOPSIS.*?#>)"
    Get-ChildItem -Path "$script:ArtifactsPath\Public\*.ps1" -File | ForEach-Object {
        $FormattedOutFile = $_.FullName
        Write-Output "      Replacing CBH in file: $($FormattedOutFile)"
        $UpdatedFile = (Get-Content  $FormattedOutFile -raw) -replace $CBHPattern, $ExternalHelp
        $UpdatedFile | Out-File -FilePath $FormattedOutFile -force -Encoding:utf8
    }
} #UpdateCBH

# Synopsis: Copies module assets to Artifacts folder
Add-BuildTask AssetCopy -Before Build {
    Write-Build Gray '        Copying assets to Artifacts...'
    Copy-Item -Path "$script:ModuleSourcePath\*" -Destination $script:ArtifactsPath -Exclude *.psd1, *.psm1 -Recurse -ErrorAction Stop
    Copy-Item -Path "$script:ModuleSourcePath\Resources\Module\src\PSScriptAnalyzerSettings.psd1" -Destination "$script:ArtifactsPath\Resources\Module\src\PSScriptAnalyzerSettings.psd1" -ErrorAction Stop
    Copy-Item -Path "$script:ModuleSourcePath\Resources\Module\src\Module\Module.psm1" -Destination "$script:ArtifactsPath\Resources\Module\src\Module\Module.psm1" -ErrorAction Stop
    # Copy-Item -Path "$script:ModuleSourcePath\Resources\Vault\src\PSVault\PSVault.psd1" -Destination "$script:ArtifactsPath\Resources\Vault\src\PSVault\PSVault.psd1" -ErrorAction Stop
    Copy-Item -Path "$script:ModuleSourcePath\Resources\Vault\src\PSVault\PSVault.psm1" -Destination "$script:ArtifactsPath\Resources\Vault\src\PSVault\PSVault.psm1" -ErrorAction Stop
    Copy-Item -Path "$script:ModuleSourcePath\Resources\Vault\src\PSVault\PSVault.Extension\PSVault.Extension.psd1" -Destination "$script:ArtifactsPath\Resources\Vault\src\PSVault\PSVault.Extension\PSVault.Extension.psd1" -ErrorAction Stop
    Copy-Item -Path "$script:ModuleSourcePath\Resources\Vault\src\PSVault\PSVault.Extension\PSVault.Extension.psm1" -Destination "$script:ArtifactsPath\Resources\Vault\src\PSVault\PSVault.Extension\PSVault.Extension.psm1" -ErrorAction Stop
    Copy-Item -Path "$script:ModuleSourcePath\Resources\Vault\src\PSScriptAnalyzerSettings.psd1" -Destination "$script:ArtifactsPath\Resources\Vault\src\PSScriptAnalyzerSettings.psd1" -ErrorAction Stop
    Write-Build Gray '        ...Assets copy complete.'
} #AssetCopy

# Synopsis: Builds the Module to the Artifacts folder
Add-BuildTask Build {
    Write-Build White '      Performing Module Build'

    Write-Build Gray '        Copying manifest file to Artifacts...'
    #Copy-Item -Path "$script:ModuleSourcePath)" -Destination $script:ArtifactsPath -Recurse -Exclude 'Archive','Artifacts' -ErrorAction Stop
    # Copy-Item -Path (Get-Item -Path "$script:ModuleSourcePath\*" -Exclude ('Archive', 'Artifacts')).FullName -Destination $script:ArtifactsPath -Recurse -Force -ErrorAction Stop
    # Copy-Item -Path (Get-Item -Path "$script:ModuleSourcePath\Resources\*").FullName -Destination $script:ArtifactsPath -Recurse -Force -ErrorAction Stop
    Copy-Item -Path $script:ModuleManifestFile -Destination $script:ArtifactsPath -Recurse -ErrorAction Stop
    Write-Build Gray '        ...manifest copy complete.'

    Write-Build Gray '        Merging Public and Private functions to one module file...'
    #$private = "$script:ModuleSourcePath\Private"
    $scriptContent = [System.Text.StringBuilder]::new()
    #$powerShellScripts = Get-ChildItem -Path $script:ModuleSourcePath -Filter '*.ps1' -Recurse
    $powerShellScripts = Get-ChildItem -Path $script:ArtifactsPath -Filter '*.ps1' -Recurse | Where-Object { $_.FullName -notmatch 'Resources' }
    foreach ($script in $powerShellScripts) {
        $null = $scriptContent.Append((Get-Content -Path $script.FullName -Raw))
        $null = $scriptContent.AppendLine('')
        $null = $scriptContent.AppendLine('')
    }
    $scriptContent.ToString() | Out-File -FilePath $script:BuildModuleRootFile -Encoding utf8 -Force
    Write-Build Gray '        ...Module creation complete.'

    #here we update the parent level docs. If you would prefer not to update them, comment out this section.
    Write-Build Gray '        Overwriting docs output...'
    Move-Item "$script:ArtifactsPath\docs\*.md" -Destination "..\docs\" -Force
    Remove-Item "$script:ArtifactsPath\docs" -Recurse -Force -ErrorAction Stop
    Write-Build Gray '        ...Docs output completed.'

    Write-Build Gray '        Cleaning up leftover artifacts...'
    #cleanup artifacts that are no longer required
    Remove-Item "$script:ArtifactsPath\Imports.ps1" -Force -ErrorAction SilentlyContinue
    Remove-Item "$script:ArtifactsPath\Public" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$script:ArtifactsPath\Private" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Build Green '        ...Build Complete!'
} #Build

#Synopsis: Invokes all Pester Infrastructure Tests in the Tests\Infrastructure folder (if it exists)
Add-BuildTask InfraTest {
    if (Test-Path -Path $script:InfraTestsPath) {

        Remove-Module -Name Pester -Force -ErrorAction 'SilentlyContinue'# there are instances where some containers have Pester already in the session
        Import-Module -Name Pester -MinimumVersion $script:MinPesterVersion -MaximumVersion $script:MaxPesterVersion -ErrorAction 'Stop'

        $pesterConfiguration = [PesterConfiguration]::new()
        $pesterConfiguration.run.Path = $script:InfraTestsPath
        $pesterConfiguration.Run.PassThru = $true
        $pesterConfiguration.Run.Exit = $false
        $pesterConfiguration.CodeCoverage.Enabled = $false
        $pesterConfiguration.Output.Verbosity = 'Detailed'

        Write-Build White "      Performing Pester Infrastructure Tests in $($invokePesterParams.path)"
        # Publish Test Results as NUnitXml
        $testResults = Invoke-Pester -Configuration $pesterConfiguration

        # This will output a nice json for each failed test (if running in CodeBuild)
        if ($env:CODEBUILD_BUILD_ARN) {
            $testResults.TestResult | ForEach-Object {
                if ($_.Result -ne 'Passed') {
                    ConvertTo-Json -InputObject $_ -Compress
                }
            }
        }

        $numberFails = $testResults.FailedCount
        Assert-Build($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)
        Write-Build Green '      ...Pester Infrastructure Tests Complete!'
    }
} #InfraTest

#Synopsis: Creates an archive of the built Module
Add-BuildTask Archive {
    Write-Build White '        Performing Archive...'

    $archivePath = Join-Path -Path $BuildRoot -ChildPath 'Archive'
    if (Test-Path -Path $archivePath) {
        $null = Remove-Item -Path $archivePath -Recurse -Force
    }

    $null = New-Item -Path $archivePath -ItemType Directory -Force

    $zipFileName = '{0}_{1}_{2}.{3}.zip' -f $script:ModuleName, $script:ModuleVersion, ([DateTime]::UtcNow.ToString("yyyyMMdd")), ([DateTime]::UtcNow.ToString("hhmmss"))
    $zipFile = Join-Path -Path $archivePath -ChildPath $zipFileName

    if ($PSEdition -eq 'Desktop') {
        Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
    }
    [System.IO.Compression.ZipFile]::CreateFromDirectory($script:ArtifactsPath, $zipFile)

    Write-Build Green '        ...Archive Complete!'
} #Archive
