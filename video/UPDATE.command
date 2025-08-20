#!/bin/bash

# Set the working directory to the script's location
cd "$(dirname "$0")"

# Use full path to Python
PYTHON_PATH=$(which python3)

# Run the Python script
"$PYTHON_PATH" update_video.py
