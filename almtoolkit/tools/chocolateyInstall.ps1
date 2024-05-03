$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'almtoolkit'
	url            = 'https://github.com/microsoft/Analysis-Services/releases/download/5.0.44/AlmToolkitSetup.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = 'd88d3fc68d10bca4bd005bed21e0006b95e5d23d5a394413b6d3618e65f92307'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
