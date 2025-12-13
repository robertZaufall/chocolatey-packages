$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'bravo'
	url            = 'https://github.com/sql-bi/Bravo/releases/download/v1.0.12/Bravo.1.0.12.x64.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = 'f65f82265c132e52ab99e954a7d9566e9fe6a6fdfb8b3e16d44d55de5e2787aa'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
