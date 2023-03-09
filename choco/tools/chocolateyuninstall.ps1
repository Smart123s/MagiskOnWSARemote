$ErrorActionPreference = 'Stop';

$AppxPackage = Get-AppxPackage -Name 'MicrosoftCorporationII.WindowsSubsystemForAndroid'
Remove-AppxPackage -Package $AppxPackage.PackageFullName
