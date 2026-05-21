# ⏱️ Linux Essentials Tag 12

![Linux Essentials Day 12 Header](./header.png)

Am zwölften Tag der Linux Essentials behandeln wir die zeitgesteuerte Ausführung von Befehlen. Wir konzentrieren uns auf cron, cronjobs und die crontab. Diese Werkzeuge automatisieren wiederkehrende Aufgaben im System.

---

## 📑 Inhaltsverzeichnis

* [Lernziele LPIC-1 relevant](#-lernziele-lpic-1-relevant)
* [Grundlagen zu cron und crontab](#-1-grundlagen-zu-cron-und-crontab)
* [Aufbau einer Crontab](#-2-aufbau-einer-crontab)
* [Crontab Befehle und Editor Konfiguration](#-3-crontab-befehle-und-editor-konfiguration)
* [Ressourcen und Hilfsmittel](#-ressourcen-und-hilfsmittel)
* [Zurück zur Übersicht](#-zurück-zur-übersicht)

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

---

## 🏗️ 2. Aufbau einer Crontab

Eine crontab Zeile besteht aus fünf Zeitfeldern und dem auszuführenden Befehl. Die Felder werden durch Leerzeichen getrennt.

Syntaxfolge:
`Minute Stunde Tag Monat Wochentag Befehl`

Wertebereiche der Felder:
* Minute: 0 bis 59
* Stunde: 0 bis 23
* Tag des Monats: 1 bis 31
* Monat: 1 bis 12
* Wochentag: 0 bis 7. Dabei sind 0 und 7 der Sonntag.

Sonderzeichen:
* `*` steht für jeden möglichen Wert.
* `,` trennt Einzelwerte wie 1,15,30.
* `/` definiert Intervalle wie */5 für alle 5 Minuten.

Beispiel für einen cronjob jeden Tag um 04:30 Uhr:
`30 4 * * * /pfad/zum/skript.sh`

---

## ⌨️ 3. Crontab Befehle und Editor Konfiguration

Zur Verwaltung der eigenen cronjobs nutzt man den Befehl crontab im Terminal.

Befehle:
* `crontab -e`: Öffnet die crontab zum Bearbeiten.
* `crontab -l`: Listet alle aktiven cronjobs auf.
* `crontab -r`: Löscht die aktuelle crontab vollständig.

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

## 📚 4. Ressourcen und Hilfsmittel
Die Definition der korrekten Zeiten ist fehleranfällig.
Die Webseite crontab.guru übersetzt die Cron Syntax in lesbaren Text und hilft bei der Erstellung komplexer Intervalle.

- Link: [crontab.guru/](https://crontab.guru/)

---

## 🔗 5. Zurück zur Übersicht
⬅ Zurück zur Übersicht

Erstellt am 20. Mai 2026 für den Linux-Essentials Kurs.
