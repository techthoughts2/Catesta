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
    This build file by Catesta will pull in configurations from the "<module>.Settings.ps1" file as well, where users can more easily customize the build process if required.
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
<%
if ($PLASTER_PARAM_CodingStyle -eq 'Stroustrup' -or $PLASTER_PARAM_CodingStyle -eq 'OTBS' -or $PLASTER_PARAM_CodingStyle -eq 'Allman') {
    @'
$str += 'FormattingCheck'
'@
}
%>
$str += 'Analyze', 'Test'
$str2 = $str
$str2 += 'Build', 'Archive'
$str += 'Build', 'InfraTest', 'Archive'
Add-BuildTask -Name . -Jobs $str

#Local testing build process
Add-BuildTask TestLocal Clean, ImportModuleManifest, Analyze, Test

#Full build sans infra tests
Add-BuildTask BuildNoInfra -Jobs $str2

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
    $script:InfraTestsPath = Join-Path -Path $script:TestsPath -ChildPath 'Integration'

    $script:ArtifactsPath = Join-Path -Path $BuildRoot -ChildPath 'Artifacts'
    $script:ArchivePath = Join-Path -Path $BuildRoot -ChildPath 'Archive'

    $script:BuildModuleRootFile = Join-Path -Path $script:ArtifactsPath -ChildPath "$($script:ModuleName).psm1"

    # Ensure our builds fail until if below a minimum defined code test coverage threshold
    $script:coverageThreshold = 0

<%
if ($PLASTER_PARAM_Pester -eq '4') {
        @'
    [version]$script:MinPesterVersion = '4.0.0'
    [version]$script:MaxPesterVersion = '4.99.99'
'@
}
elseif ($PLASTER_PARAM_Pester -eq '5') {
        @'
    [version]$script:MinPesterVersion = '5.2.2'
    [version]$script:MaxPesterVersion = '5.99.99'
'@
}
%>
<%
if ($PLASTER_PARAM_CICD -eq 'BITBUCKET' -or $PLASTER_PARAM_CICD -eq 'GITLAB') {
        @'
    $script:testOutputFormat = 'JUnitXml'
'@
}
else {
        @'
    $script:testOutputFormat = 'NUnitXML'
'@
}
%>
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
    Assert-Build ($PSVersionTable.PSVersion -ge $script:requiredPSVersion) "At least Powershell $script:requiredPSVersion is required for this build to function properly"
    Write-Build Green '      ...Verification Complete!'
} #ValidateRequirements

# Synopsis: Import the current module manifest file for processing
Add-BuildTask TestModuleManifest -Before ImportModuleManifest {
    Write-Build White '      Running module manifest tests...'
    Assert-Build (Test-Path $script:ModuleManifestFile) 'Unable to locate the module manifest file.'
    Assert-Build (Test-ManifestBool -Path $script:ModuleManifestFile) 'Module Manifest test did not pass verification.'
    Write-Build Green '      ...Module Manifest Verification Complete!'
} #f5b33218-bde4-4028-b2a1-9c206f089503

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
        Path    = $script:ModuleSourcePath
        Setting = 'PSScriptAnalyzerSettings.psd1'
        Recurse = $true
        Verbose = $false
    }

    Write-Build White '      Performing Module ScriptAnalyzer checks...'
    $scriptAnalyzerResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

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

<%
if ($PLASTER_PARAM_Pester -eq '4') {
            @'
        $scriptAnalyzerParams = @{
            Path    = $script:TestsPath
            Setting = 'PSScriptAnalyzerSettings.psd1'
            Recurse = $true
            Verbose = $false
        }
'@
}
elseif ($PLASTER_PARAM_Pester -eq '5') {
            @'
        $scriptAnalyzerParams = @{
            Path        = $script:TestsPath
            Setting     = 'PSScriptAnalyzerSettings.psd1'
            ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
            Recurse     = $true
            Verbose     = $false
        }
'@
}
%>

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

<%
    if ($PLASTER_PARAM_CodingStyle -eq 'Stroustrup') {
        @'
    $scriptAnalyzerParams = @{
        Setting     = 'CodeFormattingStroustrup'
        ExcludeRule = 'PSUseConsistentWhitespace'
        Recurse     = $true
        Verbose     = $false
    }
'@
    }
%>
<%
    if ($PLASTER_PARAM_CodingStyle -eq 'OTBS') {
        @'
    $scriptAnalyzerParams = @{
        Setting     = 'CodeFormattingOTBS'
        ExcludeRule = 'PSUseConsistentWhitespace'
        Recurse     = $true
        Verbose     = $false
    }
'@
    }
%>
<%
    if ($PLASTER_PARAM_CodingStyle -eq 'Allman') {
        @'
    $scriptAnalyzerParams = @{
        Setting     = 'CodeFormattingAllman'
        ExcludeRule = 'PSUseConsistentWhitespace'
        Recurse     = $true
        Verbose     = $false
    }
'@
    }
