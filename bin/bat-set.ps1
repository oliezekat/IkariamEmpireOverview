# Set parameter into BAT file

# Fetch CLI arguments
[CmdletBinding()]
param(
        [Parameter(Mandatory)]
        [string]$filepath,
        [Parameter(Mandatory)]
        [string]$name,
        [Parameter(Mandatory)]
        [string]$value
)
$filepath        = $filepath.Trim("'")
$name            = $name.Trim("'")
$value           = $value.Trim("'")

# Uncomment parameter
(Get-Content $filepath) | ForEach-Object { $_ -replace -join('rem.*set.*', $name, '.*='), -join('set ', $name, '=') } | Set-Content $filepath 
# Set parameter value
(Get-Content $filepath) | ForEach-Object { $_ -replace -join('set.*', $name, '.*=.*'),-join('set ', $name, '=', $value) } | Set-Content $filepath 

