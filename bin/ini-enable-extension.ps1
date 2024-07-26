# Enable extension into INI file

# Fetch CLI arguments
[CmdletBinding()]
param(
        [Parameter(Mandatory)]
        [string]$filepath,
        [Parameter(Mandatory)]
        [string]$name
)
$filepath        = $filepath.Trim("'")
$name            = $name.Trim("'")

# Uncomment extension
(Get-Content $filepath) | ForEach-Object { $_ -replace -join(';.*extension.*=.*', $name), -join('extension=', $name) } | Set-Content $filepath 


