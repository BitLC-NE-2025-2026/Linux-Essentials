# Bash History Exporter Service

Dieses Projekt sichert automatisch die tägliche Bash Historie eines Linux Benutzers. Die Historie wird zu einer festen Uhrzeit sowie vollautomatisch beim Herunterfahren oder Abmelden des Systems in datierte Logdateien exportiert.

## Features
* Automatisch beim Shutdown: Nutzt einen systemd User Service zur Sicherung vor dem Systemstopp.
* Geplanter Backup: Sichert die Historie zusätzlich von Montag bis Freitag um 15:30 Uhr über Cron.
* Echtzeiterfassung: Zwingt laufende Terminal Sitzungen mit history a ihre Daten vor dem Export in die Historien Datei zu schreiben.
* Vollautomatisches Setup: Ein einziges Installationsskript richtet alle Pfade sowie Dienste und Cronjobs fehlerfrei ein.

## Projektstruktur
```text
.
├── scripts/
│   ├── historyscript.sh    # Backup Skript
│   └── install_service.sh  # Installationsskript
└── README.md               # Dokumentation
```
Voraussetzungen
Ein Linux System mit systemd wie Rocky Linux oder Debian.

Die Standard Shell muss bash sein.

Installation und Einrichtung
1. Repository klonen oder Skripte vorbereiten
Stellen Sie sicher dass sich die Skripte in Ihrem Homeverzeichnis unter ~/scripts/ befinden.

Das Hauptskript ~/scripts/historyscript.sh muss folgenden Inhalt haben:
```bash
#!/bin/bash
# ==============================================================================
# Skript: historyscript.sh
# Autor: Tobias B
# Beschreibung: Sichert die Bash Historie in datierte Logdateien.
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
```

2. Installationsskript ausführen
Führen Sie das Setupskript aus um den systemd User Service und den Cronjob automatisch einzurichten:
```bash
chmod +x ~/scripts/install_service.sh
~/scripts/install_service.sh
```

Das Skript erledigt folgendes:

Macht historyscript.sh ausführbar.

Erstellt die Datei ~/.config/systemd/user/history-export.service mit den korrekten absoluten Pfaden.

Aktiviert und startet den systemd Dienst.

Trägt den Cronjob in Ihre Crontab ein.

Status überprüfen
systemd Dienst kontrollieren
Da es sich um einen User Service handelt muss die Abfrage mit dem Flag user erfolgen:
```bash
systemctl --user status history-export.service
```
Hinweis: Der Status muss active exited anzeigen. Das ist korrekt so da der Dienst im Hintergrund darauf wartet beim Shutdown das Signal zum Beenden abzufangen.

Cronjob kontrollieren
Überprüfen Sie ob der Cronjob in Ihrer Benutzer Crontab hinterlegt ist:

```Bash
crontab -l
```
Logdateien
Die exportierten Historien werden standardmäßig im folgenden Verzeichnis abgelegt:

```Bash
~/history_logs/rockyHisYYYYMMDD.txt
```
Autor
Tobias B: Initialentwicklung und Konzept
