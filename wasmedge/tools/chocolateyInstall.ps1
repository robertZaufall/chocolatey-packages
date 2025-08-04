$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'wasmedge'
	url            = 'https://github.com/WasmEdge/WasmEdge/releases/download/0.15.0/WasmEdge-0.15.0-windows.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = 'f7a76f8dc5f940a818358fe1b6b6b3b1ed4d07475cfb79d3f8d2c343dcb98b25'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
