$ErrorActionPreference = 'Stop';

# Remove version 2207.40000.8.0
$oldDir = "$(Get-ToolsLocation)\WSA"
if (Test-Path $oldDir) {
    Remove-Item $oldDir -Recurse -Force
}

Uninstall-ChocolateyZipPackage $env:ChocolateyPackageName "WSA*.zip"
