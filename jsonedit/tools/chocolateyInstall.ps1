$packageName    = 'jsonedit'
$url            = 'https://www.tomeko.net/software/JSONedit/bin/JSONedit_0_9_45.zip'
$validExitCodes = @(0)
$exeName        = "jsonedit.exe"
$checksum       = '31f88793f98fe72a5979b2a27e983366b3c18ae0a3ed00a47aaabc4e70705ef0'
$checksumType   = 'sha256'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" -checksum $checksum -checksumType $checksumType

$AppPathKey = "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exeName"
If (!(Test-Path $AppPathKey)) {New-Item "$AppPathKey" | Out-Null}
Set-ItemProperty -Path $AppPathKey -Name "(Default)" -Value "$env:chocolateyinstall\lib\$packagename\tools\$exeName"
Set-ItemProperty -Path $AppPathKey -Name "Path" -Value "$env:chocolateyinstall\lib\$packagename\tools\"
