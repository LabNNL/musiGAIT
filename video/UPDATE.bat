@echo off
cd /d "%~dp0"

:: Ensure Python is found
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo Python is not found in your system's PATH. Please install Python or add it to PATH.
    pause
    exit /b
)

:: Run the Python script
python update_video.py

:: Keep the window open to show any output/errors
echo.
pause
