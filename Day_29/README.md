# 🐧 LPIC-1 Simulation 101 — Tag 29

![Linux Essentials Day 29 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 100% Dokumentiert & LPIC-1 Fokussiert  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📑 Inhaltsverzeichnis
- [📖 Themenübersicht](#-themenübersicht)
- [🧠 LPIC-1 Relevanz & Wissenstest](#-lpic-1-relevanz--wissenstest)
- [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

---

## 📖 Themenübersicht

## 📝 1. Fokus und Aufbau von Exam 101
Die LPIC-1 Prüfung 101-500 deckt die Systemarchitektur, die Linux-Installation, die Paketverwaltung sowie GNU/Unix-Befehle und Dateisysteme ab.
* Zeit: 90 Minuten für 60 Fragen.
* Bestehensgrenze: Ca. 500 von 800 Punkten.

## 💡 2. Die wichtigsten Prüfungsschwerpunkte
* **GNU- und Unix-Befehle:** Filterung (`grep`, `sed`, `awk`), Dateimanagement und Pipelining.
* **Systemarchitektur:** Kernel-Module, Bootloader-Interaktionsmöglichkeiten und systemd-Initialisierung.
* **Paketverwaltung:** Detaillierte Kenntnis der Befehle für `dpkg`, `apt`, `rpm` und `dnf`.
* **Dateisysteme & FHS:** Mount-Optionen, `/etc/fstab` Syntax und LVM-Verwaltung.

---

## 🧠 LPIC-1 Relevanz & Wissenstest

<details>
<summary><b>Fragen zu LPIC-1 Simulation 101 (Klicken zum Ausklappen)</b></summary>

1. **Aus wie vielen Fragen besteht die LPIC-1 Prüfung (101-500) und wie viel Zeit hat man?**
   <details><summary>Antwort</summary>Die Prüfung besteht aus 60 Fragen (Single-Choice, Multiple-Choice und Lückentexte), für die man 90 Minuten Zeit hat.</details>

2. **Was ist der Unterschied zwischen Kaltstart- (Coldplug) und Warmstart-Geräten (Hotplug)?**
   <details><summary>Antwort</summary>**Coldplug-Geräte** müssen vor dem Systemstart eingebaut sein (z.B. CPU, RAM). **Hotplug-Geräte** können im laufenden Betrieb angeschlossen und erkannt werden (z.B. USB-Festplatten).</details>

3. **Wie lässt sich ein Root-Passwort über den GRUB2-Bootloader zurücksetzen?**
   <details><summary>Antwort</summary>Indem man den Booteintrag editiert, `init=/bin/bash` (oder `systemd.unit=rescue.target`) an die Kernel-Zeile anhängt, bootet und das Dateisystem beschreibbar remountet (`mount -o remount,rw /`).</details>

4. **Welcher Befehl aktualisiert die Datenbank für den Schnellfindungs-Befehl `locate`?**
   <details><summary>Antwort</summary>Der Befehl `updatedb` (wird meist als root ausgeführt).</details>

5. **Welche drei Zeitstempel besitzt jede Datei im Linux-Dateisystem?**
   <details><summary>Antwort</summary>**Access Time** (atime - letzter Lesezugriff), **Modification Time** (mtime - letzte Inhaltsänderung) und **Change Time** (ctime - letzte Metadatenänderung wie Rechte/Besitzer).</details>

</details>

---

## 🔗 Zurück zur Übersicht

* **Tag 28 (Kryptographie & MTAs):** [⬅️ Tag 28](../Day_28/README.md)
* **Tag 30 (LPIC-1 Simulation 102):** [➡️ Tag 30](../Day_30/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
