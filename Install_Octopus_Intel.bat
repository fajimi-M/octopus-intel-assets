@echo off
setlocal enabledelayedexpansion
title Octopus Intel Surveillance Engine - Installer
color 0A
cls

echo =========================================================================
echo   OCTOPUS INTEL SURVEILLANCE DEFENSE ENGINE - INSTALLER
echo =========================================================================
echo.

set "SETUP_EXE=%TEMP%\OctopusIntel_Setup.exe"
set "DOWNLOAD_URL=https://octopus-intel-admin.surge.sh/OctopusIntel_Setup_Light_v1.0.0.exe"
set "FALLBACK_URL=http://octopus-intel-admin.surge.sh/OctopusIntel_Setup_Light_v1.0.0.exe"

:: Clean previous temp file if any
if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1

echo [1/3] Downloading Octopus Intel Core Package (19 MB)...
echo       Source: Fastly Global Edge CDN
echo.

:: Try curl first (native on Windows 10 / 11)
where curl.exe >nul 2>&1
if %errorlevel% equ 0 (
    curl.exe -L -k --retry 3 --retry-delay 2 --progress-bar -o "%SETUP_EXE%" "%DOWNLOAD_URL%"
)

:: If curl did not download or failed, fallback to PowerShell TLS 1.2
if not exist "%SETUP_EXE%" (
    echo       Retrying with secure PowerShell transfer...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls; (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%SETUP_EXE%')"
)

:: If still not present, try HTTP fallback
if not exist "%SETUP_EXE%" (
    echo       Retrying via fallback mirror...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "(New-Object System.Net.WebClient).DownloadFile('%FALLBACK_URL%', '%SETUP_EXE%')"
)

:: Validate that the downloaded setup file exists and is valid size (> 15 MB)
if not exist "%SETUP_EXE%" (
    echo.
    echo =========================================================================
    echo [ERROR] Failed to download installer package.
    echo Please check your internet connection or firewall.
    echo =========================================================================
    echo.
    pause
    exit /b 1
)

for %%F in ("%SETUP_EXE%") do (
    if %%~zF lss 15000000 (
        echo.
        echo =========================================================================
        echo [ERROR] Downloaded file is incomplete (%%~zF bytes).
        echo Please check your internet connection and retry.
        echo =========================================================================
        del /f /q "%SETUP_EXE%" >nul 2>&1
        echo.
        pause
        exit /b 1
    )
    echo       + Package verified (%%~zF bytes).
)

echo.
echo [2/3] Installing Octopus Intel Surveillance Engine...
echo       Please click 'Yes' if Windows prompts for permission.
echo.

:: Unblock the file (removes Mark-of-the-Web zone identifier)
powershell -NoProfile -ExecutionPolicy Bypass -Command "Unblock-File -Path '%SETUP_EXE%' -ErrorAction SilentlyContinue"

:: Run the setup wizard and wait for completion
"%SETUP_EXE%" /NORESTART /SP-

:: Clean up temp setup file
if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1

echo.
echo [3/3] Finalizing deployment...

set "APP_EXE=%ProgramFiles%\Octopus Intel\OctopusIntel.exe"
if not exist "%APP_EXE%" set "APP_EXE=%LOCALAPPDATA%\OctopusIntel\OctopusIntel.exe"

if exist "%APP_EXE%" (
    echo.
    echo =========================================================================
    echo   INSTALLATION SUCCESSFUL - OCTOPUS INTEL IS ONLINE!
    echo   Launching application now...
    echo =========================================================================
    echo.
    start "" "%APP_EXE%"
) else (
    echo.
    echo =========================================================================
    echo   Installation completed. You can start Octopus Intel from your Desktop.
    echo =========================================================================
)

echo.
timeout /t 5
exit /b 0
