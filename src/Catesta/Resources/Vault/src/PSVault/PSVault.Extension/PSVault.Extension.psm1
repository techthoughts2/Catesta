function Get-Secret {
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    # return [TestStore]::GetItem($Name, $AdditionalParameters)
    return $null
}

function Get-SecretInfo {
    [CmdletBinding()]
    param (
        [string] $Filter,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    # return [TestStore]::GetItemInfo($Filter, $AdditionalParameters)
    return @(, [Microsoft.PowerShell.SecretManagement.SecretInformation]::new(
            "Name", # Name of secret
            "String", # Secret data type [Microsoft.PowerShell.SecretManagement.SecretType]
            $VaultName))   # Name of vault
}

function Set-Secret {
    [CmdletBinding()]
    param (
        [string] $Name,
        [object] $Secret,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    # return [TestStore]::SetItem($Name, $Secret)
    return $false
}

function Remove-Secret {
    [CmdletBinding()]
    param (
        [string] $Name,
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    # return [TestStore]::RemoveItem($Name)
    return $false
}

function Test-SecretVault {
    [CmdletBinding()]
    param (
        [string] $VaultName,
        [hashtable] $AdditionalParameters
    )

    # return [TestStore]::TestVault()
    return $true
}