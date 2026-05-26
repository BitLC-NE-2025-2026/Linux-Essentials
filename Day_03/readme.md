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
> Nach Änderungen an der `.bashrc` muss diese neu eingelesen werden: `source ~/.bashrc`.

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

### xargs

Übergibt die Ausgabe eines Befehls als Argumente an einen anderen Befehl.

```bash
find -name "*.old" | xargs rm     # Löscht alle gefundenen .old Dateien
```

## 🧠 Wissenstest: CUPS, Aliases & I/O-Umleitung

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

## 🔗 Zurück zum Hauptmenü

[⬅ Zurück zur Übersicht](../README.md)

---

*Erstellt am 06. Mai 2026 für den Linux-Essentials Kurs.*
