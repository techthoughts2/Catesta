#region supporting functions

function Convert-PSObjectToMarkdownText {
    <#
    .SYNOPSIS
        Converts a PowerShell object to a text formatted Markdown string.
    .DESCRIPTION
        The Convert-PSObjectToMarkdownText function converts a PowerShell object to a text formatted Markdown string.
        The object can contain nested objects, which will be processed recursively.
        The resulting Markdown string is wrapped in a code block for easy formatting.
    .EXAMPLE
        $object = [pscustomobject]@{
            Property1 = 'Value 1'
            Property2 = 'Value 2'
            NestedObject = [pscustomobject]@{
                Property3 = 'Value 3'
                Property4 = 'Value 4'
            }
        }
        Convert-PSObjectToMarkdownText -Object $object
        ```text
        Property1 : Value 1
        Property2 : Value 2
        NestedObject :
            Property3 : Value 3
            Property4 : Value 4
        ```

        Takes in a custom PowerShell object and returns text formatted Markdown string.
    .PARAMETER Object
        The object to convert to a text formatted Markdown string.
    .OUTPUTS
        System.String
    .NOTES

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        $Object
    )
    # Create a new string builder to store and return the output
    $sb = New-Object System.Text.StringBuilder

    $sb.AppendLine('```text') | Out-Null

    $convertToMarkdownSplat = @{
        Object  = $Object
        Verbose = $VerbosePreference
        Debug   = $DebugPreference
    }
    Write-Verbose -Message 'Converting object to text Markdown...'
    $markResults = ConvertTo-Markdown @convertToMarkdownSplat
    $sb.Append($markResults) | Out-Null

    $sb.AppendLine('```') | Out-Null

    return $sb.ToString()
} #Convert-PSObjectToMarkdownText

function ConvertTo-Markdown {
    <#
    .SYNOPSIS
        Converts a PowerShell object and its nested objects to a text formatted Markdown string.
    .DESCRIPTION
        The ConvertTo-Markdown function converts a PowerShell object to a text formatted Markdown string.
        The object can contain nested objects, which will be processed recursively.
        The resulting Markdown string is indented to indicate the nesting level.
    .EXAMPLE
        $object = [pscustomobject]@{
            Property1 = 'Value 1'
            Property2 = 'Value 2'
            NestedObject = [pscustomobject]@{
                Property3 = 'Value 3'
                Property4 = 'Value 4'
            }
        }
        ConvertTo-Markdown -Object $object
        Property1 : Value 1
        Property2 : Value 2
        NestedObject :
            Property3 : Value 3
            Property4 : Value 4

        Takes in a custom PowerShell object and returns a string format for use with Markdown.
    .PARAMETER Object
        The object to convert to a text formatted Markdown string.
    .PARAMETER Tab
        The tab character(s) to use for indentation. The default is four spaces.
    .PARAMETER IsNested
        Indicates whether the current object is a nested object or not. This is used to determine the appropriate indentation level.
    .OUTPUTS
        System.String
    .NOTES

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        $Object,
        [Parameter(Mandatory = $false)]
        [string]$Tab = "",
        [Parameter(Mandatory = $false)]
        [switch]$IsNested
    )

    # Create a new string builder to store the markdown output
    $sb = New-Object System.Text.StringBuilder

    $Object | ForEach-Object {
        # Iterate through the properties of the object
        foreach ($property in $_.PSObject.Properties) {
            # _____________
            # resets
            $name = $null
            $value = $null
            $type = $null
            # _____________
            $name = $property.Name
            $value = $property.Value
            $type = $property.TypeNameOfValue

            Write-Debug -Message ('Name:{0} - Value:{1} - Type:{2}' -f $name, $value, $type)

            # If the value is a PSCustomObject, recursively convert it to markdown
            if ($property.TypeNameOfValue -like '*System.Management.Automation.PSObject*' -or
                $property.TypeNameOfValue -eq 'System.Management.Automation.PSCustomObject') {
                Write-Debug -Message ('{0} - nested object' -f $name)
                # Do not tab over the parent object
                $sb.AppendLine(('{0}:' -f $name)) | Out-Null
                # Increase the tab offset for the nested object
                $sb.Append(('{0}{1}' -f $tab, (ConvertTo-Markdown -Object $value -tab "$tab    " -IsNested))) | Out-Null
            }
            else {
                Write-Debug -Message ('{0} - parent object' -f $name)
                # Otherwise, just add the property name and value to the markdown output
                $sb.AppendLine(('{0}{1} : {2}' -f $tab, $name, $value)) | Out-Null
            }
        }
        # Add a blank line between parent objects, but not nested objects
        if (-not $IsNested) {
            $sb.AppendLine() | Out-Null
        }
    }

    return $sb.ToString()
} #ConvertTo-Markdown

