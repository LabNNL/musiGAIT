#!/bin/bash

echo "Starting process cleanup..."

# Kill main_server process
# shellcheck disable=SC2009
ps aux | grep "main_server" | grep -v grep | awk '{print $2}' | while read pid; do
    echo "Found main_server with PID: $pid, killing it..."
    # Kill main_server process
    kill -9 "$pid"
done

# Kill all python processes
# shellcheck disable=SC2009
ps aux | grep "python" | grep -v grep | awk '{print $2}' | while read pid; do
    echo "Found Python process with PID: $pid, killing it..."
    # Kill Python process
    kill -9 "$pid"
done

echo "Process cleanup complete."
