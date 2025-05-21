$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'powerbigateway'
	url            = 'https://download.microsoft.com/download/D/A/1/DA1FDDB8-6DA8-4F50-B4D0-18019591E182/GatewayInstall.exe'
	fileType       = 'exe'
	silentArgs     = '/install /quiet /norestart /log OnPremDataGateway-Install.log'
    checksum       = 'a10d0064dd3a9d68dbc8a7e9d8b3335ca530d14fcf1d579fcfd005ac3d19a989'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
