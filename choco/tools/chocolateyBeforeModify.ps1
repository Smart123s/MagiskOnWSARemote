$ErrorActionPreference = 'Stop';

taskkill /IM WsaClient.exe

Uninstall-ChocolateyZipPackage $env:ChocolateyPackageName "WSA*.zip"
