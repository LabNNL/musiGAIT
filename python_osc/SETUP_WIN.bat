@echo off
set VENV_DIR=.venv

:: Check if virtual environment exists, if not create it
if not exist %VENV_DIR% (
    echo Creating virtual environment...
    python -m venv %VENV_DIR%
)

:: Activate the virtual environment
call %VENV_DIR%\Scripts\activate

:: Install required package
echo Installing python-osc...
python.exe -m pip install --upgrade pip
pip install python-osc

:: Run TCP2OSC.py script
echo Launching TCP2OSC.py...
python TCP2OSC.py

:: Deactivate virtual environment
deactivate
