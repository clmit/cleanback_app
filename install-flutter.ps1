# Flutter Installation Script for Windows
# Run as Administrator in PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Flutter SDK Installation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check admin rights
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Error: Run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click file -> Run as Administrator" -ForegroundColor Yellow
    exit 1
}

# Step 1: Create folder
Write-Host "[1/6] Creating folder C:\src..." -ForegroundColor Yellow
$flutterPath = "C:\src\flutter"
if (Test-Path $flutterPath) {
    Write-Host "Folder exists, skipping..." -ForegroundColor Gray
} else {
    New-Item -ItemType Directory -Force -Path "C:\src" | Out-Null
    Write-Host "OK - Folder created" -ForegroundColor Green
}

# Step 2: Check Git
Write-Host ""
Write-Host "[2/6] Checking Git..." -ForegroundColor Yellow
try {
    $gitVersion = git --version 2>$null
    if ($gitVersion) {
        Write-Host "OK - Git installed: $gitVersion" -ForegroundColor Green
    } else {
        throw "Git not found"
    }
} catch {
    Write-Host "Git not found! Install from:" -ForegroundColor Red
    Write-Host "https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Continue without Git? (will download ZIP)" -ForegroundColor Yellow
    $continue = Read-Host "y/n"
    if ($continue -ne "y") { exit 1 }
}

# Step 3: Install Flutter
Write-Host ""
Write-Host "[3/6] Installing Flutter SDK..." -ForegroundColor Yellow

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "Cloning Flutter repository (this will take time)..." -ForegroundColor Gray
    
    if (Test-Path "$flutterPath\.git") {
        Write-Host "Flutter already cloned, updating..." -ForegroundColor Gray
        Set-Location $flutterPath
        git pull
        Set-Location -
    } else {
        git clone https://github.com/flutter/flutter.git -b stable $flutterPath --depth 1
    }
    Write-Host "OK - Flutter installed via Git" -ForegroundColor Green
} else {
    Write-Host "Downloading Flutter ZIP..." -ForegroundColor Gray
    $url = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip"
    $zipPath = "C:\src\flutter.zip"
    
    Write-Host "Downloading from: $url" -ForegroundColor Gray
    Invoke-WebRequest -Uri $url -OutFile $zipPath
    
    Write-Host "Extracting..." -ForegroundColor Gray
    if (Test-Path $flutterPath) { Remove-Item $flutterPath -Recurse -Force }
    Expand-Archive -Path $zipPath -DestinationPath "C:\src" -Force
    Remove-Item $zipPath -Force
    
    Write-Host "OK - Flutter installed from ZIP" -ForegroundColor Green
}

# Step 4: Add to PATH
Write-Host ""
Write-Host "[4/6] Adding Flutter to PATH..." -ForegroundColor Yellow

$oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if ($oldPath -notlike "*C:\src\flutter\bin*") {
    $newPath = "$oldPath;C:\src\flutter\bin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host "OK - PATH updated" -ForegroundColor Green
} else {
    Write-Host "OK - Flutter already in PATH" -ForegroundColor Green
}

# Update PATH for current session
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine")

# Step 5: Verify installation
Write-Host ""
Write-Host "[5/6] Verifying Flutter..." -ForegroundColor Yellow

try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "$flutterVersion" -ForegroundColor Gray
    Write-Host "OK - Flutter is working" -ForegroundColor Green
} catch {
    Write-Host "Warning - Restart terminal to use flutter" -ForegroundColor Yellow
}

# Step 6: Run doctor
Write-Host ""
Write-Host "[6/6] Running flutter doctor..." -ForegroundColor Yellow
Write-Host "(This may take a few minutes on first run)" -ForegroundColor Gray
Write-Host ""

flutter doctor -v

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Install Android Studio:" -ForegroundColor White
Write-Host "   https://developer.android.com/studio" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. After Android Studio installation, run:" -ForegroundColor White
Write-Host "   flutter doctor --android-licenses" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Go to project folder:" -ForegroundColor White
Write-Host "   cd C:\Users\Митя\Documents\Projects\clb-app" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Install dependencies:" -ForegroundColor White
Write-Host "   flutter pub get" -ForegroundColor Cyan
Write-Host ""
Write-Host "5. Run the app:" -ForegroundColor White
Write-Host "   flutter run" -ForegroundColor Cyan
Write-Host ""
Write-Host "OR for quick browser test:" -ForegroundColor Yellow
Write-Host "   flutter run -d chrome" -ForegroundColor Cyan
Write-Host ""
