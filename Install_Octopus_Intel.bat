@echo off
:: ============================================================================
:: Octopus Intel Defense Engine - Resilient Automated 1-Click Installer
:: Engineered with Global Multi-Mirror Fallbacks & Resilient TLS Connections
:: Compatible with All Remote Windows Laptops (Windows 10 / Windows 11)
:: ============================================================================
setlocal enabledelayedexpansion
title Octopus Intel - Automated Remote Setup Protocol
color 0A
cls

echo =========================================================================
echo  OCTOPUS INTEL SURVEILLANCE DEFENSE ENGINE - REMOTE INSTALLATION
echo =========================================================================
echo.
echo Initializing secure deployment onto host system...
echo Neural AI Target: Remote RTX 5090 Blackwell GPU Cloud (175 FPS)
echo.

:: Ensure destination temp directory
set "SETUP_EXE=%TEMP%\OctopusIntel_Setup.exe"
if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1

:: Mirror URLs (Multi-region CDN fallbacks for Nigeria / International ISPs)
set "MIRROR1=https://octopus-intel-admin.surge.sh/OctopusIntel_Setup_Light_v1.0.0.exe"
set "MIRROR2=https://github.com/fajimi-M/octopus-intel-assets/releases/download/v1.0.0/OctopusIntel_Setup_Light_v1.0.0.exe"
set "MIRROR3=https://raw.githubusercontent.com/fajimi-M/octopus-intel-assets/main/OctopusIntel_Setup_Light_v1.0.0.exe"

set "DOWNLOAD_SUCCESS=0"

:: -----------------------------------------------------------------------------
:: Mirror 1: High-Speed Global Edge CDN (Primary Fastly Node)
:: -----------------------------------------------------------------------------
echo [1/3] Downloading core package from Global Edge CDN (Mirror 1)...
where curl.exe >nul 2>&1
if %errorlevel% equ 0 (
    curl.exe -L -k --retry 4 --retry-delay 2 --retry-connrefused --progress-bar -o "%SETUP_EXE%" "%MIRROR1%"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls; try { Start-BitsTransfer -Source '%MIRROR1%' -Destination '%SETUP_EXE%' -ErrorAction Stop } catch { (New-Object System.Net.WebClient).DownloadFile('%MIRROR1%', '%SETUP_EXE%') }"
)

:: Validate file size (must be at least 15 MB)
if exist "%SETUP_EXE%" (
    for %%F in ("%SETUP_EXE%") do (
        if %%~zF gtr 15000000 (
            set "DOWNLOAD_SUCCESS=1"
            echo       + Mirror 1 download verified (%%~zF bytes).
        )
    )
)

:: -----------------------------------------------------------------------------
:: Mirror 2: GitHub Releases CDN Fallback
:: -----------------------------------------------------------------------------
if "!DOWNLOAD_SUCCESS!"=="0" (
    echo.
    echo [2/3] Mirror 1 interrupted. Switching to GitHub Releases CDN (Mirror 2)...
    if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1
    where curl.exe >nul 2>&1
    if !errorlevel! equ 0 (
        curl.exe -L -k --retry 4 --retry-delay 2 --retry-connrefused --progress-bar -o "%SETUP_EXE%" "%MIRROR2%"
    ) else (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls; try { Start-BitsTransfer -Source '%MIRROR2%' -Destination '%SETUP_EXE%' -ErrorAction Stop } catch { (New-Object System.Net.WebClient).DownloadFile('%MIRROR2%', '%SETUP_EXE%') }"
    )
    if exist "%SETUP_EXE%" (
        for %%F in ("%SETUP_EXE%") do (
            if %%~zF gtr 15000000 (
                set "DOWNLOAD_SUCCESS=1"
                echo       + Mirror 2 download verified (%%~zF bytes).
            )
        )
    )
)

:: -----------------------------------------------------------------------------
:: Mirror 3: GitHub Raw Fallback
:: -----------------------------------------------------------------------------
if "!DOWNLOAD_SUCCESS!"=="0" (
    echo.
    echo [3/3] Switching to Direct Secondary Archive (Mirror 3)...
    if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1
    where curl.exe >nul 2>&1
    if !errorlevel! equ 0 (
        curl.exe -L -k --retry 4 --retry-delay 2 --retry-connrefused --progress-bar -o "%SETUP_EXE%" "%MIRROR3%"
    ) else (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls; try { Start-BitsTransfer -Source '%MIRROR3%' -Destination '%SETUP_EXE%' -ErrorAction Stop } catch { (New-Object System.Net.WebClient).DownloadFile('%MIRROR3%', '%SETUP_EXE%') }"
    )
    if exist "%SETUP_EXE%" (
        for %%F in ("%SETUP_EXE%") do (
            if %%~zF gtr 15000000 (
                set "DOWNLOAD_SUCCESS=1"
                echo       + Mirror 3 download verified (%%~zF bytes).
            )
        )
    )
)

if "!DOWNLOAD_SUCCESS!"=="0" (
    echo.
    echo =========================================================================
    echo [ERROR] Package download was interrupted across all mirrors.
    echo Please verify laptop internet connection or disable restrictive proxy.
    echo You can also download the setup directly from:
    echo %MIRROR1%
    echo =========================================================================
    pause
    exit /b 1
)

:: -----------------------------------------------------------------------------
:: Execute Silent Installation
:: -----------------------------------------------------------------------------
echo.
echo Installing Octopus Intel Core Defense Engine...
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

ping -n 3 127.0.0.1 >nul
exit /b 0
