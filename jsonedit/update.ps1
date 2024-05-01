import-module chocolatey-au

$domain = 'https://www.tomeko.net/software/JSONedit'
$releases = "$domain/index.php?lang=en"

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]url\s*=\s*)('.*')"= "`$1'$($Latest.URL32)'"
            "(?i)(^\s*[$]checksum\s*=\s*)('.*')"= "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*[$]checksumType\s*=\s*)('.*')"= "`$1'$($Latest.ChecksumType32)'"
        }
        ".\tools\chocolateyUninstall.ps1" = @{
            'JSONedit_\d+_\d+_\d+\.zip' = "$($Latest.Binary)"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re  = 'JSONedit_[0-9]+_[0-9]+_[0-9]+\.zip'
    $url = $download_page.links | ? href -match $re | select -Last 1 -expand href
    $binary = Split-Path $url -Leaf
    $version = ($url -split '_|\.')[1..3] -join '.'
    @{
       URL32   = "$domain/$url"
       Version = $version
       Binary  = $binary
    }
}

try {
    update -ChecksumFor 32
} catch {
    $ignore = 'Unable to connect to the remote server'
    if ($_ -match $ignore) { Write-Host $ignore; 'ignore' }  else { throw $_ }
}
