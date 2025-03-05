#!/bin/bash

VENV_DIR=".venv"

# Navigate to the script's directory
cd "$(dirname "$0")" || exit

# Check if virtual environment exists, if not create it
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate the virtual environment
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

# Ensure we're using the correct Python inside the virtual environment
PYTHON_EXEC="$VENV_DIR/bin/python3"
PIP_EXEC="$VENV_DIR/bin/pip"

# Check if python-osc is already installed
if ! "$PIP_EXEC" show python-osc > /dev/null 2>&1; then
    echo "python-osc is not installed. Checking internet connection..."

    # Check internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        echo "No internet connection detected. Cannot install missing dependencies."
        exit 1
    else
        echo "Installing python-osc..."
        "$PIP_EXEC" install --upgrade pip
        "$PIP_EXEC" install python-osc
    fi
else
    echo "python-osc is already installed."
fi

# Run TCP2OSC.py script using the virtual environment's Python
echo "Launching tcp_to_osc.py..."
"$PYTHON_EXEC" tcp_to_osc.py

# Deactivate virtual environment
deactivate

# Keep the terminal open to see output
echo "Press Enter to close..."
read -r