%>

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

    Write-Build White "      Importing desired Pester version. Min: $script:MinPesterVersion Max: $script:MaxPesterVersion"
    Remove-Module -Name Pester -Force -ErrorAction SilentlyContinue # there are instances where some containers have Pester already in the session
    Import-Module -Name Pester -MinimumVersion $script:MinPesterVersion -MaximumVersion $script:MaxPesterVersion -ErrorAction 'Stop'

    $codeCovPath = "$script:ArtifactsPath\ccReport\"
    $testOutPutPath = "$script:ArtifactsPath\testOutput\"
    if (-not(Test-Path $codeCovPath)) {
        New-Item -Path $codeCovPath -ItemType Directory | Out-Null
    }
    if (-not(Test-Path $testOutPutPath)) {
        New-Item -Path $testOutPutPath -ItemType Directory | Out-Null
    }
    if (Test-Path -Path $script:UnitTestsPath) {
<%
if ($PLASTER_PARAM_Pester -eq '4') {
            @'
        $invokePesterParams = @{
            Path                         = $script:UnitTestsPath
            Strict                       = $true
            PassThru                     = $true
            Verbose                      = $false
            EnableExit                   = $false
            CodeCoverage                 = "$ModuleName\*\*.psm1"
            CodeCoverageOutputFile       = "$codeCovPath\CodeCoverage.xml"
            CodeCoverageOutputFileFormat = 'JaCoCo'
            OutputFile                   = "$testOutPutPath\PesterTests.xml"
            OutputFormat                 = $script:testOutputFormat
        }

        Write-Build White '      Performing Pester Unit Tests...'
        # Publish Test Results
        $testResults = Invoke-Pester @invokePesterParams
'@
}
elseif ($PLASTER_PARAM_Pester -eq '5') {
            @'
        $pesterConfiguration = New-PesterConfiguration
        $pesterConfiguration.run.Path = $script:UnitTestsPath
        $pesterConfiguration.Run.PassThru = $true
        $pesterConfiguration.Run.Exit = $false
        $pesterConfiguration.CodeCoverage.Enabled = $true
        $pesterConfiguration.CodeCoverage.Path = "..\..\$ModuleName\*\*.psm1"
        $pesterConfiguration.CodeCoverage.CoveragePercentTarget = $script:coverageThreshold
        $pesterConfiguration.CodeCoverage.OutputPath = "$codeCovPath\CodeCoverage.xml"
        $pesterConfiguration.CodeCoverage.OutputFormat = 'JaCoCo'
        $pesterConfiguration.TestResult.Enabled = $true
        $pesterConfiguration.TestResult.OutputPath = "$testOutPutPath\PesterTests.xml"
        $pesterConfiguration.TestResult.OutputFormat = $script:testOutputFormat
        $pesterConfiguration.Output.Verbosity = 'Detailed'

        Write-Build White '      Performing Pester Unit Tests...'
        # Publish Test Results
        $testResults = Invoke-Pester -Configuration $pesterConfiguration
'@
}
%>

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

<%
if ($PLASTER_PARAM_Pester -eq '4') {
            @'
        Write-Build Gray ('      ...CODE COVERAGE - NumberOfCommandsExecuted: {0}' -f $testResults.CodeCoverage.NumberOfCommandsExecuted)
        Write-Build Gray ('      ...CODE COVERAGE - NumberOfCommandsAnalyzed: {0}' -f $testResults.CodeCoverage.NumberOfCommandsAnalyzed)

        if ($testResults.CodeCoverage.NumberOfCommandsExecuted -ne 0) {
            $coveragePercent = '{0:N2}' -f ($testResults.CodeCoverage.NumberOfCommandsExecuted / $testResults.CodeCoverage.NumberOfCommandsAnalyzed * 100)

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
                Write-Build Cyan "      $('Covered {0}% of {1} analyzed commands in {2} files.' -f $coveragePercent,$testResults.CodeCoverage.NumberOfCommandsAnalyzed,$testResults.CodeCoverage.NumberOfFilesAnalyzed)"
                Write-Build Green '      ...Pester Unit Tests Complete!'
            }
        }
        else {
            # account for new module build condition
            Write-Build Yellow '      Code coverage check skipped. No commands to execute...'
        }
'@
}
elseif ($PLASTER_PARAM_Pester -eq '5') {
            @'
        Write-Build Gray ('      ...CODE COVERAGE - CommandsExecutedCount: {0}' -f $testResults.CodeCoverage.CommandsExecutedCount)
        Write-Build Gray ('      ...CODE COVERAGE - CommandsAnalyzedCount: {0}' -f $testResults.CodeCoverage.CommandsAnalyzedCount)

        if ($testResults.CodeCoverage.NumberOfCommandsExecuted -ne 0) {
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
'@
}
%>

    }
} #Test

