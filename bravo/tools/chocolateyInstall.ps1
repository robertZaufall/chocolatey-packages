$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'bravo'
	url            = 'https://github.com/sql-bi/Bravo/releases/download/v1.0.9/Bravo.1.0.9.x64.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = '712fcdcb4999d17cd8c18149181aa2de423f1cc377b7f221cfeb6a03a34f5ee0'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
