@echo off
title Octopus Intel Installer
echo ==============================================================
echo    OCTOPUS INTEL SURVEILLANCE DEFENSE ENGINE - SETUP
echo ==============================================================
echo.

set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%OctopusIntel_Setup_Light_v1.0.0.exe" (
    set "INSTALLER=%SCRIPT_DIR%OctopusIntel_Setup_Light_v1.0.0.exe"
    set "CERT=%SCRIPT_DIR%OctopusIntel_Certificate.cer"
) else (
    set "INSTALLER=%SCRIPT_DIR%TheftGuard-Rust\dist\OctopusIntel_Setup_Light_v1.0.0.exe"
    set "CERT=%SCRIPT_DIR%TheftGuard-Rust\dist\OctopusIntel_Certificate.cer"
)

if not exist "%INSTALLER%" (
    echo [ERROR] Could not find installer executable at:
    echo "%INSTALLER%"
    echo.
    echo Please ensure the repository was cloned completely.
    pause
    exit /b 1
)

echo [1/2] Unblocking installer from Windows SmartScreen restrictions...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%INSTALLER%' -ErrorAction SilentlyContinue; if (Test-Path '%CERT%') { Import-Certificate -FilePath '%CERT%' -CertStoreLocation 'Cert:\CurrentUser\TrustedPublisher' -ErrorAction SilentlyContinue | Out-Null }"

echo [2/2] Launching installation wizard...
echo.
start "" "%INSTALLER%"
