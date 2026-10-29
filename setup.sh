#!/usr/bin/env bash
set -e

echo "=========================================="
echo " Setting up FRA371 Kinematics Workshop Lab2"
echo " (Linux / macOS)"
echo "=========================================="

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] python3 not found. Please install Python 3.10-3.12."
    exit 1
fi

# Create virtual environment if it does not exist
if [ ! -d ".venv" ]; then
    echo "[INFO] Creating virtual environment (.venv)..."
    python3 -m venv .venv
else
    echo "[INFO] Existing .venv found."
fi

# Clean PYTHONPATH to prevent ROS conflicts on Ubuntu
export PYTHONPATH=""

# Activate virtual environment
source .venv/bin/activate

# Upgrade pip
echo "[INFO] Upgrading pip..."
pip install --upgrade pip

# Install requirements
echo "[INFO] Installing dependencies from requirements.txt..."
pip install -r requirements.txt

# Run fix_swift.py
echo "[INFO] Running fix_swift.py..."
python fix_swift.py

echo ""
echo "=========================================="
echo " Setup complete!"
echo " Activate anytime using: source .venv/bin/activate"
echo " Open practice.ipynb in VS Code and select kernel .venv"
echo "=========================================="
