import-module chocolatey-au
. $PSScriptRoot\..\_scripts\all.ps1

$repo        = 'sql-bi/Bravo'
$binaryRexp  = "Bravo.*\.x64\.msi"

$domain      = 'https://github.com'
$releases    = $domain + '/' + $repo + '/releases'
$assets      = $releases + '/expanded_assets'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"= "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"= "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksumType\s*=\s*)('.*')"= "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $re_tag = "/tree/([vV])?([0-9]+\.[0-9]+\.[0-9]+)$"
    $tag_link = $download_page.links | ? href -match $re_tag | select -First 1 -expand href
    $version = Split-Path $tag_link -Leaf

    $assets_page = Invoke-WebRequest -Uri ($assets + '/' + $version)

    $re  = $binaryRexp
    $url = $assets_page.links | ? href -match $re | select -First 1 -expand href
    $url = $domain + $url

    return @{
        URL32        = $url
        Version      = $version.Replace('v', '')
    }
}

update -ChecksumFor 32
