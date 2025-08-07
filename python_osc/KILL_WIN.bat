@echo off
echo [INFO] Starting process cleanup...

:: Kill main_server process
for /f "tokens=2" %%p in ('tasklist ^| findstr main_server') do (
    echo [INFO] Found main_server with PID: %%p, killing it...
    taskkill /F /PID %%p
)

:: Kill all Python processes
for /f "tokens=2" %%p in ('tasklist ^| findstr python') do (
    echo [INFO] Found Python process with PID: %%p, killing it...
    taskkill /F /PID %%p
)

echo [INFO] Process cleanup complete.
