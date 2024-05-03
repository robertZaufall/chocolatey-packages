$ErrorActionPreference = 'Stop';

$url             = 'http://regis.cosnier.free.fr/soft/xsddiagram/XSDDiagram-2018-06-19-1.2-Binary.zip'
$destination     = Join-Path ${env:ProgramFiles(x86)} 'XSDDiagram'
$destinationExe  = Join-Path $destination 'XSDDiagram.exe'
$destinationLink = Join-Path 'C:\Users\Public\Desktop' 'XSDDiagram.lnk'
$checksum        = '01853eed9ba526e56457f0148f64e70d0628e09a953b5ea23f25532acb4e17a5'
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
