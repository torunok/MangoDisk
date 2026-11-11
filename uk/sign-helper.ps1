# Signs the optional privileged helper with the throwaway certificate created for one CI run.
# Upstream's release build refuses an unsigned helper. This certificate is trusted only on the build runner, so on a
# user's PC the helper stays untrusted and the optional CPU temperature service fails closed, as upstream designed.
param([Parameter(Mandatory)][string]$File)
$ErrorActionPreference = 'Stop'
$cert = Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert |
    Where-Object Subject -eq 'CN=MangoDisk Ukrainian build' | Select-Object -First 1
if (-not $cert) { throw 'Build certificate not found' }
$result = Set-AuthenticodeSignature -LiteralPath $File -Certificate $cert -HashAlgorithm SHA256
if ($result.Status -ne 'Valid') { throw "Signing failed: $($result.StatusMessage)" }
