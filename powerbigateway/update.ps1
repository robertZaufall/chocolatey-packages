import-module chocolatey-au

$releases = 'https://www.microsoft.com/en-us/download/details.aspx?id=53127'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*checksum\s*=\s*)('.*')"= "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"= "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_GetLatest {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -WebSession $session `
      -Headers @{
      "authority"="www.microsoft.com"
      "method"="GET"
      "path"="/en-us/download/details.aspx?id=53127"
      "scheme"="https"
      "accept"="text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
      "accept-encoding"="gzip, deflate, br, zstd"
      "accept-language"="en-US,en-DE;q=0.9,en;q=0.8,de;q=0.7"
      "cache-control"="no-cache"
      "pragma"="no-cache"
      "upgrade-insecure-requests"="1"
    }
    $pattern = '(?<=<div style="width:fit-content"><h3 class="h6">Version:</h3><p style="overflow-wrap:break-word">)(.*?)(?=</p></div>)'
    $version = [regex]::Match($download_page.Content, $pattern).Groups[1].Value
    $download = 'https://download.microsoft.com/download/D/A/1/DA1FDDB8-6DA8-4F50-B4D0-18019591E182/GatewayInstall.exe'
    @{
       URL32   = $download
       Version = $version
    }
}

try {
    update -ChecksumFor 32
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
