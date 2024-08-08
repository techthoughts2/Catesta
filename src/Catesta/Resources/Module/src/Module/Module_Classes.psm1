# this psm1 is for local testing and development use only

# dot source the parent import for local development variables
. $PSScriptRoot\Imports.ps1

# discover all ps1 file(s) in Public and Private paths

$itemSplat = @{
    Filter      = '*.ps1'
    Recurse     = $true
    ErrorAction = 'Stop'
}
try {
    $public = @(Get-ChildItem -Path "$PSScriptRoot\Public" @itemSplat)
    $private = @(Get-ChildItem -Path "$PSScriptRoot\Private" @itemSplat)
    $classes = @(Get-ChildItem -Path "$PSScriptRoot\Classes" @itemSplat)
}
catch {
    Write-Error $_
    throw 'Unable to get get file information from Public/Private/Classes src.'
}

# dot source all .ps1 file(s) found
foreach ($file in @($public + $private + $classes)) {
    try {
        . $file.FullName
    }
    catch {
        throw ('Unable to dot source {0}' -f $file.FullName)
    }
}

# export all public functions
Export-ModuleMember -Function $public.Basename
