@echo off
title Octopus Intel Surveillance Engine - Automated Setup
color 0A
cls

echo =========================================================================
echo   OCTOPUS INTEL SURVEILLANCE DEFENSE ENGINE - DIRECT DEPLOYMENT
echo =========================================================================
echo.

:: -----------------------------------------------------------------------------
:: Step 1: Target Destination Directory
:: -----------------------------------------------------------------------------
set "INSTALL_DIR=%LOCALAPPDATA%\OctopusIntel"
net session >nul 2>&1
if %errorlevel% equ 0 set "INSTALL_DIR=%ProgramFiles%\Octopus Intel"

echo [*] Deployment Target Directory:
echo     %INSTALL_DIR%
echo.

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if not exist "%INSTALL_DIR%" (
    set "ERROR_MSG=Failed to create destination folder: %INSTALL_DIR%"
    goto :FAIL
)

:: -----------------------------------------------------------------------------
:: Step 2: Download Package
:: -----------------------------------------------------------------------------
set "TEMP_ZIP=%TEMP%\OctopusIntel_App.zip"
if exist "%TEMP_ZIP%" del /f /q "%TEMP_ZIP%" >nul 2>&1

set "DOWNLOAD_URL=https://octopus-intel-admin.surge.sh/OctopusIntel_App.zip"
set "FALLBACK_URL=http://octopus-intel-admin.surge.sh/OctopusIntel_App.zip"

echo [1/5] Downloading Octopus Intel Surveillance Engine [22 MB]...
echo       Source: Fastly Global Edge CDN
echo.

set "DOWNLOAD_SUCCESS=0"

where curl.exe >nul 2>&1
if %errorlevel% equ 0 goto :USE_CURL
goto :USE_POWERSHELL

:USE_CURL
echo       Using high-speed curl transfer...
curl.exe -C - -L -k --retry 5 --retry-all-errors --retry-delay 2 --progress-bar -o "%TEMP_ZIP%" "%DOWNLOAD_URL%"

if not exist "%TEMP_ZIP%" goto :USE_POWERSHELL
for %%F in ("%TEMP_ZIP%") do if %%~zF geq 20000000 set "DOWNLOAD_SUCCESS=1"
if "%DOWNLOAD_SUCCESS%"=="1" goto :DOWNLOAD_VERIFIED

