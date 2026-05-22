#!/bin/bash
# ==============================================================================
# Skript: historyscript.sh
# Autor: Tobias B
# Beschreibung: Sichert die Bash-Historie in datierte Logdateien.
# ==============================================================================

# Aktivierung des strikten Modus für eine ausfallsichere Ausführung
set -euo pipefail

# ==============================================================================
# Variablendeklaration und Initialisierung
# ==============================================================================
readonly HIST_FILE="${HOME}/.bash_history"
readonly TARGET_DIR="${HOME}/history_logs"
readonly FILE_DATE=$(date +%Y%m%d)
readonly OUTPUT_FILE="${TARGET_DIR}/rockyHis${FILE_DATE}.txt"

# ==============================================================================
# Hauptlogik
# ==============================================================================

# Zielverzeichnis erstellen
mkdir -p "$TARGET_DIR"

# Prüfung der Existenz der Quelldatei
if [ -f "$HIST_FILE" ]; then
    # Direktes Kopieren der physikalischen Datei
    # Der history Befehl ist im systemd Kontext funktionslos
    cat "$HIST_FILE" > "$OUTPUT_FILE"
fi

exit 0
