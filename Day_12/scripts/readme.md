# Bash History Exporter Service

Dieses Projekt sichert automatisch die tägliche Bash-Historie eines Linux-Benutzers. Die Historie wird sowohl zu einer festen Uhrzeit als auch vollautomatisch beim Herunterfahren (Shutdown) oder Abmelden (Logout) des Systems in datierte Logdateien exportiert.

## Features
* **Automatisch beim Shutdown:** Nutzt einen `systemd` User-Service, um die Historie vor dem Systemstopp zu sichern.
* **Geplanter Backup (Cron):** Sichert die Historie zusätzlich von Montag bis Freitag um 15:30 Uhr.
* **Echtzeit-Erfassung:** Zwingt laufende Terminal-Sitzungen mit `history -a`, ihre Daten vor dem Export in die Historien-Datei zu schreiben.
* **Vollautomatisches Setup:** Ein einziges Installationsskript richtet alle Pfade, Dienste und Cronjobs fehlerfrei ein.

## Projektstruktur
```text
.
├── scripts/
│   ├── historyscript.sh    # Das eigentliche Backup-Skript
│   └── install_service.sh  # Das automatisierte Installationsskript
└── README.md               # Diese Dokumentation
```

## Voraussetzungen
* Ein Linux-System mit `systemd` (z. B. Ubuntu, Debian, Rocky Linux, Fedora, RHEL).
* Die Standard-Shell muss `bash` sein.

## Installation & Einrichtung

### 1. Repository klonen oder Skripte vorbereiten
Stellen Sie sicher, dass sich die Skripte in Ihrem Home-Verzeichnis unter `~/scripts/` befinden. 

Das Hauptskript `~/scripts/historyscript.sh` muss folgenden Inhalt haben:
```bash
#!/bin/bash
HISTFILE=$HOME/.bash_history
set -o history
history -a  # Schreibt aktuelle Sitzungen in die Datei
history -r  # Lädt die aktualisierte Historie

export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
TODAY=$(date +%Y-%m-%d)
FILE_DATE=$(date +%Y%m%d)

TARGET_DIR="$HOME/history_logs"
mkdir -p "$TARGET_DIR"

# Filtert Einträge von heute und schreibt sie ins Log
history | grep " $TODAY " > "$TARGET_DIR/rockyHis${FILE_DATE}.txt"
```

### 2. Installationsskript ausführen
Führen Sie das Setup-Skript aus, um den systemd-User-Service und den Cronjob automatisch einzurichten:

```bash
chmod +x ~/scripts/install_service.sh
~/scripts/install_service.sh
```

Das Skript erledigt folgendes:
1. Macht `historyscript.sh` ausführbar.
2. Erstellt die Datei `~/.config/systemd/user/history-export.service` mit den korrekten absoluten Pfaden.
3. Aktiviert und startet den systemd-Dienst.
4. Trägt den Cronjob (Mo-Fr um 15:30 Uhr) in Ihre Crontab ein, ohne Duplikate zu erzeugen.

## Status überprüfen

### systemd-Dienst kontrollieren
Da es sich um einen User-Service handelt, muss die Abfrage mit dem Flag `--user` erfolgen:

```bash
systemctl --user status history-export.service
```
*Hinweis:* Der Status muss `active (exited)` anzeigen. Das ist korrekt so, da der Dienst im Hintergrund darauf wartet, beim Shutdown das Signal zum Beenden (`ExecStop`) abzufangen.

### Cronjob kontrollieren
Überprüfen Sie, ob der Cronjob sauber in Ihrer Benutzer-Crontab hinterlegt ist:

```bash
crontab -l
```

## Logdateien
Die exportierten Historien werden standardmäßig im folgenden Verzeichnis abgelegt:
```bash
~/history_logs/rockyHisYYYYMMDD.txt
```

## Autor
* **Tobias B** - *Initial-Entwicklung & Konzept*