#endregion

#region context

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$moduleManifestPath = "$scriptPath\..\src\Catesta\Resources\Module\plasterManifest.xml"
$moduleDocOutPath = "$scriptPath\..\docs\Catesta-ManifestSchema.md"

#endregion

#region manifest parsing

$moduleManifestInfo = Test-PlasterManifest -Path $moduleManifestPath
$childInfo = $moduleManifestInfo.ChildNodes | Where-Object { $_.templateType -eq 'Project' }
$parameters = $childInfo.parameters.parameter

$parameterArray = New-Object System.Collections.Generic.List[PSCustomObject]

foreach ($parameter in $parameters) {
    # _____________________
    # resets
    $obj = $null
    $choices = $null
    $choiceArray = $null
    $choiceObj = $null
    # _____________________
    $obj = [PSCustomObject]@{
        name = $parameter.name
        type = $parameter.type
    }
    if ($parameter.type -eq 'choice' -or $parameter.type -eq 'multichoice') {
        $choices = $parameter.choice
        $choiceArray = New-Object System.Collections.Generic.List[PSCustomObject]
        foreach ($choice in $choices) {
            $choiceObj = [PSCustomObject]@{
                'value' = $choice.value
                'help'  = $choice.help
            }
            $choiceArray.Add($choiceObj)
        }
        if ($parameter.condition -like '*$PLASTER_PARAM*') {
            $obj | Add-Member -type NoteProperty -Name condition -Value $parameter.condition
        }
        $obj | Add-Member -type NoteProperty -Name choices -Value $choiceArray
    }
    if ($parameter.default -ne '0') {
        $obj | Add-Member -type NoteProperty -Name 'default' -Value $parameter.default
    }

    $parameterArray.Add($obj)
}

#endregion

#region example generator

$obj = [PSCustomObject]@{
}
foreach ($parameter in $parameterArray) {
    $index = 0
    if ($parameter.type -eq 'text') {
        if ($parameter.name -ne 'S3Bucket') {
            switch ($parameter.name) {
                Version {
                    $obj | Add-Member -type NoteProperty -Name $parameter.name -Value "'0.0.1'"
                 }
                Default {
                    $obj | Add-Member -type NoteProperty -Name $parameter.name -Value "'text'"
                }
            }

        }
    }
    elseif ($parameter.type -eq 'user-fullname') {
        $obj | Add-Member -type NoteProperty -Name $parameter.name -Value "'user full name'"
    }
    elseif ($parameter.type -eq 'multichoice') {
        $strBuild = $parameter.choices.value -join ''','''
        $strBuild = "'" + $strBuild
        $strBuild += "'"
        $obj | Add-Member -type NoteProperty -Name $parameter.name -Value $strBuild
    }
    else{
        if ($parameter.choices[0].value -eq 'NONE') {
            $index++
        }
        $obj | Add-Member -type NoteProperty -Name $parameter.name -Value "'$($parameter.choices[$index].value)'"
    }
}
$exampleObj = $obj | Out-String
$exampleObj = $exampleObj.Replace(':','=')

#endregion

#region markdown scaffold

$markdown = @'
# Catesta - Manifest Schema

## Synopsis

tbd

## Description

tbd


'@

#endregion

#region main

$moduleManifestSchema = Convert-PSObjectToMarkdownText -Object $parameterArray
$markdown += @"
## Module Schema

$moduleManifestSchema
"@

$markdown += @"
### Example

``````powershell
`$moduleParameters = @{
    $exampleObj
}
New-ModuleProject -ModuleParameters `$moduleParameters -DestinationPath .
``````
"@
$markdown | Out-File -FilePath $moduleDocOutPath -Encoding utf8BOM -Force

#endregion
