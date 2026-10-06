$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'powerbigateway'
	url            = 'https://download.microsoft.com/download/D/A/1/DA1FDDB8-6DA8-4F50-B4D0-18019591E182/GatewayInstall.exe'
	fileType       = 'exe'
	silentArgs     = '/install /quiet /norestart /log OnPremDataGateway-Install.log'
    checksum       = '2f700c41d9d586d1053019104c57093e6683f4524e1a59f2bda0b456e25e996a'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
