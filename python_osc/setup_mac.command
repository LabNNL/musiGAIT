#!/usr/bin/env bash

set -o pipefail

cd "$(dirname "$0")" || {
	echo "[FATAL] Can't cd to script directory."
	exit 1
}

VENV_DIR=".venv"

# Create venv if missing
if [ ! -x "$VENV_DIR/bin/python" ] && [ ! -x "$VENV_DIR/bin/python3" ]; then
	echo "[INFO] Creating virtual environment..."
	# Pick a system Python
	if command -v python3 >/dev/null 2>&1; then
		BOOTSTRAP_PY=python3
	elif command -v python >/dev/null 2>&1; then
		BOOTSTRAP_PY=python
	else
		echo "[FATAL] No python3/python found. Install Python (e.g., via Homebrew)."
		[ -t 0 ] && read -r -p "[INFO] Press Return to close..." _
		exit 1
	fi

	"$BOOTSTRAP_PY" -m venv "$VENV_DIR" || {
		echo "[FATAL] venv creation failed."
		[ -t 0 ] && read -r -p "[INFO] Press Return to close..." _
		exit 1
	}
fi

# Use Python from the venv
if [ -x "$VENV_DIR/bin/python3" ]; then
	PY="$VENV_DIR/bin/python3"
else
	PY="$VENV_DIR/bin/python"
fi

# Activate (optional but nice for PATH/env)
# shellcheck source=/dev/null
if [ -f "$VENV_DIR/bin/activate" ]; then
	. "$VENV_DIR/bin/activate"
fi

# Install python-osc if missing (module name: pythonosc)
"$PY" - <<'PY'
import importlib.util, sys
sys.exit(0 if importlib.util.find_spec('pythonosc') else 1)
PY
if [ $? -ne 0 ]; then
	echo "[INFO] python-osc missing; installing..."
	"$PY" -m pip install --upgrade pip || {
		echo "[FATAL] pip upgrade failed (offline/proxy?)."
		[ -t 0 ] && read -r -p "[INFO] Press Return to close..." _
		exit 1
	}
	"$PY" -m pip install python-osc || {
		echo "[FATAL] python-osc install failed (offline/proxy?)."
		[ -t 0 ] && read -r -p "[INFO] Press Return to close..." _
		exit 1
	}
fi

echo "[INFO] Setup complete, launching tcp_to_osc.py..."

# Run your script, forward all args
"$PY" tcp_to_osc.py "$@"
EXITCODE=$?

# Deactivate if we activated
type deactivate >/dev/null 2>&1 && deactivate

# Keep Terminal open on double-click
[ -t 0 ] && read -r -p "[INFO] Press Return to close..." _

exit $EXITCODE
