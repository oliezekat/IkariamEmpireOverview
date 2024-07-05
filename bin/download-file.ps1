# Download file

# Fetch CLI arguments
[CmdletBinding()]
param(
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$filepath
)
$url             = $url.Trim("'")
$filepath        = $filepath.Trim("'")

write-host -fore DarkBlue 'Connect a PowerShell WebClient...'
write-host -fore DarkGray (-join('Source: ', $url))
$WebClient = New-Object System.Net.WebClient
$WebClient.Headers['User-Agent'] = 'PowerShell WebClient'
$WebClient.DownloadFile($url, $filepath)
write-host -fore DarkGray (-join('Destination: ', $filepath))
write-host -fore DarkGreen 'Download completed.'
