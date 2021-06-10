#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'Catesta'
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
$manifestContent = Test-ModuleManifest -Path $PathToManifest
$moduleExported = Get-Command -Module $ModuleName | Select-Object -ExpandProperty Name

Describe -Name $ModuleName -Fixture {

    Context -Name 'Exported Commands' -Fixture {
        $manifestExported = ($manifestContent.ExportedFunctions).Keys

        Context -Name 'Number of commands' -Fixture {
            It -Name 'Exports the same number of public funtions as what is listed in the Module Manifest' -Test {
                $manifestExported.Count | Should -BeExactly $moduleExported.Count
            }
        }

        Context -Name 'Explicitly exported commands' -Fixture {
            foreach ($command in $moduleExported) {
                It -Name "Includes the $command in the Module Manifest ExportedFunctions" -Test {
                    $manifestExported -contains $command | Should -BeTrue
                }
            }
        }
    }

    Context -Name 'Command Help' -ForEach $moduleExported {
        foreach ($command in $moduleExported) {
            BeforeAll {
                $help = Get-Help -Name $_ -Full
            }
            Context -Name $command -Fixture {
                $help = Get-Help -Name $command -Full

                It -Name 'Includes a Synopsis' -Test {
                    $help.Synopsis | Should -Not -BeNullOrEmpty
                }

                It -Name 'Includes a Description' -Test {
                    $help.description.Text | Should -Not -BeNullOrEmpty
                }

                It -Name 'Includes an Example' -Test {
                    $help.examples.example | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
