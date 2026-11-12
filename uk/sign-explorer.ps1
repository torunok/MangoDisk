# Signs the Explorer integration DLL and its identity package (identity.msix) with the throwaway build certificate.
# Upstream's release build refuses an unsigned Explorer package. MSIX needs signtool, and the package Publisher must
# equal the certificate subject (set through MANGODISK_EXPLORER_PUBLISHER). The certificate is trusted only on the
# build runner, so on a user's PC the optional Explorer menu cannot register and stays off; the app itself is unaffected.
param([Parameter(Mandatory)][string]$File)
$ErrorActionPreference = 'Stop'
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert |
    Where-Object Subject -eq 'CN=MangoDisk Ukrainian build' | Select-Object -First 1
if (-not $cert) { throw 'Build certificate not found' }
$signtool = Get-ChildItem "${env:ProgramFiles(x86)}\Windows Kits\10\bin\*\x64\signtool.exe" |
    Sort-Object FullName -Descending | Select-Object -First 1
if (-not $signtool) { throw 'signtool.exe not found' }
& $signtool.FullName sign /fd SHA256 /sha1 $cert.Thumbprint /s My $File
if ($LASTEXITCODE -ne 0) { throw "Signing failed: $File" }
