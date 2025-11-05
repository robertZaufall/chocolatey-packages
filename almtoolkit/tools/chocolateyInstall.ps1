$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'almtoolkit'
	url            = 'https://github.com/microsoft/Analysis-Services/releases/download/5.1.20/AlmToolkitSetup.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = '26b6dbaf21eb168ec912eccf123bcb75b73e9bf38b25bec796f65a66715aea20'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
