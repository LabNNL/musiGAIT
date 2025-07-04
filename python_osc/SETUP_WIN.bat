@echo off
setlocal
set VENV_DIR=.venv

:: Check if virtual environment exists, if not create it
if not exist %VENV_DIR% (
    echo Creating virtual environment...
    python -m venv %VENV_DIR%
)

:: Activate the virtual environment
call %VENV_DIR%\Scripts\activate

:: Ensure we're using the Python from the virtual environment
set PYTHON_EXEC=%VENV_DIR%\Scripts\python.exe
set PIP_EXEC=%VENV_DIR%\Scripts\pip.exe

:: Check if python-osc is already installed
%PIP_EXEC% show python-osc >nul 2>&1
if %errorlevel% neq 0 (
    echo python-osc is not installed. Checking internet connection...

    :: Check internet connection
    ping -n 1 www.google.com >nul 2>&1
    if %errorlevel% neq 0 (
        echo No internet connection detected. Cannot install missing dependencies.
        exit /b 1
    ) else (
        echo Installing python-osc...
        %PIP_EXEC% install --upgrade pip
        %PIP_EXEC% install python-osc
    )
) else (
    echo python-osc is already installed.
)

:: Run TCP2OSC.py script using the virtual environment's Python
%PYTHON_EXEC% tcp_to_osc.py %*

:: Deactivate virtual environment
deactivate

:: Keep the terminal open to see output
echo Press Enter to close...
pause
