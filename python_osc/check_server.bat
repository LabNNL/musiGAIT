@echo off
setlocal enabledelayedexpansion

REM Check if main_server.exe is running
set SERVER_RUNNING=0
for /f "tokens=2" %%p in ('tasklist ^| findstr main_server.exe') do (
	set SERVER_RUNNING=1
)

if "!SERVER_RUNNING!"=="0" (
	echo 0
	exit /b 1
) else (
	echo 1 [INFO] main_server.exe is already running.
	exit /b 0
)

endlocal
