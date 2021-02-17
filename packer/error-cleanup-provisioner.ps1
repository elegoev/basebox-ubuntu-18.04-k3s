# cleanup task

# delete ubuntu log file
Push-Location
Set-Location "./packer_build_dir"
if($?) {
  vagrant destroy -f
}
Pop-Location

# call cleanup
Invoke-Expression "$PSScriptRoot\post-processors\cleanup.ps1"

# write error box
Write-Host "############################" -ForegroundColor Red
Write-Host " Baseimage build failed     " -ForegroundColor Red
Write-Host "############################" -ForegroundColor Red
