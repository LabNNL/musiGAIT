#!/bin/bash

# Check if main_server is running
if pgrep -x "main_server" >/dev/null; then
	echo "1 [INFO] main_server is already running."
	exit 0
else
	echo "0"
	exit 1
fi