#Synopsis: Used primarily during active development to generate xml file to graphically display code coverage in VSCode using Coverage Gutters
Add-BuildTask DevCC {
    Write-Build White '      Generating code coverage report at root...'
    Write-Build White "      Importing desired Pester version. Min: $script:MinPesterVersion Max: $script:MaxPesterVersion"
    Remove-Module -Name Pester -Force -ErrorAction SilentlyContinue # there are instances where some containers have Pester already in the session
    Import-Module -Name Pester -MinimumVersion $script:MinPesterVersion -MaximumVersion $script:MaxPesterVersion -ErrorAction 'Stop'
<%
if ($PLASTER_PARAM_Pester -eq '4') {
        @'
    $invokePesterParams = @{
        Path                   = $script:UnitTestsPath
        CodeCoverage           = "$ModuleName\*\*.ps1"
        CodeCoverageOutputFile = '..\..\..\cov.xml'
    }
    Invoke-Pester @invokePesterParams
'@
}
elseif ($PLASTER_PARAM_Pester-eq '5') {
        @'
    $pesterConfiguration = New-PesterConfiguration
    $pesterConfiguration.run.Path = $script:UnitTestsPath
    $pesterConfiguration.CodeCoverage.Enabled = $true
    $pesterConfiguration.CodeCoverage.Path = "$PSScriptRoot\$ModuleName\*\*.ps1"
    $pesterConfiguration.CodeCoverage.CoveragePercentTarget = $script:coverageThreshold
    $pesterConfiguration.CodeCoverage.OutputPath = '..\..\..\cov.xml'
    $pesterConfiguration.CodeCoverage.OutputFormat = 'CoverageGutters'

    Invoke-Pester -Configuration $pesterConfiguration
'@
}
%>
    Write-Build Green '      ...Code Coverage report generated!'
} #DevCC

# Synopsis: Copies module assets to Artifacts folder
Add-BuildTask AssetCopy -Before Build {
    Write-Build Gray '        Copying assets to Artifacts...'
    $dirDest = New-Item -Path "$script:ArtifactsPath\$ModuleName.Extension" -ItemType Directory -ErrorAction Stop
    Copy-Item -Path "$script:ModuleSourcePath\$ModuleName.Extension\*" -Destination $dirDest -Recurse -Force -ErrorAction Stop
    Write-Build Gray '        ...Assets copy complete.'
} #AssetCopy

# Synopsis: Builds the Module to the Artifacts folder
Add-BuildTask Build {
    Write-Build White '      Performing Module Build'

    Write-Build Gray '        Copying manifest file to Artifacts...'
    Copy-Item -Path $script:ModuleManifestFile -Destination $script:ArtifactsPath -Recurse -ErrorAction Stop
    #Copy-Item -Path $script:ModuleSourcePath\bin -Destination $script:ArtifactsPath -Recurse -ErrorAction Stop
    Write-Build Gray '        ...manifest copy complete.'

    Write-Build Green '      ...Build Complete!'
} #Build

#Synopsis: Invokes all Pester Integration Tests in the Tests\Integration folder (if it exists)
Add-BuildTask InfraTest {
    if (Get-ChildItem -Path $script:InfraTestsPath -Filter "*.Tests.ps1" -Recurse) {
        Write-Build White "      Importing desired Pester version. Min: $script:MinPesterVersion Max: $script:MaxPesterVersion"
        Remove-Module -Name Pester -Force -ErrorAction SilentlyContinue # there are instances where some containers have Pester already in the session
        Import-Module -Name Pester -MinimumVersion $script:MinPesterVersion -MaximumVersion $script:MaxPesterVersion -ErrorAction 'Stop'

        Write-Build White "      Performing Pester Integration Tests in $($invokePesterParams.path)"

<%
if ($PLASTER_PARAM_Pester -eq '4') {
            @'
        $invokePesterParams = @{
            Path       = $script:InfraTestsPath
            Strict     = $true
            PassThru   = $true
            Verbose    = $false
            EnableExit = $false
        }


        # Publish Test Results
        $testResults = Invoke-Pester @invokePesterParams
'@
}
elseif ($PLASTER_PARAM_Pester -eq '5') {
            @'
        $pesterConfiguration = New-PesterConfiguration
        $pesterConfiguration.run.Path = $script:InfraTestsPath
        $pesterConfiguration.Run.PassThru = $true
        $pesterConfiguration.Run.Exit = $false
        $pesterConfiguration.CodeCoverage.Enabled = $false
        $pesterConfiguration.TestResult.Enabled = $false
        $pesterConfiguration.Output.Verbosity = 'Detailed'

        $testResults = Invoke-Pester -Configuration $pesterConfiguration
'@
}
%>
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
        Write-Build Green '      ...Pester Integration Tests Complete!'
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
