# Setup FRA371 Kinematics Workshop Lab2 for Windows (PowerShell)
$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Setting up FRA371 Kinematics Workshop Lab2" -ForegroundColor Cyan
Write-Host " (Windows PowerShell)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check for Python
$pythonCmd = $null
if (Get-Command py -ErrorAction SilentlyContinue) {
    $pythonCmd = "py"
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonCmd = "python"
} else {
    Write-Host "[ERROR] Python was not found in PATH. Please install Python 3.10-3.12." -ForegroundColor Red
    exit 1
}

# Create .venv if it doesn't exist
if (-not (Test-Path -Path ".venv")) {
    Write-Host "[INFO] Creating virtual environment (.venv)..." -ForegroundColor Yellow
    & $pythonCmd -m venv .venv
} else {
    Write-Host "[INFO] Existing .venv found." -ForegroundColor Yellow
}

# Python executable inside .venv
$venvPython = Join-Path (Get-Location) ".venv\Scripts\python.exe"

# Upgrade pip
Write-Host "[INFO] Upgrading pip..." -ForegroundColor Yellow
& $venvPython -m pip install --upgrade pip

# Install dependencies
Write-Host "[INFO] Installing dependencies from requirements.txt..." -ForegroundColor Yellow
& $venvPython -m pip install -r requirements.txt

# Run fix_swift.py
Write-Host "[INFO] Running fix_swift.py..." -ForegroundColor Yellow
& $venvPython fix_swift.py

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " Setup complete!" -ForegroundColor Green
Write-Host " Activate anytime using: .venv\Scripts\Activate.ps1" -ForegroundColor Green
Write-Host " Open practice.ipynb in VS Code and select kernel .venv" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
