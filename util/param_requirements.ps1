#region context

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcPath = "$scriptPath\..\src"

#endregion

#region logic

$pattern1 = '\$PLASTER_PARAM_'
$pattern2 = '<%=$PLASTER_PARAM_'

$getChildItemSplat = @{
    Path    = $srcPath
    Recurse = $true
    Exclude = '*.xml', '*.zip'
}
$result = Get-ChildItem @getChildItemSplat | Where-Object {
    $_.DirectoryName -notmatch "Archive|Artifacts|Tests" -and
    $_.PSIsContainer -ne $true
} | ForEach-Object {
    $fileName = $_.Name
    Get-Content $_ | Select-String -Pattern $pattern1, $pattern2 | ForEach-Object {
        [PSCustomObject]@{
            FileName = $fileName
            Line     = $_.Line
        }
    }
}

$regex = '\$PLASTER_PARAM_[A-Za-z]+'
$matches = $result.Line -match $pattern

$matchArray = New-Object System.Collections.Generic.List[string]
$result.Line | ForEach-Object {
    $match = $null
    $match = Select-String -InputObject $_ -Pattern $regex -AllMatches | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value
    if ($match) {
        $matchArray.Add($match)
    }
}
$uniqueMatches = $matchArray | Select-Object -Unique
$finalArray = New-Object System.Collections.Generic.List[string]
$delimiter = '\$PLASTER_PARAM_'
foreach ($inputString in $uniqueMatches) {
    $lastValue = $null
    $lastValue = ($inputString -split $delimiter)[-1]
    $finalArray.Add($lastValue)
}

# $result | Select-Object -Unique FileName, Line | Sort-Object FileName, Line
$finalArray | Select-Object -Unique

#endregion
