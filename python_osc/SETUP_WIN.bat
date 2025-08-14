@echo off
setlocal
set VENV_DIR=.venv

REM Create venv if missing
if not exist "%VENV_DIR%\Scripts\python.exe" (
	echo [INFO] Creating virtual environment...
	py -3 -m venv "%VENV_DIR%"
)

call "%VENV_DIR%\Scripts\activate.bat"
set "PYTHON_EXEC=%VENV_DIR%\Scripts\python.exe"

REM Check if python-osc is already installed
"%PYTHON_EXEC%" -c "import importlib.util, sys; sys.exit(0 if importlib.util.find_spec('pythonosc') else 1)"
if errorlevel 1 (
	echo [WARNING] python-osc missing; installing...
	"%PYTHON_EXEC%" -m pip install --upgrade pip || (echo [FATAL] pip upgrade failed ^(offline/proxy?^). & exit /b 1)
	"%PYTHON_EXEC%" -m pip install python-osc || (echo [FATAL] install failed ^(offline/proxy?^). & exit /b 1)
)

echo [INFO] Setup complete, launching tcp_to_osc.py...

"%PYTHON_EXEC%" tcp_to_osc.py %*
deactivate
echo [INFO] Press Enter to close...
pause
