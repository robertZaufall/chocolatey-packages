$ErrorActionPreference = 'Stop';

$packageArgs = @{
	packageName    = 'wasmedge'
	url            = 'https://github.com/WasmEdge/WasmEdge/releases/download/0.14.1/WasmEdge-0.14.1-windows.msi'
	fileType       = 'msi'
	silentArgs     = '/quiet /norestart'
    checksum       = '698c7ed88f39b9ebeef5a235ae321677e11b68b5eb27e0d90e180cb9d13846c3'
    checksumType   = 'sha256'
	validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
