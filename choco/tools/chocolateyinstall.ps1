$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  UnzipLocation  = "$toolsDir"

  url64         = '{URL64}'
  checksum64    = '{SHA256CHECKSUM64}'

  checksumType  = 'sha256'

}

# Check Windows version (min: 22000)
if ( [Environment]::OSVersion.Version.Build -lt 22000) {
  Write-Host "  ** Windows 11 22000 or later is required." -ForeGround Red
  throw
}

Install-ChocolateyZipPackage @packageArgs

# Get the name of the extracted folder
$folderName = ls $toolsDir | ? name -match "WSA.*" | select -Last 1

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
