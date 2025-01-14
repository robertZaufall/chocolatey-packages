$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'almtoolkit'
	url            = 'https://github.com/microsoft/Analysis-Services/releases/download/5.1.11/AlmToolkitSetup.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = '04369338cb89fa621f99c867541f6e4738c86e2afa54b50e5ef631003b02c657'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
