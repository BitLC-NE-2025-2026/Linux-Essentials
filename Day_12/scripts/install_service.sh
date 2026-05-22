#!/bin/bash
# ==============================================================================
# Skript: install_service.sh
# Beschreibung: Automatisches Setup für das History-Skript, systemd und Cron
# Author Tobias B
# ==============================================================================

# Pfade dynamisch ermitteln
SCRIPT_PATH="$HOME/scripts/historyscript.sh"
SERVICE_DIR="$HOME/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/history-export.service"
CRON_JOB="30 15 * * 1-5 /bin/bash $SCRIPT_PATH"

echo "=== Starte Installation von history-export ==="

# 1. Prüfen, ob das Hauptskript existiert und Rechte setzen
if [ -f "$SCRIPT_PATH" ]; then
    chmod +x "$SCRIPT_PATH"
    echo "[OK] Hauptskript ausführbar gemacht."
else
    echo "[FEHLER] Hauptskript nicht unter $SCRIPT_PATH gefunden!"
    exit 1
fi

# 2. Systemd-Verzeichnis anlegen
mkdir -p "$SERVICE_DIR"

# 3. Service-Datei mit absolutem Pfad generieren
cat << EOF > "$SERVICE_FILE"
[Unit]
Description=Exportiert die Bash-Historie vor dem Herunterfahren
DefaultDependencies=no
Before=shutdown.target exit.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStop=/bin/bash $SCRIPT_PATH

[Install]
WantedBy=default.target
EOF
echo "[OK] Systemd-Service-Datei dynamisch erstellt."

# 4. Systemd-Dienst aktivieren und starten
systemctl --user daemon-reload
systemctl --user enable history-export.service
systemctl --user start history-export.service
echo "[OK] Systemd-Dienst geladen und aktiviert."

# 5. Cronjob einrichten (Duplikate verhindern)
# Bestehende Crontab sichern, den Job falls vorhanden entfernen und neu hinzufügen
(crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH"; echo "$CRON_JOB") | crontab -
echo "[OK] Cronjob für Mo-Fr um 15:30 Uhr eingerichtet."

echo "=== Installation erfolgreich abgeschlossen! ==="
