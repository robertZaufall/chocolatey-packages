$ErrorActionPreference = 'Stop';

$url             = 'https://github.com/fcarver/xsemmel/releases/download/Release_09-APR-2017/xsemmel-portable_2017-04-09.zip'
$destination     = Join-Path ${env:ProgramFiles(x86)} 'Xsemmel'
$destinationExe  = Join-Path $destination 'Xsemmel.exe'
$destinationLink = Join-Path 'C:\Users\Public\Desktop' 'Xsemmel.lnk'
$checksum        = 'eae10cf91c694291b2136f950694c9a847bddb5e1dcdc40122a4ae896ea3e52f'
$checksumType    = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $destination
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

Install-ChocolateyShortcut -ShortcutFilePath $destinationLink -TargetPath $destinationExe
