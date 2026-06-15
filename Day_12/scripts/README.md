# Bash History Exporter Service

Dieses Projekt sichert automatisch die tägliche Bash-Historie eines Linux-Benutzers. Die Historie wird zu einer festen Uhrzeit sowie vollautomatisch beim Herunterfahren oder Abmelden des Systems in datierte Logdateien exportiert.

## Features

* **Automatisch beim Shutdown:** Nutzt einen systemd-User-Service zur Sicherung direkt vor dem Systemstopp oder dem Logout.
* **Geplantes Backup:** Sichert die Historie zusätzlich von Montag bis Freitag um 15:30 Uhr über einen Cronjob.
* **Ausfallsicherer Export:** Kopiert die physikalische Historien-Datei direkt auf Dateisystemebene, da der interaktive `history`-Befehl im systemd-Kontext funktionslos ist.
* **Vollautomatisches Setup:** Ein einziges Installationsskript richtet alle Pfade, Dienste und Cronjobs fehlerfrei ein.

## Projektstruktur

```text
.
├── scripts/
│   ├── historyscript.sh    # Backup-Skript
│   └── install_service.sh  # Installationsskript
└── README.md               # Dokumentation

```

## Voraussetzungen

* Ein Linux-System mit systemd (z. B. Rocky Linux oder Debian).
* Die Standard-Shell des Benutzers muss `bash` sein.

## Installation und Einrichtung

### 1. Repository klonen oder Skripte vorbereiten

Stellen Sie sicher, dass sich die Skripte in Ihrem Home-Verzeichnis unter `~/scripts/` befinden.

Das Hauptskript `~/scripts/historyscript.sh` muss folgenden Inhalt haben:

```bash
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
    # Der history-Befehl ist im systemd-Kontext funktionslos
    cat "$HIST_FILE" > "$OUTPUT_FILE"
fi

exit 0

```

### 2. Installationsskript ausführen

Führen Sie das Setupskript aus, um den systemd-User-Service und den Cronjob automatisch einzurichten:

```bash
chmod +x ~/scripts/install_service.sh
~/scripts/install_service.sh

```

Das Skript erledigt folgende Aufgaben:

* Macht `historyscript.sh` ausführbar.
* Erstellt die Datei `~/.config/systemd/user/history-export.service` mit den korrekten absoluten Pfaden.
* Aktiviert und startet den systemd-Dienst.
* Trägt den zeitgesteuerten Cronjob in Ihre Benutzer-Crontab ein.

## Status überprüfen

### systemd-Dienst kontrollieren

Da es sich um einen User-Service handelt, muss die Abfrage mit dem Flag `--user` erfolgen:

```bash
systemctl --user status history-export.service

```

*Hinweis:* Der Status muss `active (exited)` anzeigen. Dies ist korrekt, da der Dienst im Hintergrund aktiv bleibt, um beim Shutdown das Signal zum Beenden abzufangen und das Skript auszuführen.

### Cronjob kontrollieren

Überprüfen Sie, ob der Cronjob in Ihrer Benutzer-Crontab hinterlegt wurde:

```bash
crontab -l

```

## Logdateien

Die exportierten Historien werden standardmäßig im folgenden Verzeichnis abgelegt:

```bash
~/history_logs/rockyHisYYYYMMDD.txt

```

## Autor

* **Tobias B:** Initialentwicklung und Konzept

---
