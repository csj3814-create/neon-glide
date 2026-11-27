param(
  [string]$KeystorePath = 'C:\Users\user\NeonGlide-PlayStore-KEYS\package\signing.keystore',
  [string]$Alias = 'my-key-alias'
)

$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot

# Gradle reads the project from the CURRENT directory, not from where this
# script lives, so running it from the repository root failed with
# "does not contain a Gradle build". Work from the wrapper directory and put
# the caller back where they started.
Push-Location -LiteralPath $projectRoot
try {

if (-not (Test-Path -LiteralPath $KeystorePath -PathType Leaf)) {
  throw "Upload keystore not found: $KeystorePath"
}

& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'verify-target-sdk.ps1')
if ($LASTEXITCODE -ne 0) {
  throw 'SDK configuration check failed.'
}

$jarsigner = Get-Command jarsigner -ErrorAction Stop
$gradle = Join-Path $projectRoot 'gradlew.bat'
$unsignedBundle = Join-Path $projectRoot 'app\build\outputs\bundle\release\app-release.aab'
$signedBundle = Join-Path $projectRoot 'app\build\outputs\bundle\release\neon-glide-signed.aab'

& $gradle bundleRelease
if ($LASTEXITCODE -ne 0) {
  throw "Gradle failed with exit code $LASTEXITCODE."
}

if (-not (Test-Path -LiteralPath $unsignedBundle -PathType Leaf)) {
  throw "Unsigned release bundle was not created: $unsignedBundle"
}

Copy-Item -LiteralPath $unsignedBundle -Destination $signedBundle -Force

Write-Output 'Jarsigner will ask for the upload-keystore password. The password is not saved by this script.'
& $jarsigner.Source `
  -keystore $KeystorePath `
  -sigalg SHA256withRSA `
  -digestalg SHA-256 `
  $signedBundle `
  $Alias

if ($LASTEXITCODE -ne 0) {
  throw "jarsigner failed with exit code $LASTEXITCODE."
}

& $jarsigner.Source -verify $signedBundle
if ($LASTEXITCODE -ne 0) {
  throw "Signed bundle verification failed with exit code $LASTEXITCODE."
}

Write-Output "signed-aab: $signedBundle"

}
finally {
  Pop-Location
}
