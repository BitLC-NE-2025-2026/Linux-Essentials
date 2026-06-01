# ⏱️ Linux Essentials Tag 12

![Linux Essentials Day 12 Header](./header.png)

Am zwölften Tag der Linux Essentials behandeln wir die zeitgesteuerte Ausführung von Befehlen. Wir konzentrieren uns auf cron, cronjobs und die crontab. Diese Werkzeuge automatisieren wiederkehrende Aufgaben im System.

---

## 📑 Inhaltsverzeichnis

* [Lernziele LPIC-1 relevant](#-lernziele-lpic-1-relevant)
* [Grundlagen zu cron und crontab](#️-1-grundlagen-zu-cron-und-crontab)
* [Aufbau einer Crontab](#️-2-aufbau-einer-crontab)
* [Crontab Befehle und Editor Konfiguration](#️-3-crontab-befehle-und-editor-konfiguration)
* [Systemweite Benachrichtigungen mit wall in Cronjobs](#-4-systemweite-benachrichtigungen-mit-wall-in-cronjobs)
* [Steuerung des cron Daemons mit systemctl](#️-6-steuerung-des-cron-daemons-mit-systemctl)
* [Ressourcen und Hilfsmittel](#-5-ressourcen-und-hilfsmittel)
* [Zurück zur Übersicht](#-8-zurück-zur-übersicht)

---

## 🎯 Lernziele LPIC-1 relevant

* Verständnis des cron Daemons.
* Aufbau und Syntax der crontab beherrschen.
* Eigene cronjobs erstellen und verwalten.
* Den Standardeditor für Systembefehle konfigurieren.

---

## ⚙️ 1. Grundlagen zu cron und crontab

Der cron Daemon läuft im Hintergrund eines Unix Systems. Er führt geplante Aufgaben zu festgelegten Zeiten aus.

* cron: Der Hintergrunddienst für die Ausführung.
* cronjob: Die einzelne geplante Aufgabe.
* crontab: Die Tabelle mit den Konfigurationen der cronjobs. Jede Zeile repräsentiert einen eigenen cronjob.

### Standardeditor unter Rocky Linux

Auf Betriebssystemen wie Rocky Linux arbeitet das Werkzeug crontab standardmäßig mit dem Editor vim.

Falls die Bearbeitung nicht mit vim erfolgen soll, lässt sich der Editor nano für den aktuellen Benutzer festlegen. Der kombinierte Befehl schreibt die entsprechende Umgebungsvariable in das persönliche Profil und aktiviert die Änderung sofort für die aktuelle Sitzung.

```bash
echo "export EDITOR=nano" >> ~/.bash_profile && source ~/.bash_profile
```

---

### 🏗️ 2. Aufbau einer Crontab

Eine crontab Zeile besteht aus fünf Zeitfeldern und dem auszuführenden Befehl. Ein Leerzeichen trennt die einzelnen Felder.

**Struktur und Wertebereiche:**

| Position | Feld | Wertebereich | Beschreibung |
| :---: | :--- | :--- | :--- |
| 1 | Minute | 0 bis 59 | Exakte Minute der Ausführung |
| 2 | Stunde | 0 bis 23 | Stunde im 24 Stunden Format |
| 3 | Tag | 1 bis 31 | Tag des Monats |
| 4 | Monat | 1 bis 12 | Monat des Jahres |
| 5 | Wochentag | 0 bis 7 | Wochentag, wobei 0 und 7 dem Sonntag entsprechen |
| 6 | Befehl | Text | Absoluter Pfad zum auszuführenden Kommando oder Skript |

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - System- vs. Benutzer-Crontab:**  
> Es gibt zwei Arten von Crontabs mit einer **kritischen syntaktischen Abweichung**:  
> 1. **Benutzer-Crontab (via `crontab -e`):** Hat die obigen 5 Zeitfelder gefolgt direkt vom Befehl. (z.B. `0 12 * * * /usr/bin/backup.sh`).  
> 2. **System-Crontab (`/etc/crontab` und Dateien in `/etc/cron.d/*`):** Hat **6 Felder vor dem Befehl**! Das 6. Feld definiert den **Benutzer**, unter dessen Rechten der Befehl laufen soll (z.B. `0 12 * * * root /usr/bin/backup.sh`).  
>   > [!WARNING]  
>   > **Prüfungsfalle:** Vergessen Sie in `/etc/crontab` niemals das Benutzerfeld, sonst wird der Befehl nicht ausgeführt und wirft Fehler!  
> * **Periodische Systemordner:** Das System führt Skripte in diesen Ordnern automatisch aus: `/etc/cron.hourly/`, `/etc/cron.daily/`, `/etc/cron.weekly/`, `/etc/cron.monthly/`. Skripte hier müssen ausführbar sein und dürfen **keine** Dateiendungen (wie `.sh`) haben!  

**Sonderzeichen zur Zeitsteuerung:**

| Zeichen | Funktion | Anwendungsbeispiel |
| :---: | :--- | :--- |
| `*` | Jeder mögliche Wert | Ein Stern im Monatsfeld führt den Befehl jeden Monat aus |
| `,` | Trennt diskrete Einzelwerte | `1,15,30` im Tagesfeld führt zur Ausführung am ersten, fünfzehnten und dreißigsten Tag |
| `-` | Definiert einen fortlaufenden Bereich | `1-5` im Wochentagsfeld führt den Befehl von Montag bis Freitag aus |
| `/` | Definiert ein wiederkehrendes Intervall | `*/5` im Minutenfeld löst die Ausführung alle fünf Minuten aus |

### 💡 Praxisbeispiele für Zeitintervalle

Die folgenden Beispiele zeigen typische Konfigurationen für cronjobs.

| cron Syntax | Ausführungszeitpunkt |
| :--- | :--- |
| `0 8 * * 1` | Jeden Montag um 08:00 Uhr |
| `*/15 * * * *` | Alle 15 Minuten |
| `0 22 * * 1-5` | Montag bis Freitag um 22:00 Uhr |
| `0 0 1 * *` | Am ersten Tag jedes Monats um Mitternacht |
| `0 12 1,15 * *` | Am ersten und fünfzehnten Tag des Monats um 12:00 Uhr |
| `*/5 8-17 * * *` | Alle 5 Minuten zwischen 08:00 und 17:59 Uhr |
| `0 4 * * 6,7` | Samstag und Sonntag um 04:00 Uhr |

### 💡 Praxisbeispiele für komplexe Cronjobs

Die folgenden Beispiele zeigen detailliert kommentierte Cronjobs für verschiedene Anwendungsfälle. Die Kommentare entsprechen den erweiterten Vorgaben zur Code Dokumentation.

```bash
# ==============================================================================
# Skript: Systemprüfung
# Beschreibung: Führt das Skript alle 15 Minuten aus.
# Minute: */15 bedeutet alle 15 Minuten
# Stunde: * bedeutet jede Stunde
# Tag: * bedeutet jeden Tag
# Monat: * bedeutet jeden Monat
# Wochentag: * bedeutet jeden Wochentag
# ==============================================================================
*/15 * * * * /usr/local/bin/check_system.sh
```

```bash
# ==============================================================================
# Skript: Wartung
# Beschreibung: Startet das Wartungsskript jeden Werktag um 08:30 Uhr.
# Minute: 30
# Stunde: 8
# Tag: * # Monat: *
# Wochentag: 1 bis 5 bedeutet Montag bis Freitag
# ==============================================================================
30 8 * * 1-5 /opt/scripts/wartung.sh
```

```bash
# ==============================================================================
# Skript: Monatliches Backup
# Beschreibung: Erstellt ein Backup am ersten Tag jedes Monats um Mitternacht.
# Minute: 0
# Stunde: 0
# Tag: 1 bedeutet der erste Tag des Monats
# Monat: *
# Wochentag: *
# ==============================================================================
0 0 1 * * /var/backups/monthly_backup.sh
```

```bash
# ==============================================================================
# Skript: Bericht senden
# Beschreibung: Sendet einen Statusbericht jeden Sonntag um 20:45 Uhr.
# Minute: 45
# Stunde: 20
# Tag: *
# Monat: *
# Wochentag: 0 bedeutet Sonntag
# ==============================================================================
45 20 * * 0 /usr/bin/report_sender.sh
```

```bash
# ==============================================================================
# Skript: Temporäre Dateien löschen
# Beschreibung: Löscht Dateien alle zwei Stunden zwischen 09:00 und 17:00 Uhr an Wochenenden.
# Minute: 0
# Stunde: 9 bis 17 in Zweierschritten
# Tag: *
# Monat: *
# Wochentag: 6 und 0 bedeutet Samstag und Sonntag
# ==============================================================================
0 9-17/2 * * 6,0 /bin/rm_temp_files.sh
```

---

## ⌨️ 3. Crontab Befehle und Editor Konfiguration

Zur Verwaltung der eigenen cronjobs nutzt man den Befehl crontab im Terminal.

Befehle:

* `crontab -e`: Öffnet die crontab zum Bearbeiten.
* `crontab -l`: Listet alle aktiven cronjobs auf.
* `crontab -r`: Löscht die aktuelle crontab vollständig.

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - Anacron & Berechtigungssteuerung:**  
> * **`anacron` (der Retter bei Offline-Zeiten):** Normaler `cron` setzt voraus, dass der PC 24/7 läuft. Ist der PC nachts um 03:00 Uhr aus, fällt der tägliche Cronjob aus. **`anacron`** holt verpasste Jobs beim nächsten Systemstart nach.  
>   * **Konfiguration:** `/etc/anacrontab`.  
>   * **Format:** `Periode (in Tagen)   Verzögerung (in Min)   Job-ID   Befehl` (z.B. `1   5   cron.daily   nice run-parts /etc/cron.daily`).  
>   * **Unterschied zu Cron:** Anacron kann keine minutengenauen Intervalle ausführen (kleinste Einheit ist 1 Tag), benötigt keinen Hintergrunddaemon (wird über Systemstart/Cron getriggert) und läuft nur als root.  
> * **Zugriffsteuerung für cron:**  
>   * **`/etc/cron.allow`**: Wenn diese Datei existiert, dürfen **nur** die dort eingetragenen Benutzer eigene Crontabs anlegen.  
>   * **`/etc/cron.deny`**: Wenn `cron.allow` fehlt, dürfen alle Benutzer außer den hier eingetragenen Crontabs nutzen.  
>   * Sind beide Dateien nicht vorhanden, entscheidet die Distribution (meist darf jeder, oder nur root).  
> 
> * **Einmalige Ausführung mit `at` & `batch`:**  
>   Für einmalige Aufgaben zu einem bestimmten Zeitpunkt nutzen wir **`at`**:  
>   * **Befehl eingeben:** `at 14:30` oder `at now + 3 days` oder `at teatime`. Die Befehle werden über eine interaktive Shell eingegeben und mit `Strg + D` abgeschlossen.  
>   * **`atq`** (oder `at -l`): Listet alle anstehenden `at`-Jobs mit IDs auf.  
>   * **`atrm <ID>`** (oder `at -d`): Löscht den anstehenden Job.  
>   * **`at -c <ID>`**: Zeigt den genauen Inhalt des Jobs (inklusive aller gesetzten Umgebungsvariablen) an.  
>   * **`batch`**: Führt einen einmaligen Job aus, sobald die Systemlast (Load Average) unter einen bestimmten Wert (Standard: 1.5 bzw. 0.8) fällt.  
>   * **Berechtigungen:** Wird exakt wie bei cron über die Dateien `/etc/at.allow` und `/etc/at.deny` gesteuert.

Standardmäßig öffnet `crontab -e` den Editor vi oder vim. Zur Nutzung von nano lässt sich die Umgebungsvariable EDITOR dauerhaft anpassen. Dies ist optional.

```bash
# Fügt den Befehl zum Setzen der EDITOR Variable an das Ende der Benutzerprofil Datei an.
# Der doppelte Pfeil >> verhindert das Überschreiben der Datei und hängt den Text unten an.
# Der logische AND Operator && sorgt dafür,
# dass der zweite Befehl nur nach erfolgreichem ersten Befehl ausgeführt wird.
# Der Befehl source liest die Datei sofort neu ein und macht nano im aktuellen Terminal aktiv.
echo "export EDITOR=nano" >> ~/.bash_profile && source ~/.bash_profile
```

---

## 📢 4. Systemweite Benachrichtigungen mit wall in Cronjobs

Standardmäßig besitzen Cronjobs kein zugeordnetes Terminal, da sie vollautomatisch im Hintergrund des Systems laufen. Ausgaben, die ein Skript erzeugt, gehen ohne explizite Umleitung verloren oder werden als systeminterne Mail an den Besitzer des Cronjobs gesendet.

Hier kommt der Befehl `wall` ins Spiel. Das Werkzeug sendet eine Textnachricht an alle aktuell am System angemeldeten Benutzer und projiziert den Text direkt in deren offene Terminals. Im Kontext von automatisierten Aufgaben ist dies nützlich, um aktive Benutzer sofort über kritische Ereignisse oder bevorstehende administrative Eingriffe zu informieren.

### Typische Einsatzszenarien im administrativen Alltag

* **Wartungsarbeiten:** Benutzer werden vor einem geplanten Systemneustart gewarnt, um ungespeicherte Arbeiten zu sichern.
* **Sicherheitsalarme:** Das Erkennen von kritischen Systemzuständen wird sofort gemeldet.
* **Statusberichte:** Fehlerhafte Backups mit hoher Priorität hinterlassen eine direkte Meldung auf den Konsolen der Administratoren.

### Syntax und Einbindung in die Crontab

Die Übergabe des Textes an `wall` erfolgt über eine Pipeline, indem der Ausgabetext eines Echos an den Standardinput von `wall` weitergeleitet wird.

```bash
# ==============================================================================
# Skript: Wartungsankündigung
# Beschreibung: Sendet jeden Freitag um 17:00 Uhr eine Systemnachricht an alle.
# Minute: 0
# Stunde: 17
# Tag: *
# Monat: *
# Wochentag: 5 entspricht dem Wochentag Freitag
# ==============================================================================
0 17 * * 5 echo "Achtung: Das System wird in Kürze gewartet" | wall
```

---

## 📚 5. Ressourcen und Hilfsmittel

Die Definition der korrekten Zeiten ist fehleranfällig.
Die Webseite crontab.guru übersetzt die Cron Syntax in lesbaren Text und hilft bei der Erstellung komplexer Intervalle.

* Link: [crontab.guru/](https://crontab.guru/)

---

## 🛠️ 6. Steuerung des cron Daemons mit systemctl

Der cron Dienst läuft permanent im Hintergrund. Moderne Linux Distributionen nutzen systemd zur Verwaltung der Hintergrunddienste. Das primäre Werkzeug zur Steuerung ist der Befehl `systemctl`.

Der genaue Name des Dienstes variiert je nach Betriebssystem. Red Hat basierte Distributionen wie Rocky Linux nutzen `crond`. Debian basierte Distributionen verwenden `cron`.

**Wichtige systemctl Befehle zur Dienstverwaltung:**

| Befehl | Aktion | Beschreibung |
| :--- | :--- | :--- |
| `systemctl status crond` | Statusprüfung | Zeigt den aktuellen Laufzeitstatus und die letzten Logeinträge an |
| `systemctl start crond` | Start | Startet den Dienst sofort |
| `systemctl stop crond` | Stopp | Beendet den Dienst sofort |
| `systemctl restart crond` | Neustart | Beendet den Dienst und startet ihn umgehend neu |
| `systemctl enable crond` | Autostart an | Aktiviert den automatischen Start des Dienstes beim Systemhochlauf |
| `systemctl disable crond` | Autostart aus | Deaktiviert den automatischen Start beim Systemhochlauf |

**Praxisbeispiel zur Dienstkonfiguration:**

Aktiviert den Autostart für den crond Dienst dauerhaft

```bash
systemctl enable crond
```

Startet den Dienst in der aktuellen Sitzung

```bash
systemctl start crond
```

Gibt den Status des Dienstes zur sofortigen Kontrolle im Terminal aus

```bash
systemctl status crond
```

---

## 📝 7. Historien-Automatisierung mit Cronjobs

Um die Bash-Historie täglich automatisiert zu sichern und nach Tagen zu sortieren, erstellen wir ein dediziertes Skript. Dieses Skript nutzt Zeitstempel, um die Historie für den aktuellen Tag in eine spezifische Textdatei im Benutzerverzeichnis zu exportieren.

### Installation des Skripts

1. **Skript ablegen:** Speichere das Skript unter `$HOME/scripts/historyscript.sh`.
2. **Rechte setzen:** Weise dem Skript die notwendigen Ausführungsrechte zu:

```bash
chmod +x ~/scripts/historyscript.sh
```

### Inhalt des Scripts

```Bash
#!/bin/bash
# ==============================================================================
# Skript: historyscript.sh
# Author: Tobias B
# Beschreibung: Exportiert die tägliche Bash-Historie in datierte Logdateien
# Speicherort: ~/scripts/historyscript.sh
# ==============================================================================

# Definiert die Historien-Datei und aktiviert die Historien-Funktion
HISTFILE=$HOME/.bash_history
set -o history
history -r

# Zeitstempel-Format für die Historie setzen
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Variablen für Datumsformate definieren
TODAY=$(date +%Y-%m-%d)
FILE_DATE=$(date +%Y%m%d)

# Zielverzeichnis sicherstellen
TARGET_DIR="$HOME/history_logs"
mkdir -p "$TARGET_DIR"

# Historie filtern: Extrahiert alle Einträge des heutigen Tages
history | grep " $TODAY " > "$TARGET_DIR/rockyHis${FILE_DATE}.txt"
```

### Zeitgesteuerte Ausführung via Crontab

Um das Skript werktäglich (Montag bis Freitag) um 15:30 Uhr auszuführen, wird ein entsprechender Eintrag in der Crontab benötigt.

Crontab öffnen:

```Bash
crontab -e
```

Cronjob hinzufügen:

```Bash
# Ausführung von Montag bis Freitag um 15:30 Uhr
30 15 * * 1-5 /home/scripts/historyscript.sh
```

## 🧠 Wissenstest: Cron & Zeitsteuerung

Hier sind typische Fragen rund um zeitgesteuerte Jobs unter Linux:

<details>
<summary><b>Fragen zu Cron-Syntax & Verwaltung</b> (Klicken zum Ausklappen)</summary>

1. **In welcher Reihenfolge sind die fünf Zeitfelder in einer Crontab angeordnet?**
   <details><summary>Antwort</summary>Die Reihenfolge von links nach rechts lautet:  
   1. **Minute** (0-59)  
   1. **Stunde** (0-23)  
   1. **Tag des Monats** (1-31)  
   1. **Monat** (1-12)  
   1. **Wochentag** (0-7, wobei 0 und 7 für Sonntag stehen)</details>

1. **Was bewirkt der Eintrag `*/15 9-17 * * 1-5`?**
   <details><summary>Antwort</summary>Der Cronjob wird **alle 15 Minuten** (`*/15`) zwischen den Stunden **9:00 und 17:59 Uhr** (`9-17`) von **Montag bis Freitag** (`1-5`) ausgeführt.</details>

1. **Mit welchem Befehl löscht man seine gesamte persönliche Crontab ohne Nachfrage?**
   <details><summary>Antwort</summary>Mit dem Befehl **`crontab -r`** (Remove). Da dies ohne Sicherheitsabfrage geschieht, ist hierbei äußerste Vorsicht geboten!</details>

</details>

<details>
<summary><b>Fragen zu Fehlerbehebung & Umgebung</b> (Klicken zum Ausklappen)</summary>

1. **Warum schlagen Skripte in Cronjobs oft fehl, obwohl sie im interaktiven Terminal fehlerfrei laufen?**
   <details><summary>Antwort</summary>Cron-Prozesse laufen in einer extrem minimalistischen Umgebung ohne interaktive Shell. Die Umgebungsvariable `$PATH` enthält meist nur `/usr/bin:/bin`, weshalb Programme in `/usr/local/bin` oder `/opt` nicht gefunden werden. Zudem sind relative Pfade ungültig, da das Arbeitsverzeichnis standardmäßig das Home-Verzeichnis des Benutzers ist.  
   _Lösung:_ Stets absolute Pfade im Skript und im Cronjob verwenden.</details>

1. **Wie unterscheidet sich der Dienstname für den Cron-Daemon zwischen Debian- und Red-Hat-basierten Distributionen?**
   <details><summary>Antwort</summary>Unter Debian-basierten Systemen (z. B. Ubuntu) heißt der Dienst **`cron`**. Unter Red-Hat-basierten Systemen (z. B. Rocky Linux, RHEL) heißt der Dienst **`crond`**.</details>

</details>

## 🔗 8. Zurück zur Übersicht

[⬅ Zurück zur Übersicht](../README.md)

---

*Erstellt am 20. Mai 2026 für den Linux-Essentials Kurs.*
