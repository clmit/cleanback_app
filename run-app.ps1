# CleanBack App - Check and Run Script
# Run in regular PowerShell (not as admin)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CleanBack App - Check and Run" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Go to project folder
$projectPath = "C:\Users\Митя\Documents\Projects\clb-app"
Set-Location $projectPath
Write-Host "Project path: $projectPath" -ForegroundColor Gray
Write-Host ""

# Step 1: Check Flutter
Write-Host "[1/5] Checking Flutter..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "OK - $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR - Flutter not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Run installation first:" -ForegroundColor Yellow
    Write-Host "1. Open PowerShell as Administrator" -ForegroundColor White
    Write-Host "2. Run: .\install-flutter.ps1" -ForegroundColor Cyan
    exit 1
}

# Step 2: Check dependencies
Write-Host ""
Write-Host "[2/5] Checking dependencies..." -ForegroundColor Yellow

if (Test-Path "pubspec.yaml") {
    Write-Host "OK - pubspec.yaml found" -ForegroundColor Green
} else {
    Write-Host "ERROR - pubspec.yaml not found!" -ForegroundColor Red
    exit 1
}

# Check if dependencies are installed
if (Test-Path ".dart_tool") {
    Write-Host "OK - Dependencies installed" -ForegroundColor Green
} else {
    Write-Host "WARNING - Installing dependencies..." -ForegroundColor Yellow
    flutter pub get
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK - Dependencies installed" -ForegroundColor Green
    } else {
        Write-Host "ERROR - Failed to install dependencies" -ForegroundColor Red
        exit 1
    }
}

# Step 3: Check connected devices
Write-Host ""
Write-Host "[3/5] Checking devices..." -ForegroundColor Yellow

$devices = flutter devices 2>&1
Write-Host "$devices" -ForegroundColor Gray

$deviceList = flutter devices 2>&1 | Select-String -Pattern "^\s+\d+" 

if ($deviceList) {
    Write-Host "OK - Found devices:" -ForegroundColor Green
    foreach ($device in $deviceList) {
        Write-Host "  $device" -ForegroundColor Gray
    }
} else {
    Write-Host "WARNING - No connected devices" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Available options:" -ForegroundColor Cyan
    Write-Host "  - Chrome (web version)" -ForegroundColor White
    Write-Host "  - Windows (desktop)" -ForegroundColor White
    Write-Host "  - Android emulator" -ForegroundColor White
}

# Step 4: Choose device
Write-Host ""
Write-Host "[4/5] Select device to run:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1 - Chrome (quick browser test)" -ForegroundColor White
Write-Host "  2 - Windows (desktop app)" -ForegroundColor White
Write-Host "  3 - Android (emulator/device)" -ForegroundColor White
Write-Host "  4 - Run doctor (diagnostics)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter number (1-4)"

Write-Host ""
Write-Host "[5/5] Starting app..." -ForegroundColor Yellow
Write-Host ""

switch ($choice) {
    "1" {
        Write-Host "Launching in Chrome..." -ForegroundColor Gray
        flutter run -d chrome
    }
    "2" {
        Write-Host "Launching for Windows..." -ForegroundColor Gray
        flutter run -d windows
    }
    "3" {
        Write-Host "Launching on Android..." -ForegroundColor Gray
        flutter run
    }
    "4" {
        Write-Host "Running diagnostics..." -ForegroundColor Gray
        flutter doctor -v
    }
    default {
        Write-Host "Invalid choice" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Done!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
