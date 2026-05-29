$packageName    = 'jsonedit'
$url            = 'https://www.tomeko.net/software/JSONedit/bin/JSONedit_0_9_44_1.zip'
$validExitCodes = @(0)
$exeName        = "jsonedit.exe"
$checksum       = 'b03e08bc4130e77fc8125caf11a65995e772a160a5d29867d477e89d1684746c'
$checksumType   = 'sha256'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" -checksum $checksum -checksumType $checksumType

$AppPathKey = "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exeName"
If (!(Test-Path $AppPathKey)) {New-Item "$AppPathKey" | Out-Null}
Set-ItemProperty -Path $AppPathKey -Name "(Default)" -Value "$env:chocolateyinstall\lib\$packagename\tools\$exeName"
Set-ItemProperty -Path $AppPathKey -Name "Path" -Value "$env:chocolateyinstall\lib\$packagename\tools\"
