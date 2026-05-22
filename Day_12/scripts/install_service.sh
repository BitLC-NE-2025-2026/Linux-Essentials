#!/bin/bash
# ==============================================================================
# Skript: install_service.sh
# Beschreibung: Automatisches Setup für das History-Skript, systemd und Cron
# Autor: Tobias B
# ==============================================================================

# Aktivierung des strikten Modus für eine ausfallsichere Ausführung
set -euo pipefail

# ==============================================================================
# Variablendeklaration
# ==============================================================================
readonly SCRIPT_PATH="${HOME}/scripts/historyscript.sh"
readonly SERVICE_DIR="${HOME}/.config/systemd/user"
readonly SERVICE_FILE="${SERVICE_DIR}/history-export.service"
readonly CRON_JOB="30 15 * * 1-5 /bin/bash ${SCRIPT_PATH}"

echo "=== Starte Installation von history-export ==="

# ==============================================================================
# Hauptskript prüfen und berechtigen
# ==============================================================================
if [ -f "$SCRIPT_PATH" ]; then
    chmod +x "$SCRIPT_PATH"
    echo "[OK] Hauptskript ausführbar gemacht."
else
    echo "[FEHLER] Hauptskript nicht unter ${SCRIPT_PATH} gefunden!"
    exit 1
fi

# ==============================================================================
# Systemd-Verzeichnis anlegen
# ==============================================================================
mkdir -p "$SERVICE_DIR"

# ==============================================================================
# Service-Datei generieren
# ==============================================================================
readonly ABS_SCRIPT_PATH=$(realpath "$SCRIPT_PATH")

cat << EOF > "$SERVICE_FILE"
[Unit]
Description=Exportiert die Bash-Historie vor dem Herunterfahren
DefaultDependencies=no
Before=shutdown.target exit.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStop=${ABS_SCRIPT_PATH}

[Install]
WantedBy=default.target
EOF

# ==============================================================================
# Systemd-Dienst aktivieren
# ==============================================================================
systemctl --user daemon-reload
systemctl --user enable history-export.service
systemctl --user start history-export.service
echo "[OK] Systemd-Dienst geladen und aktiviert."

# ==============================================================================
# Cronjob einrichten
# ==============================================================================
# Sicheres Auslesen der bestehenden Crontab ohne Fehlerabbruch bei Leere
CRONTAB_CONTENT=$(crontab -l 2>/dev/null || true)
FILTERED_CRONTAB=$(echo "$CRONTAB_CONTENT" | grep -v "$SCRIPT_PATH" || true)

# Neue Crontab schreiben und Leerzeilen entfernen
echo -e "${FILTERED_CRONTAB}\n${CRON_JOB}" | sed '/^$/d' | crontab -
echo "[OK] Cronjob für Mo-Fr um 15:30 Uhr eingerichtet."

echo "=== Installation erfolgreich abgeschlossen! ==="
exit 0
