# #-------------------------------------------------------------------------
# Set-Location -Path $PSScriptRoot
# #-------------------------------------------------------------------------
# $ModuleName = '<%=$PLASTER_PARAM_ModuleName%>'
# #-------------------------------------------------------------------------
# #if the module is already in memory, remove it
# Get-Module $ModuleName | Remove-Module -Force
# $PathToManifest = [System.IO.Path]::Combine('..', '..', 'Artifacts', "$ModuleName.psd1")
# #-------------------------------------------------------------------------
# Import-Module $PathToManifest -Force
# #-------------------------------------------------------------------------
# Describe 'Integration Tests' -Tag Integration {
#     Context 'First Integration Tests' {
#         It 'should pass the first integration test' {
#             # test logic
#         } #it
#     }
# }
