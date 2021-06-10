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
# Describe 'Infrastructure Tests' -Tag Infrastructure {
#     Context 'First Infra Tests' {
#         It 'should pass the first infra test' {
#             # test logic
#         } #it
#     }
# }