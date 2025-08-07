#!/bin/bash

PIDFILE="tcp_to_osc.pid"

# Stop tcp_to_osc.py by PID file
if [[ -f "$PIDFILE" ]]; then
    PID=$(cat "$PIDFILE" | tr -d '[:space:]')
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "[INFO] Found tcp_to_osc.py with PID: $PID, killing it..."
        kill "$PID"
        # Give it a second to terminate
        sleep 1
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "[INFO] PID $PID still running, force killing..."
            kill -9 "$PID"
        fi
    else
        echo "[WARN] PID $PID from $PIDFILE not running."
    fi
    rm -f "$PIDFILE"
else
    echo "[WARN] No tcp_to_osc.py process found ($PIDFILE missing), skipping."
fi

# Stop main_server
SERVER_FOUND=0
while IFS= read -r server_pid; do
    if [[ -n "$server_pid" ]]; then
        echo "[INFO] Found main_server with PID: $server_pid, killing it..."
        kill "$server_pid"
        sleep 1
        if ps -p "$server_pid" > /dev/null 2>&1; then
            echo "[INFO] PID $server_pid still running, force killing..."
            kill -9 "$server_pid"
        fi
        SERVER_FOUND=1
    fi
done < <(pgrep -f main_server)

if [[ "$SERVER_FOUND" -eq 0 ]]; then
    echo "[WARN] No main_server process found, skipping."
fi

echo "[INFO] Process cleanup complete."
