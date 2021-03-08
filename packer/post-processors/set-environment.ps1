# environment task

# creaze
$EnvFileName = '.\set-build-env.ps1'
if (Test-Path $EnvFileName) {
  Remove-Item $EnvFileName
}

Set-Content $EnvFileName `
"
`$env:SRC_IMAGE_NAME = 'elegoev/$env:IMAGE_NAME'
`$env:SRC_IMAGE_VERSION = '$env:IMAGE_VERSION'
"
