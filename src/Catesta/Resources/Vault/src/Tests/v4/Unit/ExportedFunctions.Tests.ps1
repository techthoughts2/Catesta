#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
Describe $ModuleName {

    $manifestContent = Test-ModuleManifest -Path $PathToManifest
    $moduleExported = Get-Command -Module $ModuleName | Select-Object -ExpandProperty Name

    Context 'Exported Commands' -Fixture {
        $manifestExported = ($manifestContent.ExportedFunctions).Keys

        Context 'Number of commands' -Fixture {
            It -Name 'Exports the same number of public functions as what is listed in the Module Manifest' -Test {
                $manifestExported.Count | Should -BeExactly $moduleExported.Count
            }
        }

        Context 'Explicitly exported commands' -Fixture {
            foreach ($command in $moduleExported) {
                It -Name "Includes the $command in the Module Manifest ExportedFunctions" -Test {
                    $manifestExported -contains $command | Should -BeTrue
                }
            }
        }
    }

}