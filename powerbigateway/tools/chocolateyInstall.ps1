$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'powerbigateway'
	url            = 'https://download.microsoft.com/download/D/A/1/DA1FDDB8-6DA8-4F50-B4D0-18019591E182/GatewayInstall.exe'
	fileType       = 'exe'
	silentArgs     = '/install /quiet /norestart /log OnPremDataGateway-Install.log'
    checksum       = '983f617036042e9aba1d5b7b946e677a3a37e68f0f9a38142eeaa9ddc9f62157'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
