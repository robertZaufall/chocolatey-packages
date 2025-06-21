$packageName    = 'jsonedit'
$url            = 'https://www.tomeko.net/software/JSONedit/bin/JSONedit_0_9_43.zip'
$validExitCodes = @(0)
$exeName        = "jsonedit.exe"
$checksum       = 'dd18e4209f99a9b0d803de4d4ea48829c4b9049446b6f29f9a097784d0d8ec2e'
$checksumType   = 'sha256'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" -checksum $checksum -checksumType $checksumType

$AppPathKey = "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exeName"
If (!(Test-Path $AppPathKey)) {New-Item "$AppPathKey" | Out-Null}
Set-ItemProperty -Path $AppPathKey -Name "(Default)" -Value "$env:chocolateyinstall\lib\$packagename\tools\$exeName"
Set-ItemProperty -Path $AppPathKey -Name "Path" -Value "$env:chocolateyinstall\lib\$packagename\tools\"
