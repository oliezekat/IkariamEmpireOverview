# Download file

# Fetch CLI arguments
[CmdletBinding()]
param(
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$filepath,
        [string]$caption
)
$url             = $url.Trim("'")
$filepath        = $filepath.Trim("'")
$caption         = $caption.Trim("'")
$caption         = $caption.Trim()
if ($caption.Length -eq 0)
        {
        $caption = $filepath.Split("\")[-1]
        }
write-verbose (-join('Source: ', $url))
write-verbose (-join('Destination: ', $filepath))
write-host -fore DarkBlue (-join('Downloading "', $caption, '"... ')) -NoNewline
$WebClient = New-Object System.Net.WebClient
$WebClient.Headers['User-Agent'] = 'PowerShell WebClient'
$WebClient.DownloadFile($url, $filepath)
write-host -fore DarkGreen 'Completed.'
