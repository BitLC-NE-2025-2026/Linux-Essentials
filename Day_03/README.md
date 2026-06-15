# 🖨️ Linux Essentials - Tag 03

![Linux Essentials Day 03 Header](./header.png)

Am dritten Tag haben wir uns mit der Systemkonfiguration, dem Drucksystem CUPS und fortgeschrittenen Shell-Techniken wie Aliases, Umgebungsvariablen und komplexen I/O-Umleitungen beschäftigt.

---

## 📑 Inhaltsverzeichnis

- [Drucken mit CUPS](#️-drucken-mit-cups)
- [Shell-Konfigurationsdateien](#️-shell-konfigurationsdateien)
- [Aliases & Funktionen](#-aliases--funktionen)
- [Umgebungsvariablen](#-umgebungsvariablen)
- [Fortgeschrittene I/O-Umleitung](#-fortgeschrittene-io-umleitung)
- [Suchen & Verarbeiten (find & xargs)](#-suchen--verarbeiten-find--xargs)
- [Zurück zum Hauptmenü](#-zurück-zum-hauptmenü)

---

## 🖨️ Drucken mit CUPS

Das **Common UNIX Printing System (CUPS)** ist der Standard für Druckdienste unter Linux.

### Wichtige Befehle

| Befehl | Funktion |
| :--- | :--- |
| `systemctl status cups` | Prüft, ob der Druckdienst läuft. |
| `lpstat -t` | Zeigt den gesamten Status des Drucksystems (Drucker, Jobs, Server). |
| `lp -d <Drucker> <Datei>` | Sendet eine Datei an einen spezifischen Drucker. |
| `lpq -P <Drucker>` | Zeigt die Warteschlange eines Druckers an. |
| `lpstat -p` | Listet alle verfügbaren Drucker auf. |

---

## ⚙️ Shell-Konfigurationsdateien

Wo werden Einstellungen dauerhaft gespeichert? Es gibt einen Unterschied zwischen systemweiten und benutzerspezifischen Dateien.

- **Systemweit (für alle User):** `/etc/profile`, `/etc/bashrc`.
- **Benutzerspezifisch:** `~/.bashrc`, `~/.bash_profile`.

> [!TIP]
> Nach Änderungen an der `.bashrc` muss diese neu eingelesen werden: `source ~/.bashrc` (oder `. ~/.bashrc`).

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - Shell-Startup-Dateien Sequence:**  
> Bei einer **Login-Shell** (z.B. SSH-Anmeldung oder GUI-Login) wird folgende Reihenfolge eingehalten:  
> 1. **`/etc/profile`** (systemweit) wird als erstes ausgeführt.  
> 2. Die erste gefundene benutzerspezifische Datei: **`~/.bash_profile`**, falls nicht vorhanden **`~/.bash_login`**, falls nicht vorhanden **`~/.profile`**.  
> Bei einer **Non-Login-Shell** (z.B. Öffnen eines Terminal-Fensters in der GUI oder Starten einer Subshell) wird diese Datei geladen:  
> 1. **`~/.bashrc`** (benutzerspezifisch), welche meist ihrerseits die systemweite **`/etc/bashrc`** (oder `/etc/bash.bashrc` auf Debian) einliest.  
> Beachten Sie: Ein `export` von Umgebungsvariablen wird typischerweise in `~/.bash_profile` vorgenommen, während interaktive Elemente wie Aliase in `~/.bashrc` abgelegt werden.

---

## 🚀 Aliases & Funktionen

Machen Sie sich das Leben leichter, indem Sie lange Befehle abkürzen oder eigene Logik definieren.

### Aliases

```bash
alias la='ls -al'           # Erstellt einen temporären Alias
unalias la                  # Entfernt den Alias wieder
```

*Um Aliase dauerhaft zu machen, müssen sie in die `~/.bashrc` eingetragen werden.*

### Funktionen

Einfache Skripte direkt in der Shell:

```bash
hallo() { 
    echo "Herzlich Willkommen!"
    echo "Hallo $USER"
}
```

---

## 🌍 Umgebungsvariablen

Variablen speichern Informationen, auf die Programme zugreifen können.

- `printenv`: Zeigt alle Umgebungsvariablen an.
- `echo $PATH`: Zeigt die Liste der Verzeichnisse, in denen nach Befehlen gesucht wird.
- `env`: Listet Variablen auf oder führt Programme in einer modifizierten Umgebung aus.

**Wichtige Variablen:**

- `$USER`: Der aktuelle Benutzer.
- `$HOME`: Das Heimatverzeichnis.
- `$SHELL`: Die Standard-Shell.

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - export & env:**  
> * **Lokale Shell-Variable:** `MYVAR="test"` ist nur in der aktuellen Shell-Instanz sichtbar. Ein gestartetes Skript oder Programm (Kindprozess) sieht diese Variable **nicht**.  
> * **Umgebungsvariable (Environment Variable):** **`export MYVAR`** (oder `export MYVAR="test"`) vererbt die Variable an alle Kindprozesse.  
> * **`set` vs. `env` / `printenv`:**  
>   * `set` zeigt alle Variablen (sowohl lokale Shell-Variablen als auch Umgebungsvariablen) und Shell-Funktionen an.  
>   * `env` / `printenv` zeigen **ausschließlich** exportierte Umgebungsvariablen an.  
> * **`unset <Variable>`** entfernt eine Variable komplett aus dem Speicher.

---

## 🔄 Fortgeschrittene I/O-Umleitung

Wir vertiefen das Wissen über Datenströme (`stdin`, `stdout`, `stderr`).

| Operator | Funktion |
| :---: | :--- |
| `2>` | Leitet nur Fehlermeldungen (stderr) in eine Datei um. |
| `2>>` | Hängt Fehlermeldungen an eine Datei an. |
| `2> /dev/null` | "Verschluckt" Fehlermeldungen (sehr nützlich bei `find`). |
| `&>` | Leitet sowohl stdout als auch stderr in dasselbe Ziel um. |

---

## 🔍 Suchen & Verarbeiten (find & xargs)

Dateien finden und direkt Aktionen darauf ausführen.

### find

- `find . -name "dat*"`: Findet Dateien, die mit "dat" beginnen.
- `find / -perm 755 2> /dev/null`: Findet Dateien mit spezifischen Rechten und ignoriert Fehlermeldungen.

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - find & -exec:**  
> Der Befehl `find` kann direkt auf den gefundenen Dateien Aktionen ausführen, ohne eine Pipe zu verwenden, indem man das Argument **`-exec`** nutzt:  
> ```bash
> find /home -user student -type f -exec chmod 644 {} \;
> ```
> * **`{}`** dient als Platzhalter für die jeweils gefundene Datei.  
> * **`\;`** (escapetes Semikolon) schließt den auszuführenden Befehl ab.  
> * **`-type f`** filtert nach regulären Dateien (während `-type d` nach Ordnern und `-type l` nach symbolischen Links filtert).  
> * **`-mtime -7`** sucht nach Dateien, die in den letzten 7 Tagen modifiziert wurden.  
> * **`-size +100M`** sucht nach Dateien, die größer als 100 Megabyte sind.  

### xargs

Übergibt die Ausgabe eines Befehls als Argumente an einen anderen Befehl.

```bash
find -name "*.old" | xargs rm     # Löscht alle gefundenen .old Dateien
```

> [!TIP]  
> Falls Dateinamen Leerzeichen enthalten, bricht `xargs` ab. Nutzen Sie dann Null-Byte Trenner:  
> `find . -name "*.txt" -print0 | xargs -0 rm` (dies trennt Dateinamen durch ein Null-Byte, was sicher gegen Sonderzeichen ist).

## 🔑 Keywords

| Keyword / Befehl | Erklärung |
| :--- | :--- |
| `pwd` | Print Working Directory: Zeigt den absoluten Pfad des aktuellen Standorts an. |
| `cd` | Change Directory: Wechselt das aktuelle Arbeitsverzeichnis in der Shell. |
| `cp -a` | Archiv-Modus beim Kopieren: Kopiert rekursiv unter Beibehaltung aller Rechte, Besitzer und Links. |
| `rm -rf` | Löscht Dateien und Verzeichnisse rekursiv, ohne Nachfragen und unumgänglich. |
| `ln -s` | Erstellt einen symbolischen Link (Softlink), der als Pfad-Referenz auf eine Datei oder einen Ordner zeigt. |

---

## 🧠 LPIC-1 Relevanz & Wissenstest

Hier sind typische Fragen zur Vertiefung des heutigen Stoffs:

<details>
<summary><b>Fragen zu Shell-Konfiguration & Variablen</b> (Klicken zum Ausklappen)</summary>

1. **Was ist der Unterschied zwischen `/etc/profile` und `~/.bashrc`?**
   <details><summary>Antwort</summary>**`/etc/profile`** ist eine systemweite Konfigurationsdatei, die beim ersten Login eines Benutzers ausgeführt wird. **`~/.bashrc`** ist eine benutzerspezifische Datei, die bei jedem Öffnen eines neuen interaktiven (Non-Login) Terminals ausgeführt wird.</details>

2. **Mit welchem Befehl lässt sich die Liste aller aktuell gesetzten Umgebungsvariablen anzeigen?**
   <details><summary>Antwort</summary>Das kann mit dem Befehl **`printenv`** (oder kurz **`env`**) geschehen.</details>

3. **Wie macht man einen erstellten Alias dauerhaft für zukünftige Terminalsitzungen haltbar?**
   <details><summary>Antwort</summary>Man muss die `alias`-Zeile am Ende der Datei **`~/.bashrc`** (bzw. `~/.zshrc` bei Zsh) eintragen und speichern. Danach führt man `source ~/.bashrc` aus, um sie sofort zu aktivieren.</details>

</details>

<details>
<summary><b>Fragen zu I/O-Umleitung & Pipelines</b> (Klicken zum Ausklappen)</summary>

1. **Wie leitet man sowohl Fehlermeldungen (stderr) als auch Standardausgaben (stdout) in dieselbe Logdatei um?**
   <details><summary>Antwort</summary>Mit dem Operator **`&>`** (z. B. `befehl &> ausgabe.log`). Alternativ geht auch der klassische weg: `befehl > ausgabe.log 2>&1`.</details>

2. **Wozu dient das Werkzeug `xargs`?**
   <details><summary>Antwort</summary>Es nimmt Datenströme von der Standardeingabe (`stdin`) und wandelt sie in Argumente für den nachfolgenden Befehl um. Dies wird oft verwendet, um Ergebnisse von `find` an Befehle wie `rm` oder `grep` zu übergeben (z. B. `find . -name "*.log" | xargs rm`).</details>

</details>

---

## 📚 Ressourcen & Dokumente

Im [Assets](./assets)-Verzeichnis finden Sie weiterführende Informationen:

- [CUPS & Konfiguration (PDF)](./assets/LinuxCUPS_KonfigDat_Alias_IO-Op.pdf)
- [Historie Tag 03 (TXT)](./assets/rockyHis20260506-1548.txt)

---
## 🔗 Zurück zur Übersicht

* **Tag 02 (Die Linux-Philosophie & FHS):** [⬅️ Tag 02](../Day_02/README.md)
* **Tag 04 (Textmanipulation & Filter):** [➡️ Tag 04](../Day_04/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
