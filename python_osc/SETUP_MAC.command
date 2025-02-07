#!/bin/bash

VENV_DIR=".venv"

# Navigate to the script's directory
cd "$(dirname "$0")" || exit

# Check if virtual environment exists, if not create it
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv $VENV_DIR
fi

# Activate the virtual environment
source $VENV_DIR/bin/activate

# Upgrade pip and install dependencies
echo "Installing python-osc..."
python3 -m pip install --upgrade pip
pip install python-osc

# Run TCP2OSC.py script
echo "Launching tcp_to_osc.py..."
python3 tcp_to_osc.py

# Deactivate virtual environment
deactivate

# Keep the terminal open to see output
echo "Press Enter to close..."
read -r
