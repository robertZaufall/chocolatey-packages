$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'wasmedge'
	url            = 'https://github.com/WasmEdge/WasmEdge/releases/download/0.14.0/WasmEdge-0.14.0-windows.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = '9f8805330e62ba2757aa147ba890d1e5f13a584324abb80c48099802df7aed06'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
