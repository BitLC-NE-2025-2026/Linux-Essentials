# 🐧 Linux Essentials - Tag 05

![Linux Essentials Header](./header.png)

Heute vertiefen wir unser Wissen über die Sicherheit und Verwaltung von Dateien. Wir schauen uns an, wie man präzise Berechtigungen setzt, Standardvorgaben mit `umask` anpasst, die Shell-Historie optimiert und wie Links (Hard & Soft) unter Linux funktionieren.

---

## 📑 Inhaltsverzeichnis

- [🐧 Linux Essentials - Tag 05](#-linux-essentials---tag-05)
  - [📑 Inhaltsverzeichnis](#-inhaltsverzeichnis)
  - [🔐 Dateirechte & Berechtigungen](#-dateirechte--berechtigungen)
    - [Die drei Säulen der Berechtigung](#die-drei-säulen-der-berechtigung)
    - [chmod: Symbolischer vs. Numerischer Modus](#chmod-symbolischer-vs-numerischer-modus)
  - [📁 Verzeichnis-Berechtigungen](#-verzeichnis-berechtigungen)
  - [🕵️‍♂️ Fortgeschrittene Rechte (ACL & umask)](#️️-fortgeschrittene-rechte-acl--umask)
    - [umask: Standard-Berechtigungen](#umask-standard-berechtigungen)
    - [ACL: Access Control Lists](#acl-access-control-lists)
  - [📜 Shell-Historie Optimierung](#-shell-historie-optimierung)
  - [🔗 Links: Hardlinks & Softlinks](#-links-hardlinks--softlinks)
    - [Vergleich: Hard vs. Soft](#vergleich-hard-vs-soft)
  - [🧠 Wissenstest: Linux Grundlagen](#-wissenstest-linux-grundlagen)
  - [📚 Ressourcen & Dokumente](#-ressourcen--dokumente)

---

## 🔐 Dateirechte & Berechtigungen

In Linux ist jede Datei und jedes Verzeichnis mit einem Set von Berechtigungen verknüpft, die festlegen, wer lesen, schreiben oder ausführen darf.

### Die drei Säulen der Berechtigung

| Ebene | Symbol | Beschreibung |
| :--- | :---: | :--- |
| **User** | `u` | Der Besitzer der Datei. |
| **Group** | `g` | Mitglieder der Gruppe, der die Datei gehört. |
| **Others** | `o` | Alle anderen Benutzer im System. |

### chmod: Symbolischer vs. Numerischer Modus

Mit `chmod` (change mode) werden diese Rechte angepasst.

**1. Symbolischer Modus:**

- `chmod u+x <Datei>`: Fügt dem Besitzer das Ausführrecht hinzu.
- `chmod g-w <Datei>`: Entfernt der Gruppe das Schreibrecht.
- `chmod o=r <Datei>`: Setzt für andere exklusiv das Leserecht.

**2. Numerischer Modus (Oktal):**

Jedes Recht hat einen Wert: **4 (Read)**, **2 (Write)**, **1 (Execute)**.

| Wert | Rechte (rwx) | Beschreibung |
| :---: | :---: | :--- |
| **7** | `rwx` | Vollzugriff (4+2+1) |
| **6** | `rw-` | Lesen & Schreiben (4+2) |
| **5** | `r-x` | Lesen & Ausführen (4+1) |
| **4** | `r--` | Nur Lesen |
| **0** | `---` | Keine Rechte |

> [!EXAMPLE]
> `chmod 755 script.sh` setzt `rwxr-xr-x` (Besitzer alles, Rest nur Lesen/Ausführen).

---

## 📁 Verzeichnis-Berechtigungen

Berechtigungen verhalten sich bei Verzeichnissen etwas anders als bei Dateien:

- **r (Read):** Erlaubt das Auflisten des Inhalts (`ls`).
- **w (Write):** Erlaubt das Erstellen oder Löschen von Dateien im Verzeichnis.
- **x (Execute):** Erlaubt das "Betreten" des Verzeichnisses (`cd`). Ohne `x` kann man keine Informationen über die Dateien darin abrufen, selbst wenn man `r` hat.

---

## 🕵️‍♂️ Fortgeschrittene Rechte (ACL & umask)

### umask: Standard-Berechtigungen

Die `umask` definiert, welche Rechte bei der Erstellung einer neuen Datei **maskiert** (entzogen) werden.

- **Default (Dateien):** `666` minus `umask`.
- **Default (Ordner):** `777` minus `umask`.

| Befehl | Funktion |
| :--- | :--- |
| `umask` | Zeigt die aktuelle Maske an (z.B. `0022`). |
| `umask 002` | Setzt die Maske so, dass die Gruppe Schreibrechte behält. |

### ACL: Access Control Lists

Wenn die klassischen Rechte nicht ausreichen (z.B. Zugriff für einen zweiten, spezifischen User), nutzen wir ACLs.

- `getfacl <Datei>`: Zeigt die detaillierten Zugriffskontrolllisten an.
- `setfacl -m u:benutzer:rwx <Datei>`: Gewährt einem spezifischen Benutzer Rechte.

---

## 📜 Shell-Historie Optimierung

Die Bash speichert standardmäßig die letzten Befehle. Dies lässt sich konfigurieren:

- `$HISTSIZE`: Anzahl der Befehle, die im Arbeitsspeicher gehalten werden.
- `$HISTFILESIZE`: Anzahl der Befehle, die in der Datei `.bash_history` gespeichert werden.

**Dauerhafte Konfiguration in `.bashrc`:**

```bash
export HISTSIZE=10000
export HISTFILESIZE=20000
```

Anschließend die Konfiguration mit `source ~/.bashrc` neu laden.

---

## 🔗 Links: Hardlinks & Softlinks

Links sind Verweise auf Dateien im Dateisystem.

### Vergleich: Hard vs. Soft

| Feature | Hardlink | Softlink (Symlink) |
| :--- | :--- | :--- |
| **Befehl** | `ln <Ziel> <Link>` | `ln -s <Ziel> <Link>` |
| **Inode** | Identisch mit dem Ziel. | Eigene Inode. |
| **Dateisystem** | Muss auf derselben Partition liegen. | Kann über Partitionen hinweg zeigen. |
| **Verhalten bei Löschung** | Datei bleibt erhalten, solange ein Link existiert. | Link wird "tot" (Broken Link). |
| **Ordner** | Nicht für Verzeichnisse erlaubt. | Funktioniert für Verzeichnisse. |

> [!TIP]
> Mit `ls -il` können Sie die Inode-Nummern anzeigen lassen, um Hardlinks zu identifizieren.

---

## 🧠 Wissenstest: Linux Grundlagen

Hier sind einige Fragen aus den heutigen Unterlagen zum Selbsttest:

<details>
<summary><b>Fragen zur Anmeldung & Grundlagen</b> (Klicken zum Ausklappen)</summary>

1. **Was bedeutet „Linux ist case-sensitive“?**
   <details><summary>Antwort</summary>Es wird strikt zwischen Groß- und Kleinschreibung unterschieden. `Datei.txt` und `datei.txt` sind zwei unterschiedliche Dateien.</details>

2. **Was ist ein Multiuser-/Multitasking-System?**
   <details><summary>Antwort</summary>**Multiuser:** Mehrere Benutzer können gleichzeitig am System arbeiten. **Multitasking:** Das System kann mehrere Aufgaben (Prozesse) gleichzeitig oder in sehr schneller Folge abarbeiten.</details>

3. **Wie sieht die Standard-Prompt in der Shell aus?**
   <details><summary>Antwort</summary>Meist nach dem Schema: `[benutzer@hostname aktuelles_verzeichnis]$`. Das `$` steht für einen normalen Benutzer, ein `#` für den Administrator (root).</details>

</details>

<details>
<summary><b>Fragen zum Dateisystem & Navigation</b> (Klicken zum Ausklappen)</summary>

1. **Was ist das Wurzelverzeichnis in Linux?**
   <details><summary>Antwort</summary>Das Verzeichnis `/`. Es ist die oberste Ebene, von der alle anderen Verzeichnisse ausgehen.</details>

2. **Unterschied zwischen absolutem und relativem Pfad?**
   <details><summary>Antwort</summary>**Absolut:** Beginnt immer an der Wurzel `/` (z.B. `/home/user`). **Relativ:** Geht vom aktuellen Standort aus (z.B. `./dokumente` oder `../`).</details>

3. **Welcher Befehl zeigt das aktuelle Verzeichnis?**
   <details><summary>Antwort</summary>`pwd` (Print Working Directory).</details>

4. **Wie zeigt man alle Dateien inkl. versteckter an?**
   <details><summary>Antwort</summary>`ls -a` (oder `ls -al` für die Listenansicht).</details>

5. **Wie wechselt man ins Elternverzeichnis?**
   <details><summary>Antwort</summary>`cd ..`</details>

</details>

<details>
<summary><b>Fragen zur Dokumentation</b> (Klicken zum Ausklappen)</summary>

1. **Wozu dient `man`?**
   <details><summary>Antwort</summary>Zum Aufrufen der Manual Pages (Handbuch) eines Befehls.</details>

2. **Was macht `info`?**
    <details><summary>Antwort</summary>Zeigt eine detailliertere, oft hierarchisch aufgebaute Dokumentation an (GNU-Standard).</details>

3. **Was zeigt `whatis`?**
    <details><summary>Antwort</summary>Gibt eine kurze Einzeiler-Beschreibung aus, wofür ein Befehl gut ist.</details>

</details>

<details>
<summary><b>Fragen zu Shell & Kommandos</b> (Klicken zum Ausklappen)</summary>

1. **Wie prüft man die aktuelle Shell?**
    <details><summary>Antwort</summary>`echo $SHELL` oder `echo $0`.</details>

2. **Nenne drei bekannte Shells.**
    <details><summary>Antwort</summary>`bash`, `zsh`, `sh` (oder `fish`, `ksh`).</details>

3. **Was ist der Unterschied zwischen internen und externen Kommandos?**
    <details><summary>Antwort</summary>**Intern (Builtins):** Sind direkt in der Shell fest verbaut (z.B. `cd`, `echo`). **Extern:** Eigenständige Programme, die als Datei auf der Festplatte liegen (z.B. `ls`, `grep`).</details>

</details>

<details>
<summary><b>Fragen zur Dateiverwaltung & Info</b> (Klicken zum Ausklappen)</summary>

1. **Wie erstellt man ein Verzeichnis?**
    <details><summary>Antwort</summary>`mkdir <verzeichnisname>`</details>

2. **Wie löscht man ein Verzeichnis inkl. Inhalt?**
    <details><summary>Antwort</summary>`rm -r <verzeichnisname>` (rekursiv).</details>

3. **Was ist der Unterschied zwischen `cp` und `mv`?**
    <details><summary>Antwort</summary>`cp` kopiert eine Datei (Original bleibt), `mv` verschiebt oder benennt eine Datei um (Original wird am alten Ort entfernt).</details>

4. **Was zeigt `stat <datei>`?**
    <details><summary>Antwort</summary>Detaillierte Datei-Metadaten wie Inodes, exakte Zeitstempel (Access, Modify, Change) und Rechte.</details>

5. **Was macht `file <datei>`?**
    <details><summary>Antwort</summary>Analysiert den Datei-Header und bestimmt den tatsächlichen Dateityp (unabhängig von der Endung).</details>

6. **Wie zählt man Zeilen in einer Datei?**
    <details><summary>Antwort</summary>`wc -l <dateiname>`</details>

</details>

<details>
<summary><b>Fragen zu I/O, Pipes & Steuerung</b> (Klicken zum Ausklappen)</summary>

1. **Was ist stdin, stdout und stderr?**
    <details><summary>Antwort</summary>**stdin (0):** Standardeingabe (Tastatur). **stdout (1):** Standardausgabe (Terminal). **stderr (2):** Fehlerausgabe (Terminal).</details>

2. **Wozu dient eine Pipe `|`?**
    <details><summary>Antwort</summary>Sie verbindet die Standardausgabe eines Befehls mit der Standardeingabe des nächsten Befehls.</details>

3. **Nenne ein Beispiel für eine Pipe-Nutzung.**
    <details><summary>Antwort</summary>`ls -l /etc | grep "bash"` (Listet alle Dateien in /etc auf und filtert nach "bash").</details>

4. **Was bedeutet `*` in der Shell?**
    <details><summary>Antwort</summary>Es ist ein Wildcard (Platzhalter) für beliebig viele (auch null) Zeichen.</details>

5. **Was macht `cmd1 && cmd2`?**
    <details><summary>Antwort</summary>`cmd2` wird nur ausgeführt, wenn `cmd1` erfolgreich beendet wurde (Exit-Status 0).</details>

6. **Wie prüft man den Rückgabewert eines Befehls?**
    <details><summary>Antwort</summary>Mit der Variable `echo $?`.</details>

</details>

<details>
<summary><b>Fragen zu Variables & Zugriffsrechten</b> (Klicken zum Ausklappen)</summary>

1. **Wie gibt man den Inhalt einer Variablen aus?**
    <details><summary>Antwort</summary>`echo $VARIABLENNAME`</details>

2. **Was macht `$(cmd)`?**
    <details><summary>Antwort</summary>**Command Substitution:** Der Befehl innerhalb der Klammern wird ausgeführt und sein Ergebnis an die Stelle im ursprünglichen Befehl gesetzt.</details>

3. **Was bedeutet `chmod 755 <datei>`?**
    <details><summary>Antwort</summary>`rwxr-xr-x`: Der Besitzer darf alles (7), Gruppe und andere dürfen lesen und ausführen (5), aber nicht schreiben.</details>

4. **Wozu dient das Sticky Bit?**
    <details><summary>Antwort</summary>In Verzeichnissen (wie `/tmp`) bewirkt es, dass Benutzer nur die Dateien löschen können, die ihnen selbst gehören, auch wenn sie Schreibrechte im Ordner haben.</details>

</details>
Dateien löschen können, die ihnen selbst gehören, auch wenn sie Schreibrechte im Ordner haben.</details>

</details>

---

## 📚 Ressourcen & Dokumente

Im [Assets](./assets)-Verzeichnis finden Sie die Unterlagen zu diesem Tag:

- [CHmod, Hard- und Softlinks (PDF)](./assets/CHmod,%20hard%20und%20softlinks.pdf)
- [Linux Grundlagen: Erste Fragen (PDF)](./assets/LinuxGrundlagenErsteFragen.pdf)
- [Kommandoverlauf / History (TXT)](./assets/rockyHis20260508-1412.txt)

---

*Erstellt am 08. Mai 2026 für den Linux-Essentials Kurs.*
