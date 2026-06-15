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
  - [🔑 Keywords](#-keywords)
  - [🧠 LPIC-1 Relevanz & Wissenstest](#-lpic-1-relevanz--wissenstest)
  - [📚 Ressourcen & Dokumente](#-ressourcen--dokumente)
  - [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

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

> [!EXAMPLE]
> `chmod 755 script.sh` setzt `rwxr-xr-x` (Besitzer alles, Rest nur Lesen/Ausführen).

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - Rekursive Rechte & chown:**  
> * **Rekursives Setzen (`-R`):** Um Berechtigungen oder Besitzverhältnisse für einen gesamten Verzeichnisbaum (inkl. aller Unterordner und Dateien) zu ändern, nutzen Sie die Option **`-R`** (großes R!).  
>   * `chmod -R 755 /ordner`  
>   * `chown -R student:users /ordner`  
> * **Besitz ändern:** Der Befehl **`chown`** ändert den Besitzer und optional die Gruppe (`chown besitzer:gruppe datei`). Der Befehl **`chgrp`** ändert ausschließlich die Gruppe einer Datei (`chgrp gruppe datei`).  
>   > [!WARNING]  
>   > **Sicherheits-Regel:** Nur der Systemadministrator **root** darf den Besitzer (`chown`) einer Datei ändern! Normale Benutzer können den Besitz ihrer eigenen Dateien nicht auf andere Benutzer übertragen.

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

- **Maximum für Dateien (ohne Execute):** `666` (rw-rw-rw-).
- **Maximum für Ordner:** `777` (rwxrwxrwx).

**Berechnungs-Formel:**  
`Maximal-Rechte` AND-NOT `umask` (oktales Subtrahieren ohne Übertrag).  

| umask | Datei-Rechte (666 - umask) | Ordner-Rechte (777 - umask) | Beschreibung |
| :---: | :---: | :---: | :--- |
| `0022` | **644** (`rw-r--r--`) | **755** (`rwxr-xr-x`) | Standard für Root (andere dürfen nur lesen). |
| `0002` | **664** (`rw-rw-r--`) | **775** (`rwxrwxr-x`) | Standard für normale Benutzer (Gruppe darf schreiben). |
| `0077` | **600** (`rw-------`) | **700** (`rwx------`) | Hochgradig gesichert (keine Rechte für Gruppe/Andere). |

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - umask & umask -S:**  
> * **Symbolische Anzeige:** Mit **`umask -S`** wird die Maske symbolisch im Klartext angezeigt (z.B. `u=rwx,g=rx,o=rx`). Dies ist extrem hilfreich, um zu prüfen, was *erlaubt* ist, statt was abgezogen wird.  
> * **Berechnung im Kopf:** Eine Datei kann durch umask **nie** Ausführrechte (`x`) erhalten, da die Ausgangsbasis für Dateien immer `666` ist!  

### Spezialrechte (SUID, SGID, Sticky Bit)

Den standardmäßigen 3 Oktalstellen wird im numerischen Modus eine 4. Stelle vorangestellt:  
* **4 (SUID - Set User ID):** `chmod 4755 datei`. Führt die Datei mit Rechten des Dateibesitzers aus (z.B. `/usr/bin/passwd` läuft als `root`). Symbolisch: `rwsr-xr-x`.
* **2 (SGID - Set Group ID):** `chmod 2755 datei` / `chmod 2775 ordner`. Führt die Datei mit Rechten der Gruppe aus. Auf Ordnern angewendet erben neue Dateien automatisch die Gruppe des Ordners. Symbolisch: `rwxr-sr-x`.
* **1 (Sticky Bit):** `chmod 1777 /ordner`. In diesem Ordner dürfen Benutzer nur ihre eigenen Dateien löschen. Typisches Beispiel: `/tmp`. Symbolisch: `rwxrwxrwt`.

> [!CAUTION]  
> **LPIC-Prüfungsschwerpunkt (Groß vs. Kleinschreibung):**  
> Achten Sie auf die Darstellung in `ls -l`:  
> * Ein **kleines `s`** (User/Group) bzw. **kleines `t`** (Others) bedeutet, dass das darunterliegende Ausführrecht **`x` gesetzt** ist (z.B. `rws` = SUID + Execute).  
> * Ein **großes `S`** bzw. **großes `T`** bedeutet, dass das darunterliegende Ausführrecht **`x` NICHT gesetzt** ist (z.B. `rwS` = SUID ohne Execute). Dies ist oft ein Konfigurationsfehler!  

#### 📊 Die 8 Oktal-Kombinationen der Spezialrechte
Die erste Ziffer der vierstelligen Oktalnotation repräsentiert die Summe der gesetzten Bits: **4 (SUID)** + **2 (SGID)** + **1 (Sticky Bit)**.

| Oktalwert (1. Stelle) | Aktivierte Spezialrechte | Symbolisch (rwx-Bereich) | Auswirkung / Funktion | Typisches Praxisbeispiel |
| :---: | :--- | :---: | :--- | :--- |
| **0** | Keine Spezialrechte | `---` | Standardzugriffsrechte gelten. Keine Erhöhung. | Normale Dateien/Verzeichnisse (`chmod 0755` / `0644`) |
| **1** | **Sticky Bit** | `--t` / `--T` | Löschschutz: Nur Besitzer darf eigene Dateien löschen. | Gemeinsame temporäre Ordner (`chmod 1777 /tmp`) |
| **2** | **SGID** (Set Group ID) | `-s-` / `-S-` | Ausführung als Gruppe / Gruppenvererbung in Ordnern. | Gemeinsame Projektverzeichnisse (`chmod 2770 /srv/projekte`) |
| **3** | SGID + Sticky Bit | `-st` / `-ST` | Gruppenvererbung aktiv + Löschschutz für andere User. | Freigaben mit Gruppenrechten und Löschschutz |
| **4** | **SUID** (Set User ID) | `s--` / `S--` | Ausführung mit Rechten des Dateibesitzers (meist root). | Passwortänderungstool (`chmod 4755 /usr/bin/passwd`) |
| **5** | SUID + Sticky Bit | `s-t` / `S-T` | Ausführung als Dateibesitzer + Löschschutz im Ordner. | Extrem seltene Spezialkombinationen |
| **6** | SUID + SGID | `ss-` / `SS-` | Ausführung als Besitzer **und** als Gruppe. | Hochprivilegierte administrative Tools |
| **7** | SUID + SGID + Sticky Bit | `sst` / `SST` | Alle drei Spezialrechte gleichzeitig aktiv. | Komplexe kollaborative Systemumgebungen |

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
| **Inode** | **Identisch** mit dem Original. | Eigene, neue Inode. |
| **Dateisystem** | **Nein.** Nur innerhalb desselben Dateisystems (gleicher Partition) möglich. | **Ja.** Kann dateisystemübergreifend zeigen. |
| **Verzeichnis-Link** | **Nein.** Darf nicht für Ordner erstellt werden (Gefahr von Endlosschleifen). | **Ja.** Funktioniert problemlos für Verzeichnisse. |
| **Löschen des Ziels** | Datei bleibt erhalten, solange noch ein Link auf die Inode zeigt. | Der Symlink wird "tot" (Broken Link, verweist ins Leere). |

> [!IMPORTANT]  
> **LPIC-1 RELEVANTES PRÜFUNGSWISSEN - Inodes & Links:**  
> * **Hardlinks** belegen keinen zusätzlichen Speicherplatz für Daten, da sie direkt auf dieselbe Inode zeigen. Der Inode-Zähler (Link Count in `ls -l` oder `stat`) wird um 1 erhöht. Erst wenn der Zähler auf `0` fällt (alle Hardlinks gelöscht), gibt das System den Speicherplatz frei.  
> * **Symlinks** sind eigenständige kleine Dateien, die den Pfad zur Zieldatei als Textinhalt speichern. Sie haben eine eigene Inode-Nummer.  
> * Mit **`ls -il`** können Sie die Inode-Nummern anzeigen lassen, um Hardlinks sofort zu identifizieren (gleiche Nummer = Hardlink).

---

## 🔑 Keywords

| Keyword / Befehl | Erklärung |
| :--- | :--- |
| `chmod` | Ändert Dateizugriffsrechte für User, Group und Others (symbolisch oder oktal). |
| `chown` | Ändert den Eigentümer und/oder die Gruppe einer Datei oder eines Verzeichnisses. |
| `umask` | Definiert die Standard-Berechtigungsmaske, die neu erstellten Dateien und Ordnern entzogen wird. |
| `Hardlink` | Direkter Verweis auf eine physische Inode-Nummer; kann nur innerhalb derselben Partition existieren. |
| `Softlink` | Symbolischer Zeiger-Verweis auf den Pfad einer Originaldatei; partitionenübergreifend lauffähig. |
| `ACL` | Access Control Lists: Ermöglicht feinere, benutzerspezifische Berechtigungen über die Standard-UGO-Rechte hinaus. |

---

## 🧠 LPIC-1 Relevanz & Wissenstest

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

---

## 📚 Ressourcen & Dokumente

Im [Assets](./assets)-Verzeichnis finden Sie die Unterlagen zu diesem Tag:

* [CHmod, Hard- und Softlinks (PDF)](./assets/CHmod,%20hard%20und%20softlinks.pdf)
* [Linux Grundlagen: Erste Fragen (PDF)](./assets/LinuxGrundlagenErsteFragen.pdf)
* [Kommandoverlauf / History (TXT)](./assets/rockyHis20260508-1412.txt)

---

## 🔗 Zurück zur Übersicht

* **Tag 04 (Textmanipulation & Filter):** [⬅️ Tag 04](../Day_04/README.md)
* **Tag 06 (Prozessmanagement & Spezialrechte):** [➡️ Tag 06](../Day_06/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
