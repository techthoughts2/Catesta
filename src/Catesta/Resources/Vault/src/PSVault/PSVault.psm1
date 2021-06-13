<#
This is an entirely optional psm1 which you can leverage to surface up
custom functions to <%=$PLASTER_PARAM_ModuleName%>.psd1
You could create a specialized wrapper function for Registering/Unregistering your vault.
You could create specialized configuration functions.
You could also register autocompleters here.
A few examples have been included below.
#>

# <#
# .SYNOPSIS
#     Custom function for retrieving configuration details about your vault.
# #>
# function Get-<%=$PLASTER_PARAM_ModuleName%>Configuration {
#     [CmdletBinding()]
#     param (

#     )
# }#Get-<%=$PLASTER_PARAM_ModuleName%>Configuration


<#
.SYNOPSIS
    Custom function for setting configuration details about your vault.
#>
# function Set-<%=$PLASTER_PARAM_ModuleName%>Configuration {
#     [CmdletBinding()]
#     param (

#     )
# }#Get-<%=$PLASTER_PARAM_ModuleName%>Configuration

<#
.SYNOPSIS
    Custom wrapper function for registering your vault.
#>
# function Register-<%=$PLASTER_PARAM_ModuleName%>Vault {
#     [CmdletBinding()]
#     param (

#     )

#     $params = @{

#     }

#     Register-SecretVault @Params
# }#Register-<%=$PLASTER_PARAM_ModuleName%>Configuration

<#
.SYNOPSIS
    Custom wrapper function for unregistering your vault.
#>
# function Unregister-<%=$PLASTER_PARAM_ModuleName%>Vault {
#     [CmdletBinding()]
#     param (

#     )

#     $params = @{

#     }

#     Unregister-SecretVault @params
# }#Unregister-<%=$PLASTER_PARAM_ModuleName%>Configuration

<#
.SYNOPSIS
    Entirely custom function for performing some type of connection related to your vault.
#>
# function Connect-<%=$PLASTER_PARAM_ModuleName%> {
#     [CmdletBinding()]
#     param (

#     )
# }#Connect-<%=$PLASTER_PARAM_ModuleName%>Configuration

<#
.SYNOPSIS
    Entirely custom function for performing some type of disconnect related to your vault.
#>
# function Disconnect-<%=$PLASTER_PARAM_ModuleName%> {
#     [CmdletBinding()]
#     param (

#     )
# }#Disconnect-<%=$PLASTER_PARAM_ModuleName%>Configuration

<#
Some example of registering argument completers
#>

# $vaultArgCompleter = {
#     param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

#     (Get-SecretVault -Name "*$wordToComplete*") | Select-Object -ExpandProperty Name
# }
# $vaultSplat = @{
#     CommandName   = 'Register-<%=$PLASTER_PARAM_ModuleName%>Vault'
#     ParameterName = 'Name'
#     ScriptBlock   = $vaultArgCompleter
# }
# Register-ArgumentCompleter @vaultSplat

# $vaultURArgCompleter = {
#     param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

#     (Get-SecretVault -Name "*$wordToComplete*") | Select-Object -ExpandProperty Name
# }
# $vaultURArgSplat = @{
#     CommandName   = 'Unregister-<%=$PLASTER_PARAM_ModuleName%>Vault'
#     ParameterName = 'Name'
#     ScriptBlock   = $vaultURArgCompleter
# }
# Register-ArgumentCompleter @$vaultURArgSplat