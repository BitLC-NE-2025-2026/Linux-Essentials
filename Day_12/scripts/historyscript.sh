#!/bin/bash
# ==============================================================================
# Skript: historyscript.sh
# Autor: Tobias B
# Beschreibung: Sichert die Bash Historie in datierte Logdateien.
# ==============================================================================

set -euo pipefail

readonly HIST_FILE="${HOME}/.bash_history"
readonly TARGET_DIR="${HOME}/history_logs"
readonly FILE_DATE=$(date +%Y%m%d)
readonly OUTPUT_FILE="${TARGET_DIR}/rockyHis${FILE_DATE}.txt"

mkdir -p "$TARGET_DIR"

if [ -f "$HIST_FILE" ]; then
    cat "$HIST_FILE" > "$OUTPUT_FILE"
fi

exit 0
