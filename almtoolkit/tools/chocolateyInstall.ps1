$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'almtoolkit'
	url            = 'https://github.com/microsoft/Analysis-Services/releases/download/5.1.7/AlmToolkitSetup.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = 'bc9f32dd7136912559790c5d64ef3a1c7d41b62302616166d2eaa2dae5bf5f94'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