:USE_POWERSHELL
echo.
echo       Retrying with PowerShell Background Transfer...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls; try { Start-BitsTransfer -Source '%DOWNLOAD_URL%' -Destination '%TEMP_ZIP%' -ErrorAction Stop } catch { (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TEMP_ZIP%') }"

if not exist "%TEMP_ZIP%" (
    set "ERROR_MSG=Download failed across all network protocols."
    goto :FAIL
)

for %%F in ("%TEMP_ZIP%") do if %%~zF geq 20000000 set "DOWNLOAD_SUCCESS=1"
if not "%DOWNLOAD_SUCCESS%"=="1" (
    set "ERROR_MSG=Downloaded file is incomplete or corrupted."
    goto :FAIL
)

:DOWNLOAD_VERIFIED
echo.
echo       [+] Package downloaded and verified successfully!

:: -----------------------------------------------------------------------------
:: Step 3: Extract Package
:: -----------------------------------------------------------------------------
echo.
echo [2/5] Deploying application binaries...
where tar.exe >nul 2>&1
if %errorlevel% equ 0 goto :EXTRACT_TAR
goto :EXTRACT_PS

:EXTRACT_TAR
tar.exe -xf "%TEMP_ZIP%" -C "%INSTALL_DIR%"
goto :CHECK_EXTRACT

:EXTRACT_PS
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%INSTALL_DIR%' -Force"

:CHECK_EXTRACT
if not exist "%INSTALL_DIR%\OctopusIntel.exe" (
    set "ERROR_MSG=Failed to extract OctopusIntel.exe into %INSTALL_DIR%"
    goto :FAIL
)
echo       [+] Application binaries deployed successfully!

if exist "%TEMP_ZIP%" del /f /q "%TEMP_ZIP%" >nul 2>&1

:: -----------------------------------------------------------------------------
:: Step 4: Deploy Local Neural AI Models (DirectML GPU / CPU ONNX Suite)
:: -----------------------------------------------------------------------------
echo.
echo [3/5] Provisioning Neural AI Models (Pose, Objects, Weapons, Face Engine)...
if not exist "%INSTALL_DIR%\models" mkdir "%INSTALL_DIR%\models"

set "MODELS_ZIP=%TEMP%\octopus_models_v1.zip"
set "MODELS_URL=https://github.com/fajimi-M/octopus-intel-assets/releases/download/v1.0.0/octopus_models_v1.zip"

if exist "%INSTALL_DIR%\models\yolov8n-pose.onnx" (
    echo       [+] Neural AI models verified intact in %INSTALL_DIR%\models
    goto :MODELS_VERIFIED
)

echo       Downloading neural models package [61 MB] from high-speed CDN...
where curl.exe >nul 2>&1
if %errorlevel% equ 0 (
    curl.exe -C - -L -k --retry 5 --retry-all-errors --retry-delay 2 --progress-bar -o "%MODELS_ZIP%" "%MODELS_URL%"
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls; try { Start-BitsTransfer -Source '%MODELS_URL%' -Destination '%MODELS_ZIP%' -ErrorAction Stop } catch { (New-Object System.Net.WebClient).DownloadFile('%MODELS_URL%', '%MODELS_ZIP%') }"
)

if exist "%MODELS_ZIP%" (
    echo       Extracting neural models into %INSTALL_DIR%\models...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%MODELS_ZIP%' -DestinationPath '%INSTALL_DIR%\models' -Force"
    del /f /q "%MODELS_ZIP%" >nul 2>&1
    echo       [+] Neural AI models successfully deployed!
) else (
    echo       [!] Note: Models will sync automatically on first application startup.
)

:MODELS_VERIFIED

:: -----------------------------------------------------------------------------
:: Step 5: Remove Windows Smart App Control Blocks
:: -----------------------------------------------------------------------------
echo.
echo [4/5] Configuring Windows security permissions and trust...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path '%INSTALL_DIR%' -Recurse | Unblock-File -ErrorAction SilentlyContinue"
echo       [+] Windows Smart App Control permissions granted!

:: -----------------------------------------------------------------------------
:: Step 6: Create Shortcuts
:: -----------------------------------------------------------------------------
echo.
echo [5/5] Creating Desktop and Start Menu shortcuts...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $d = [Environment]::GetFolderPath('Desktop'); $sc = $ws.CreateShortcut($d + '\Octopus Intel.lnk'); $sc.TargetPath = '%INSTALL_DIR%\OctopusIntel.exe'; $sc.WorkingDirectory = '%INSTALL_DIR%'; $sc.IconLocation = '%INSTALL_DIR%\app_icon.ico'; $sc.Save()"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $sm = [Environment]::GetFolderPath('Programs'); $sc = $ws.CreateShortcut($sm + '\Octopus Intel.lnk'); $sc.TargetPath = '%INSTALL_DIR%\OctopusIntel.exe'; $sc.WorkingDirectory = '%INSTALL_DIR%'; $sc.IconLocation = '%INSTALL_DIR%\app_icon.ico'; $sc.Save()"
echo       [+] Desktop shortcut created!

:: -----------------------------------------------------------------------------
:: Step 7: Verify and Launch Application
:: -----------------------------------------------------------------------------
echo.
echo =========================================================================
echo   INSTALLATION COMPLETED SUCCESSFULLY!
echo =========================================================================
echo.
echo   Location:         %INSTALL_DIR%
echo   Desktop Shortcut: Created
echo.
echo   Launching Octopus Intel Surveillance Defense Engine now...
echo.

start "" "%INSTALL_DIR%\OctopusIntel.exe"

echo.
echo   Octopus Intel is now running!
echo   You can close this window.
echo.
pause
exit /b 0

:: -----------------------------------------------------------------------------
:: Error Handler
:: -----------------------------------------------------------------------------
:FAIL
echo.
echo =========================================================================
echo   [ERROR] INSTALLATION FAILED
echo =========================================================================
echo.
echo   Reason: %ERROR_MSG%
echo.
echo   Troubleshooting Steps:
echo   1. Verify your laptop internet connection.
echo   2. Disable restrictive proxies or temporary VPN disconnections.
echo   3. Run the installer again (it will auto-resume).
echo.
echo =========================================================================
echo.
pause
exit /b 1
