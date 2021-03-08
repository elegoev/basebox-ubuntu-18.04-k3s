# delete ubuntu log file
$LogFileName = '.\ubuntu-bionic-18.04-cloudimg-console.log'
if (Test-Path $LogFileName) {
  Remove-Item $LogFileName
}

# delete application file
$AppFileName = '.\installed-application.md'
if (Test-Path $AppFileName) {
  Remove-Item $AppFileName
}

# delete vagrant directory
$VagrantDirName = '.\.vagrant'
if (Test-Path $VagrantDirName) {
  Remove-Item $VagrantDirName -Recurse
}


