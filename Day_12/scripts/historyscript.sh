#!/bin/bash
# Bash-Historie
HISTFILE=$HOME/.bash_history
set -o history
history -r

# Zeitstempel-Format definieren
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Aktuelles Datum
TODAY=$(date +%Y-%m-%d)
FILE_DATE=$(date +%Y%m%d)

# Zielverzeichnis
TARGET_DIR="$HOME/history_logs"
mkdir -p "$TARGET_DIR"

# Historie filtern und exportieren
history | grep " $TODAY " > "$TARGET_DIR/rockyHis${FILE_DATE}.txt"
