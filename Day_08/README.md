# 🐚 Linux Essentials - Tag 08: Shell Scripting & Automatisierung

![Linux Essentials Header](./header.png)

Dieses Modul vertieft die Bash-Programmierung und bereitet gezielt auf die LPIC-1 Prüfungsziele 105.1 (Shell-Umgebung) und 105.2 (Skripte schreiben) vor.

---

## 📑 Inhaltsverzeichnis

- [🎯 Lernziele (LPIC-1 relevant)](#-lernziele-lpic-1-relevant)
- [🏗 1. Variablen & Parameter-Handling](#-1-variablen--parameter-handling)
  - [Shell- vs. Environment-Variablen](#shell--vs-environment-variablen)
  - [Skript-Argumente (Positional Parameters)](#skript-argumente-positional-parameters)
- [🔢 2. Arithmetik & Vergleiche](#-2-arithmetik--vergleiche)
  - [Rechnen in der Bash](#rechnen-in-der-bash)
  - [Die "Modernen" Tests: \[\[ ... \]\]](#die-modernen-tests---)
- [🔄 3. Kontrollstrukturen für Profis](#-3-kontrollstrukturen-für-profis)
  - [Case-Statements](#case-statements)
  - [While-Loops](#while-loops)
- [🔍 4. Expansion & Debugging](#-4-expansion--debugging)
  - [Parameter-Expansion (LPIC-Highlight)](#parameter-expansion-lpic-highlight)
  - [Debugging-Modus](#debugging-modus)
- [📝 LPIC-Übungsszenarien (Day 08)](#-lpic-übungsszenarien-day-08)
- [🧠 Wissenstest: Bash & Scripting](#-wissenstest-bash--scripting)

---

## 🎯 Lernziele (LPIC-1 relevant)

- **Variable Mastery:** Environment vs. Shell-Variablen, Argumente (`$1`, `$#`).
- **Advanced Logic:** `case`-Statements und komplexe Tests (`[[ ... ]]`).
- **Arithmetic:** Berechnungen direkt in der Shell mit `$(( ... ))`.
- **Expansion:** Parameter-Substitution (Default-Werte, String-Manipulation).
- **Debugging:** Fehleranalyse mit `set -x` und Exit-Codes.

---

## 🏗 1. Variablen & Parameter-Handling

In der LPIC-Prüfung ist der Unterschied zwischen Variablen-Typen und deren Übergabe essenziell.

### Shell- vs. Environment-Variablen

- **Shell-Variable:** Nur in der aktuellen Instanz verfügbar (`VAR=wert`).
- **Environment-Variable:** Wird an Kindprozesse vererbt (`export VAR=wert`).

### Skript-Argumente (Positional Parameters)

Skripte können beim Aufruf Daten übernehmen:

| Parameter | Bedeutung |
| :--- | :--- |
| `$0` | Name des Skripts. |
| `$1` - `$9` | Das erste bis neunte Argument. |
| `$#` | Anzahl der übergebenen Argumente. |
| `$*` / `$@` | Alle Argumente als Liste. |
| `$$` | PID des aktuellen Skripts. |
| `$?` | Exit-Status des letzten Befehls (0 = Erfolg). |

---

## 🔢 2. Arithmetik & Vergleiche

### Rechnen in der Bash

Die Bash kann nativ nur Ganzzahl-Arithmetik (Integers):

```bash
ERGEBNIS=$(( 5 + 3 * 2 )) # Ergebnis: 11
(( ZAHLER++ ))            # Inkrement
```

### Die "Modernen" Tests: `[[ ... ]]`

Verwende in Bash-Skripten bevorzugt `[[ ]]` statt `[ ]`, da es weniger fehleranfällig ist (z.B. kein Quoting bei Variablen nötig).

| Test | Bedeutung |
| :--- | :--- |
| `-z $VAR` | String ist leer. |
| `-n $VAR` | String ist NICHT leer. |
| `-e $FILE` | Datei/Ordner existiert. |
| `$A -eq $B` | Vergleich von Zahlen (equal). |
| `$A == $B` | Vergleich von Strings. |

---

## 🔄 3. Kontrollstrukturen für Profis

### Case-Statements

Ideal für Menüs oder das Verarbeiten von Argumenten (Alternative zu vielen `if`-Blöcken).

```bash
case "$1" in
    start)
        echo "Dienst startet..." ;;
    stop)
        echo "Dienst stoppt..." ;;
    *)
        echo "Usage: $0 {start|stop}" ;;
esac
```

### While-Loops

Läuft so lange, wie eine Bedingung wahr ist.

```bash
while read -r line; do
    echo "Verarbeite: $line"
done < datei.txt
```

---

## 🔍 4. Expansion & Debugging

### Parameter-Expansion (LPIC-Highlight)

Manipulation von Variablen ohne externe Tools wie `sed` oder `cut`:

- `${VAR:-default}`: Nutze "default", falls `VAR` leer ist.
- `${VAR%suffix}`: Entfernt den Suffix von hinten.
- `${VAR#prefix}`: Entfernt den Präfix von vorne.

### Debugging-Modus

Wenn ein Skript nicht tut, was es soll:

- `set -x`: Gibt jeden Befehl vor der Ausführung aus (Tracing).
- `set -e`: Bricht das Skript sofort ab, wenn ein Fehler auftritt.

---

## 📝 LPIC-Übungsszenarien (Day 08)

1. **Argument-Check:** Schreibe ein Skript, das prüft, ob genau zwei Argumente übergeben wurden. Falls nicht, gib eine Fehlermeldung aus und beende mit `exit 1`.
2. **Case-Menü:** Erstelle ein Skript, das die System-Informationen (`uname`, `uptime`, `free`) basierend auf einer Benutzereingabe ausgibt.
3. **Arithmetic-Loop:** Nutze eine `while`-Schleife und `$(( ))`, um die Zahlen von 1 bis 10 zu addieren.
4. **Expansion-Trick:** Erstelle eine Variable `DATEI="backup_2026.tar.gz"`. Nutze Parameter-Expansion, um nur `backup_2026` auszugeben.

---

## 🧠 Wissenstest: Bash & Scripting

Hier sind typische Fragen rund um Shell Scripting:

<details>
<summary><b>Fragen zu Variablen & Parametern</b> (Klicken zum Ausklappen)</summary>

1. **Was ist der Unterschied zwischen `VAR=Wert` und `export VAR=Wert`?**
   <details><summary>Antwort</summary>`VAR=Wert` definiert eine lokale Shell-Variable, die nur in der aktuellen Shell-Instanz sichtbar ist. `export VAR=Wert` macht daraus eine Umgebungsvariable (Environment Variable), die auch an alle von dieser Shell gestarteten Programme (Kindprozesse, Subshells) vererbt wird.</details>

2. **Wie greift man in einem Bash-Skript auf das 11. Argument zu?**
   <details><summary>Antwort</summary>Ab dem 10. Argument müssen geschweifte Klammern verwendet werden: **`${11}`**. Würde man `$11` schreiben, interpretiert die Bash dies als das erste Argument `$1` gefolgt von einer statischen Ziffer `1`.</details>

3. **Was ist der Unterschied zwischen `"$*"` und `"$@"`?**
   <details><summary>Antwort</summary>Unter doppelten Anführungszeichen expandiert **`"$*"`** zu einer einzigen Zeichenkette, in der alle Parameter durch das erste Zeichen der IFS-Variable (standardmäßig ein Leerzeichen) getrennt sind (z. B. `"arg1 arg2 arg3"`). **`"$@"`** hingegen expandiert zu einer Liste von separaten Zeichenketten (z. B. `"arg1"` `"arg2"` `"arg3"`), wodurch Leerzeichen in den einzelnen Argumenten erhalten bleiben. Letzteres ist fast immer die sicherere Variante.</details>

</details>

<details>
<summary><b>Fragen zu Kontrollstrukturen & Debugging</b> (Klicken zum Ausklappen)</summary>

1. **Wie lautet die Syntax für eine native mathematische Berechnung in der Bash?**
   <details><summary>Antwort</summary>Berechnungen werden in doppelten runden Klammern mit einem führenden Dollarzeichen ausgeführt: **`$(( 3 + 4 ))`**. Die Bash unterstützt dabei nativ nur Ganzzahlen (Integers).</details>

2. **Welche nützliche Funktion hat `set -e` am Anfang eines Skripts?**
   <details><summary>Antwort</summary>Es sorgt dafür, dass das Skript sofort abgebrochen wird, sobald ein darin aufgerufener Befehl fehlschlägt (also einen Exit-Code ungleich `0` liefert). Dies verhindert Folgeschäden bei Fehlern.</details>

</details>

---

*Letztes Update: 26. Mai 2026 für den Linux-Essentials Kurs.*
