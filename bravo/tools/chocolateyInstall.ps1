$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'bravo'
	url            = 'https://github.com/sql-bi/Bravo/releases/download/v1.0.11/Bravo.1.0.11.x64.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = '5278fdba08d8ebe48b5914ed7f377a4be8567152b002ee2a624a682bfb33ad5f'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
