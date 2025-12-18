param(
    $Info,

    # Path to the markdown report created by the built-in Report plugin.
    [string] $Path = 'Update-AUPackages.md'
)

if (-not (Test-Path -LiteralPath $Path)) {
    Write-Warning "SanitizeReport: File not found: $Path"
    return
}

$original = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
$content = $original

# GitHub blocks insecure (http) images -> remove these placeholders.
$content = $content -replace '\[!\[\]\(http://transparent-favicon\.info/favicon\.ico\)\]\(#\)', ''

# Avoid broken image icons when a nuspec has no iconUrl (Report plugin emits: <img src="" .../>).
$emptyImgTag = @'
<img\s+src=(["'])(?:\s*)\1[^>]*?>
'@
$content = $content -replace $emptyImgTag, ''

if ($content -ne $original) {
    Set-Content -LiteralPath $Path -Value $content -Encoding UTF8 -ErrorAction Stop
    Write-Host "SanitizeReport: Cleaned $Path"
} else {
    Write-Host "SanitizeReport: No changes needed ($Path)"
}
