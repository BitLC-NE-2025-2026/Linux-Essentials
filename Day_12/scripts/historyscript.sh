#!/bin/bash
# ==============================================================================
# Skript: historyscript.sh
# Author: Tobias B
# Beschreibung: Exportiert die tägliche Bash-Historie in datierte Logdateien
# Speicherort: ~/scripts/historyscript.sh
# ==============================================================================
# Definiere den absoluten Pfad zur Historien-Datei
readonly HIST_FILE="${HOME}/.bash_history"
readonly TARGET_DIR="${HOME}/history_logs"
readonly FILE_DATE=$(date +%Y%m%d)
readonly TODAY=$(date +%Y-%m-%d)
readonly OUTPUT_FILE="${TARGET_DIR}/rockyHis${FILE_DATE}.txt"

# Zielverzeichnis sicherstellen
mkdir -p "$TARGET_DIR"

# Historie in das Logfile schreiben. 
# Hinweis: Wir lesen die Datei direkt, da systemd-Prozesse 
# keinen Zugriff auf den RAM-Puffer interaktiver Shells haben.
if [ -f "$HIST_FILE" ]; then
    # Historie mit Zeitstempel filtern und in Datei schreiben
    # Die Umgebungsvariable wird hier temporär gesetzt
    HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S " history | grep " $TODAY " > "$TARGET_DIR/rockyHis${FILE_DATE}.txt"
fi
