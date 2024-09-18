$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'powerbigateway'
	url            = 'https://download.microsoft.com/download/D/A/1/DA1FDDB8-6DA8-4F50-B4D0-18019591E182/GatewayInstall.exe'
	fileType       = 'exe'
	silentArgs     = '/install /quiet /norestart /log OnPremDataGateway-Install.log'
    checksum       = '79769ff18ea7428e81614e62f0583df07053e909b4bd14950a6b052b076424a8'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
