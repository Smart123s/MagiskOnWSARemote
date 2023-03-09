$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  UnzipLocation  = "$toolsDir"

  url64         = 'https://github.com/Smart123s/MagiskOnWSARemote/releases/download/WSA-2301.40000.4.0/WSA_2301.40000.4.0_x64_Release-Nightly-with-magisk-25.2.25200.-stable-MindTheGapps-13.0-RemovedAmazon.zip'
  checksum64    = 'b891ba1fe1041f2346f15ea066d65482b857a224465c937caea456246b951db2'

  checksumType  = 'sha256'

}

# Check Windows version (min: 22000)
if ( [Environment]::OSVersion.Version.Build -lt 22000) {
  Write-Host "  ** Windows 11 22000 or later is required." -ForeGround Red
  throw
}

Install-ChocolateyZipPackage @packageArgs

# Get the name of the extracted folder
$folderName = 'WSA_2301.40000.4.0_x64_Release-Nightly-with-magisk-25.2(25200)-stable-MindTheGapps-13.0-RemovedAmazon'

# Get name of install script
$installScript = Join-Path "$toolsDir\$folderName" "Install.ps1"

# Make installer silent
(Get-Content $installScript).Replace('$null = $Host.UI.RawUI.ReadKey' + "('NoEcho,IncludeKeyDown')", '') `
  -Replace 'Start-Process "wsa://com.topjohnwu.magisk"', '' `
  -Replace 'Start-Process "wsa://com.android.vending"', '' `
  -Replace 'Clear-Host', '' | Set-Content $installScript

# Execute install script
cd "$toolsDir\$folderName" 
./Install.ps1
