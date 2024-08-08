BeforeAll {
    Set-Location -Path $PSScriptRoot
    $ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
    $manifestContent = Test-ModuleManifest -Path $PathToManifest
    $moduleExported = Get-Command -Module $ModuleName | Select-Object -ExpandProperty Name
    $manifestExported = ($manifestContent.ExportedFunctions).Keys
}
BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
    $manifestContent = Test-ModuleManifest -Path $PathToManifest
    $moduleExported = Get-Command -Module $ModuleName | Select-Object -ExpandProperty Name
    $manifestExported = ($manifestContent.ExportedFunctions).Keys
}
Describe $ModuleName {

    Context 'Exported Commands' -Fixture {

        Context 'Number of commands' -Fixture {

            It 'Exports the same number of public functions as what is listed in the Module Manifest' {
                $manifestExported.Count | Should -BeExactly $moduleExported.Count
            }

        }

        Context 'Explicitly exported commands' {

            It 'Includes <_> in the Module Manifest ExportedFunctions' -ForEach $moduleExported {
                $manifestExported -contains $_ | Should -BeTrue
            }

        }
    } #context_ExportedCommands

}
