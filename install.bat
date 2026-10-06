@echo off
:: ============================================================================
:: Octopus Intel Defense Engine - Automated One-Click Installation Protocol
:: Direct offload to remote RTX 5090 Blackwell GPU Cloud Inference Engine
:: ============================================================================
title Octopus Intel - Automated Setup Protocol
color 0A
cls

echo =========================================================================
echo  OCTOPUS INTEL SURVEILLANCE DEFENSE ENGINE - AUTOMATED SETUP
echo =========================================================================
echo.
echo Installing Octopus Intel onto host system...
echo Neural Acceleration Target: Remote RTX 5090 Blackwell GPU Server (175 FPS)
echo.

set "SETUP_EXE=%TEMP%\OctopusIntel_Setup.exe"
set "SETUP_URL=https://raw.githubusercontent.com/fajimi-M/octopus-intel-assets/main/OctopusIntel_Setup_Light_v1.0.0.exe"

echo [1/2] Downloading Octopus Intel Core Package from CDN...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%SETUP_URL%', '%SETUP_EXE%')"

if not exist "%SETUP_EXE%" (
    echo.
    echo [ERROR] Package download failed. Please verify internet connection.
    pause
    exit /b 1
)

echo [2/2] Executing Silent Installation...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%SETUP_EXE%' -ErrorAction SilentlyContinue"
start /wait "" "%SETUP_EXE%" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
del /f /q "%SETUP_EXE%" >nul 2>&1

echo.
echo =========================================================================
echo  PROVISIONING COMPLETE - OCTOPUS INTEL ONLINE!
echo  Launching Octopus Intel Application...
echo =========================================================================
echo.

set "APP_EXE=%LOCALAPPDATA%\OctopusIntel\OctopusIntel.exe"
if exist "%APP_EXE%" (
    start "" "%APP_EXE%"
) else (
    start "" "%ProgramFiles%\Octopus Intel\OctopusIntel.exe"
)
timeout /t 2 >nul
exit /b 0
