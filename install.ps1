# Octopus Intel 1-Click Automated Installer Launcher
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host "   OCTOPUS INTEL SURVEILLANCE DEFENSE ENGINE - SETUP" -ForegroundColor Yellow
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host ""

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallerPath = Join-Path $ScriptDir "OctopusIntel_Setup_Light_v1.0.0.exe"
$CertPath = Join-Path $ScriptDir "OctopusIntel_Certificate.cer"
if (-not (Test-Path $InstallerPath)) {
    $InstallerPath = Join-Path $ScriptDir "TheftGuard-Rust\dist\OctopusIntel_Setup_Light_v1.0.0.exe"
    $CertPath = Join-Path $ScriptDir "TheftGuard-Rust\dist\OctopusIntel_Certificate.cer"
}

if (-not (Test-Path $InstallerPath)) {
    Write-Host "[ERROR] Could not find installer at: $InstallerPath" -ForegroundColor Red
    Pause
    exit 1
}

# 1. Unblock the file (Strips Windows Zone.Identifier / Mark-of-the-Web to prevent SmartScreen blocking)
Write-Host "[1/2] Unblocking installer from Windows SmartScreen restrictions..." -ForegroundColor Cyan
Unblock-File -Path $InstallerPath -ErrorAction SilentlyContinue

# 2. Register digital publisher certificate to Trusted Publishers store
if (Test-Path $CertPath) {
    try {
        Import-Certificate -FilePath $CertPath -CertStoreLocation "Cert:\CurrentUser\Root" -ErrorAction SilentlyContinue | Out-Null
        Import-Certificate -FilePath $CertPath -CertStoreLocation "Cert:\CurrentUser\TrustedPublisher" -ErrorAction SilentlyContinue | Out-Null
        Write-Host "[2/2] Digital publisher certificate registered." -ForegroundColor Green
    } catch {
        # Non-critical, continue
    }
}

Write-Host "`n[OK] Launching installation wizard..." -ForegroundColor Green
Start-Process -FilePath $InstallerPath
