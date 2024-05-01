$packageName    = 'jsonedit'
$url            = 'https://www.tomeko.net/software/JSONedit/bin/JSONedit_0_9_42.zip'
$validExitCodes = @(0)
$exeName        = "jsonedit.exe"
$checksum       = '8c46682def02bab0e8946e48bda9dc26476ef6382da2ea37f32010f03fd8cc1f'
$checksumType   = 'sha256'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" -checksum $checksum -checksumType $checksumType

$AppPathKey = "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exeName"
If (!(Test-Path $AppPathKey)) {New-Item "$AppPathKey" | Out-Null}
Set-ItemProperty -Path $AppPathKey -Name "(Default)" -Value "$env:chocolateyinstall\lib\$packagename\tools\$exeName"
Set-ItemProperty -Path $AppPathKey -Name "Path" -Value "$env:chocolateyinstall\lib\$packagename\tools\"
