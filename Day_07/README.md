# 📦 Linux Essentials - Tag 07: Archivierung, Kompression & Software-Builds (LPIC-1 Fokus)

![Linux Essentials Header](./header.png)

Dieses Modul deckt zentrale Themen der LPIC-1 Prüfung (LPI-101) ab, insbesondere die Lernziele 103.3 (Archivierung/Kompression) und 103.5 (Prozess-Management).

---

## 📑 Inhaltsverzeichnis
- [🎯 Lernziele (LPIC-1 relevant)](#-lernziele-lpic-1-relevant)
- [📂 1. Archivierung: tar, cpio & dd](#-1-archivierung-tar-cpio--dd)
  - [A. Der Standard: tar (Tape Archiver)](#a-der-standard-tar-tape-archiver)
  - [B. Die Alternative: cpio](#b-die-alternative-cpio)
  - [C. Bit-für-Bit: dd (Data Duplicator)](#c-bit-für-bit-dd-data-duplicator)
- [🗜 2. Kompression & Transparenter Zugriff](#-2-kompression--transparenter-zugriff)
- [🛠 3. Software-Builds & Shared Libraries](#-3-software-builds--shared-libraries)
  - [Der Build-Workflow (Modern vs. Klassisch)](#der-build-workflow-modern-vs-klassisch)
  - [Shared Libraries prüfen (ldd)](#shared-libraries-prüfen-ldd)
- [🚦 4. Prozess-Management & Signal-Referenz](#-4-prozess-management--signal-referenz)
  - [Die essenzielle Signal-Tabelle](#die-essenzielle-signal-tabelle)
  - [Zombies & Exit-Status](#zombies--exit-status)
- [📝 LPIC-Übungsszenarien (Day 07)](#-lpic-übungsszenarien-day-07)
- [🧠 Wissenstest: Archivierung, Kompression & Builds](#-wissenstest-archivierung-kompression--builds)

---

## 🎯 Lernziele (LPIC-1 relevant)
*   **Archivierung:** `tar`, `cpio` und `dd` sicher beherrschen.
*   **Kompression:** Algorithmen-Vergleich und die `*cat`-Werkzeuge.
*   **Build-Management:** Kompilierung von Quellcode und Umgang mit Shared Libraries (`ldd`).
*   **Signale & Prioritäten:** Vollständige Signal-Tabelle und Prozess-Hierarchien (Zombies).

---

## 📂 1. Archivierung: tar, cpio & dd

### A. Der Standard: `tar` (Tape Archiver)
LPIC verlangt das Verständnis der Flags ohne führendes Bindestrich (BSD-Stil) und mit Bindestrich (GNU-Stil).

| Flag | Langform | Beschreibung |
| :--- | :--- | :--- |
| `c` | `--create` | Neues Archiv erstellen. |
| `x` | `--extract` | Archiv entpacken. |
| `t` | `--list` | Inhalt auflisten. |
| `u` | `--update` | Nur Dateien hinzufügen, die neuer als im Archiv sind. |
| `r` | `--append` | Dateien bedingungslos anhängen. |
| `v` | `--verbose` | Fortschritt anzeigen. |
| `f` | `--file` | Dateiname (muss zwingend als letztes Flag stehen). |
| `p` | `--preserve-permissions` | Erhält die ursprünglichen Dateirechte (Standard für Root). |

**Profi-Befehle:**
```bash
# Archiv inkrementell aktualisieren
tar -uf backup.tar ./Dokumente

# Nur Dateien extrahieren, die nach einem Datum geändert wurden
tar -N '2026-05-01' -xf backup.tar
```

### B. Die Alternative: `cpio`
`cpio` liest Dateilisten von `stdin`. Häufig in Kombination mit `find`.
*   **Copy-out (Archiv erstellen):** `find . -name "*.txt" | cpio -ov > archiv.cpio`
*   **Copy-in (Entpacken):** `cpio -iv < archiv.cpio`

### C. Bit-für-Bit: `dd` (Data Duplicator)
Wird für Backups ganzer Partitionen oder zum Erstellen von ISOs genutzt.
```bash
dd if=/dev/sda of=/pfad/zu/disk.img bs=4M conv=noerror,sync
```
*   `if`/`of`: Input/Output File.
*   `bs`: Blocksize (beschleunigt den Prozess).
*   `conv=noerror`: Fährt bei Lesefehlern fort.

---

## 🗜 2. Kompression & Transparenter Zugriff

LPIC legt Wert auf die Werkzeuge, die den Inhalt komprimierter Dateien anzeigen, ohne sie permanent zu entpacken.

| Algorithmus | Tool | Decompress | View Content |
| :--- | :--- | :--- | :--- |
| **Gzip** | `gzip` | `gunzip` | `zcat`, `zless` |
| **Bzip2** | `bzip2` | `bunzip2` | `bzcat`, `bzless` |
| **XZ** | `xz` | `unxz` | `xzcat`, `xzless` |

**Beispiel für LPIC:**
"Wie lesen Sie eine `.gz`-Logdatei, ohne sie zu entpacken?"
👉 `zcat /var/log/syslog.gz | less`

---

## 🛠 3. Software-Builds & Shared Libraries

Wenn Software gebaut wird (`meson`, `make`), müssen auch die Bibliotheks-Abhängigkeiten stimmen.

### Der Build-Workflow (Modern vs. Klassisch)
1.  **Meson (Modern):** `meson setup build` -> `meson compile -C build`
2.  **Autotools (Klassisch):** `./configure` -> `make` -> `sudo make install`

### Shared Libraries prüfen (`ldd`)
Jedes Binary benötigt Bibliotheken. LPIC-Thema: "Was tun, wenn ein Programm nicht startet?"
```bash
ldd /usr/local/bin/glmark2
```
*   Zeigt alle geladenen `.so`-Dateien (Shared Objects).
*   Falls eine fehlt: "not found".

---

## 🚦 4. Prozess-Management & Signal-Referenz

### Die essenzielle Signal-Tabelle
| ID | Name | Beschreibung |
| :--- | :--- | :--- |
| **1** | `SIGHUP` | Hangup (Reload von Konfigurationsdateien). |
| **2** | `SIGINT` | Interrupt (Strg+C). |
| **9** | `SIGKILL` | Sofortiges Beenden (nicht abfangbar). |
| **15** | `SIGTERM` | Terminierung (sauberes Beenden, Standard). |
| **17** | `SIGCHLD` | Kind-Prozess beendet oder pausiert (relevant für Zombies). |
| **18** | `SIGCONT` | Pausierten Prozess fortsetzen. |
| **19** | `SIGSTOP` | Prozess pausieren (nicht abfangbar). |

### Zombies & Exit-Status
Ein Zombie entsteht, wenn der Parent das Signal `SIGCHLD` nicht korrekt verarbeitet (kein `wait()` System-Call).
*   **Exit Status:** Mit `echo $?` kann der Exit-Status des letzten Kommandos geprüft werden (0 = Erfolg).

---

## 📝 LPIC-Übungsszenarien (Day 07)

1.  **Szenario Archivierung:** Erstellen Sie ein mit `bzip2` komprimiertes Archiv des Verzeichnisses `/etc`, aber schließen Sie alle Dateien aus, die auf `.conf` enden (`--exclude`).
2.  **Szenario Filter:** Nutzen Sie `find` und `cpio`, um alle Dateien in `/home`, die dem User `student` gehören, in ein Archiv zu kopieren.
3.  **Szenario Troubleshooting:** Ein selbst kompiliertes Programm startet nicht. Nutzen Sie `ldd`, um herauszufinden, welche Bibliothek fehlt.
4.  **Szenario Signale:** Schicken Sie einem Prozess erst das Signal 19 (`SIGSTOP`) und reaktivieren Sie ihn anschließend mit Signal 18 (`SIGCONT`).

---

## 🧠 Wissenstest: Archivierung, Kompression & Builds
Hier sind typische Prüfungsfragen und Szenarien zum LPIC-1 Fokus:

<details>
<summary><b>Fragen zu Archivierung & Kompression</b> (Klicken zum Ausklappen)</summary>

1. **Was ist der Unterschied zwischen `tar -czf` und `tar -cjf`?**
   <details><summary>Antwort</summary>**`-czf`** komprimiert das Archiv mit **gzip** (schneller, aber größere Datei). **`-cjf`** komprimiert das Archiv mit **bzip2** (langsamer, aber bessere Kompressionsrate).</details>

2. **Wie kann man mit `tar` ein Archiv entpacken, ohne dessen relative Struktur zu verändern?**
   <details><summary>Antwort</summary>Standardmäßig entpackt `tar -xf` die Dateien in das aktuelle Arbeitsverzeichnis unter Beibehaltung der relativen Pfade des Archivs.</details>

3. **Wie unterscheidet sich `xz` von `gzip` und `bzip2`?**
   <details><summary>Antwort</summary>`xz` basiert auf dem LZMA-Algorithmus. Es bietet die mit Abstand beste Kompressionsrate (sehr kleine Dateien) und schnelles Entpacken, benötigt beim Komprimieren jedoch deutlich mehr Arbeitsspeicher und Rechenzeit.</details>

</details>

<details>
<summary><b>Fragen zu Shared Libraries & Builds</b> (Klicken zum Ausklappen)</summary>

4. **Welche Aufgabe hat der Befehl `ldd`?**
   <details><summary>Antwort</summary>Er analysiert ein ausführbares Programm (oder eine andere Bibliothek) und listet alle dynamisch gelinkten Shared Libraries (`.so`-Dateien) auf, die das Programm zur Ausführung benötigt.</details>

5. **Welche klassischen Schritte gehören zu einem Autotools-basierten Software-Build?**
   <details><summary>Antwort</summary>1. **`./configure`** (prüft das System auf Abhängigkeiten und erstellt das Makefile).  
2. **`make`** (kompiliert den Quellcode zu Binaries).  
3. **`sudo make install`** (kopiert die Binaries und Ressourcen in die Systemverzeichnisse).</details>

</details>

---

*Letztes Update: 26. Mai 2026 für den Linux-Essentials Kurs.*
