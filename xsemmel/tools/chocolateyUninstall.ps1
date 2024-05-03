$destination     = Join-Path ${env:ProgramFiles(x86)} 'Xsemmel'
$destinationLink = Join-Path 'C:\Users\Public\Desktop' 'Xsemmel.lnk'

If (Test-Path $destinationLink){
	Remove-Item $destinationLink -Force -Confirm:$false
}

If (Test-Path $destination){
	Remove-Item $destination -Recurse -Force -Confirm:$false
}
