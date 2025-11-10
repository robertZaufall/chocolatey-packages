$packageName    = 'jsonedit'
$url            = 'https://www.tomeko.net/software/JSONedit/bin/JSONedit_0_9_44.zip'
$validExitCodes = @(0)
$exeName        = "jsonedit.exe"
$checksum       = '5c8ebdd9c09e8ec34bf8bfe7af989bf7aa3b3c19deebe4671b88113039a986e2'
$checksumType   = 'sha256'

Install-ChocolateyZipPackage "$packageName" "$url" "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" -checksum $checksum -checksumType $checksumType

$AppPathKey = "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exeName"
If (!(Test-Path $AppPathKey)) {New-Item "$AppPathKey" | Out-Null}
Set-ItemProperty -Path $AppPathKey -Name "(Default)" -Value "$env:chocolateyinstall\lib\$packagename\tools\$exeName"
Set-ItemProperty -Path $AppPathKey -Name "Path" -Value "$env:chocolateyinstall\lib\$packagename\tools\"
