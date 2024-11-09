@echo off
setlocal EnableDelayedExpansion

:: Setup logging
echo Starting Office installation at %date% %time% > C:\office.log
echo ============================================ >> C:\office.log

:: Create temp directory for downloads
echo Creating temporary directory... >> C:\office.log
mkdir "%temp%\OfficeInstall" 2>> C:\office.log
cd /d "%temp%\OfficeInstall"

:: Download Office Deployment Tool
echo Downloading Office Deployment Tool... >> C:\office.log
curl -L -o "ODT.exe" "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_18129-20030.exe" 2>> C:\office.log

:: Extract ODT
echo Extracting Office Deployment Tool... >> C:\office.log
ODT.exe /quiet /extract:"%temp%\OfficeInstall" 2>> C:\office.log

:: Create configuration XML
echo Creating configuration file...
(
echo ^<?xml version="1.0" encoding="UTF-8"?^>
echo ^<Configuration ID="d50e2563-811a-4f2e-8422-4c36520d34d5"^>
echo   ^<Add OfficeClientEdition="64" Channel="PerpetualVL2019"^>
echo     ^<Product ID="ProPlus2019Volume" PIDKEY="NMMKJ-6RK4F-KMJVX-8D9MJ-6MWKP"^>
echo       ^<Language ID="en-us" /^>
echo       ^<ExcludeApp ID="Groove" /^>
echo       ^<ExcludeApp ID="Lync" /^>
echo     ^</Product^>
echo   ^</Add^>
echo   ^<Property Name="SharedComputerLicensing" Value="0" /^>
echo   ^<Property Name="FORCEAPPSHUTDOWN" Value="FALSE" /^>
echo   ^<Property Name="DeviceBasedLicensing" Value="0" /^>
echo   ^<Property Name="SCLCacheOverride" Value="0" /^>
echo   ^<Property Name="AUTOACTIVATE" Value="1" /^>
echo   ^<Updates Enabled="TRUE" /^>
echo   ^<RemoveMSI /^>
echo   ^<Display Level="Full" AcceptEULA="TRUE" /^>
echo ^</Configuration^>
) > "configuration.xml"

:: Download and install Office
echo Installing Microsoft Office (this may take a while)... >> C:\office.log
setup.exe /configure configuration.xml >> C:\office.log 2>&1

:: Clean up
echo Cleaning up temporary files... >> C:\office.log
cd /d "%~dp0"
rmdir /s /q "%temp%\OfficeInstall" 2>> C:\office.log

echo Installation complete! >> C:\office.log
echo ============================================ >> C:\office.log
