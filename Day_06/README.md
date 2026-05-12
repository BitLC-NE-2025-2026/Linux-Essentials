# 📑 Day 06: Administration, Prozesse & Spezialrechte

---

## 🎯 Lernziele für heute
* Verstehen des Linux-Prozessmodells und der Prozess-Hierarchie.
* Beherrschen von Monitoring-Tools (`top`, `htop`, `pstree`).
* Steuern von Prozessen via Signale und Job-Control.
* Grundlagen der Prozess-Priorisierung (`nice`, `renice`).
* Verständnis und Identifikation von Spezialrechten (SUID, SGID, Sticky Bit).

---

## 🛠 1. Prozess-Monitoring & Identifikation

Linux verwaltet Aufgaben in Form von **Prozessen**. Jeder Prozess hat eine eindeutige **PID** (Process ID).

### Wichtige Werkzeuge:
* `ps`: Momentaufnahme der aktuellen Prozesse.
    * `ps aux`: Umfassende Liste aller Prozesse im System.
    * `ps -ef`: Standard-Format mit PPID (Parent Process ID).
* `pstree -p`: Visualisiert die Prozess-Hierarchie als Baumstruktur (inkl. PIDs).
* `top`: Interaktiver Echtzeit-Monitor.
* `htop`: Moderne, farbige Alternative zu `top`.
* `btop`: Hochgradig visuelle und informative Monitor-Alternative.

> [!TIP]
> In `htop` und `btop` kannst du mit den Pfeiltasten navigieren und Prozesse direkt per Funktionstasten (z.B. F9 für Kill) verwalten.

---

## 🚦 2. Job Control: Prozesse im Griff

Prozesse können im Vordergrund (**Foreground**) oder Hintergrund (**Background**) laufen.

| Befehl / Kürzel | Wirkung |
| :--- | :--- |
| `befehl &` | Startet den Befehl direkt im Hintergrund. |
| `Strg + Z` | Pausiert den aktuellen Vordergrund-Prozess (Signal: SIGSTOP). |
| `jobs` | Listet alle aktiven Jobs der aktuellen Shell auf. |
| `fg %1` | Holt Job Nr. 1 in den Vordergrund. |
| `bg %1` | Lässt einen pausierten Job im Hintergrund weiterlaufen. |

---

## 💀 3. Signale & Priorisierung

### Signale senden mit `kill`
Mit `kill` werden Signale an Prozesse gesendet (nicht immer zum "Töten").
* `kill -15 (SIGTERM)`: Freundliche Aufforderung zum Beenden (Standard).
* `kill -9 (SIGKILL)`: Sofortiges, erzwungenes Beenden (kein Cleanup möglich).
* `kill -19 (SIGSTOP)`: Prozess pausieren.
* `kill -18 (SIGCONT)`: Pausierten Prozess fortsetzen.

### Prioritäten (`nice` & `renice`)
Der Kernel entscheidet, wie viel CPU-Zeit ein Prozess erhält. Dies wird über den **Nice-Wert** gesteuert (-20 bis 19).
* **Niedriger Wert (z.B. -5):** Hohe Priorität (Prozess ist "weniger nett").
* **Hoher Wert (z.B. 10):** Niedrige Priorität (Prozess ist "sehr nett").

```bash
nice -n 10 befehl     # Startet Befehl mit niedrigerer Prio
sudo renice -n -5 1234 # Ändert Prio von PID 1234 auf höher (Root erforderlich)
```

---

## 🔒 4. Spezialrechte (Special Permissions)

Zusätzlich zu `rwx` gibt es drei Spezialbits, die für die Systemsicherheit kritisch sind.

| Bit | Symbol | Wirkung | Beispiel |
| :--- | :--- | :--- | :--- |
| **SUID** | `s` (User) | Führt Datei mit Rechten des Besitzers aus. | `/usr/bin/passwd` |
| **SGID** | `s` (Group) | Führt Datei mit Rechten der Gruppe aus / Vererbung bei Verzeichnissen. | Kollaborations-Ordner |
| **Sticky Bit** | `t` (Others) | Nur der Besitzer darf seine eigenen Dateien löschen. | `/tmp` |

### Suchen & Setzen von Spezialrechten:
* **Suchen:**
  ```bash
  find / -perm -4000 2>/dev/null # Findet SUID-Dateien
  find / -perm -2000 2>/dev/null # Findet SGID-Dateien
  find / -perm -1000 2>/dev/null # Findet Sticky-Bit-Verzeichnisse
  ```
* **Setzen (Oktal):**
  Den Standard-Rechten wird eine vierte Ziffer vorangestellt:
  * `chmod 4755 datei` -> SUID
  * `chmod 2775 ordner` -> SGID
  * `chmod 1777 ordner` -> Sticky Bit

---

## 📝 Praktische Übungen (Day 06)

1. **Software-Installation:** Installiere das EPEL-Repository und danach `htop` sowie `btop`.
   ```bash
   sudo dnf install epel-release
   sudo dnf install htop btop
   ```
2. **Hintergrund-Management:** Starte `sleep 100 &`, schicke es in den Vordergrund und beende es.
3. **Prioritäten:** Starte einen Prozess mit `nice` und ändere die Priorität nachträglich mit `renice`.
4. **Sicherheits-Check:** Identifiziere alle Dateien im System, die das SUID-Bit gesetzt haben.

---

*Letztes Update: 11. Mai 2026*
