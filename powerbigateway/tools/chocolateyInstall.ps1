$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'powerbigateway'
	url            = 'https://download.microsoft.com/download/D/A/1/DA1FDDB8-6DA8-4F50-B4D0-18019591E182/GatewayInstall.exe'
	fileType       = 'exe'
	silentArgs     = '/install /quiet /norestart /log OnPremDataGateway-Install.log'
    checksum       = '020b0eaf65b8cc023106186fcb290490f65f5b2b6863a56fe81e50ed3b2785a3'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
