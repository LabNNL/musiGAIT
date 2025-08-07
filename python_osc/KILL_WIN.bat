@echo off
setlocal enabledelayedexpansion

set PIDFILE=tcp_to_osc.pid

REM Stop tcp_to_osc.py by PID file
if exist "%PIDFILE%" (
    set /p PID=<"%PIDFILE%"
    echo [INFO] Found tcp_to_osc.py with PID: !PID!, killing it...
    taskkill /F /PID !PID!
    del "%PIDFILE%"
) else (
    echo [WARN] No %PIDFILE% found, skipping.
)

REM Stop main_server.exe
set SERVER_KILLED=0
for /f "tokens=2" %%p in ('tasklist ^| findstr main_server') do (
    echo [INFO] Found main_server with PID: %%p, killing it...
    taskkill /F /PID %%p
    set SERVER_KILLED=1
)
if "!SERVER_KILLED!"=="0" (
    echo [WARN] No main_server.exe process found, skipping.
)

echo [INFO] Process cleanup complete.
endlocal
