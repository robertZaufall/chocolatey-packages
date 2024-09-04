$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'almtoolkit'
	url            = 'https://github.com/microsoft/Analysis-Services/releases/download/5.1.3/AlmToolkitSetup.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = 'e3ce8caea3ff1288d8aa5d8f73108464a4891c9d2ade539a56b53c8dfe7df95d'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
