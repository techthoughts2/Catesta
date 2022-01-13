<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    C:\PS>
    Example of how to use this cmdlet
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    <%=$PLASTER_PARAM_ModuleName%>
#>
function Get-Day {
    [CmdletBinding()]
    param (
        # [Parameter(Mandatory = $true,
        #     HelpMessage = 'Helpful Message')]
        # [ValidateNotNull()]
        # [ValidateNotNullOrEmpty()]
        # [string]$YourParameter
    )
    try {
        $day = (Get-Date -ErrorAction 'Stop').DayOfWeek
    }
    catch {
        $day = 'Unknown'
    }

    return $day
} #Get-Day
