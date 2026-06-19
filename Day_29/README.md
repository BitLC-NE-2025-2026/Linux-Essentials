# 🐧 Textmanipulation mit AWK & sed — Tag 29

![Linux Essentials Day 29 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 100% Dokumentiert & LPIC-1 Fokussiert  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📑 Inhaltsverzeichnis
- [📖 1. AWK vs. sed: Wann verwendet man was?](#-1-awk-vs-sed-wann-verwendet-man-was)
- [✂️ 2. sed (Stream Editor) in der Praxis](#-2-sed-stream-editor-in-der-praxis)
  - [A. Syntax & wichtige Optionen](#a-syntax--wichtige-optionen)
  - [B. Suchen & Ersetzen (Substitutions)](#b-suchen--ersetzen-substitutions)
  - [C. Zeilen löschen, einfügen und filtern](#c-zeilen-löschen-einfügen-und-filtern)
- [🧮 3. AWK (Pattern Scanning & Processing) in der Praxis](#-3-awk-pattern-scanning--processing-in-der-praxis)
  - [A. Grundlegende Syntax & Arbeitsweise](#a-grundlegende-syntax--arbeitsweise)
  - [B. Trennzeichen (FS/OFS) & Spaltenverarbeitung](#b-trennzeichen-fsofs--spaltenverarbeitung)
  - [C. Interne Variablen (`NR`, `NF`, etc.)](#c-interne-variablen-nr-nf-etc)
  - [D. Reguläre Ausdrücke & Bedingungen](#d-reguläre-ausdrücke--bedingungen)
  - [E. Datenaggregation mit Assoziativen Arrays](#e-datenaggregation-mit-assoziativen-arrays)
- [🤖 4. Integration in Shell-Skripte & Pipelines](#-4-integration-in-shell-skripte--pipelines)
- [🔑 Keywords](#-keywords)
- [🧠 LPIC-1 Relevanz & Wissenstest](#-lpic-1-relevanz--wissenstest)
- [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

---

## 📖 1. AWK vs. sed: Wann verwendet man was?

Sowohl `sed` als auch `awk` sind Standard-Werkzeuge der Unix-Philosophie zur Textstrom-Verarbeitung. Sie arbeiten zeilenbasiert und hochgradig effizient, verfolgen jedoch unterschiedliche Designziele:

| Feature | `sed` (Stream Editor) | `awk` (Aho, Weinberger, Kernighan) |
| :--- | :--- | :--- |
| **Primärfokus** | Stream-Editierung und schnelle Texttransformationen | Muster-Scanning, Analyse und strukturierte Berichte |
| **Datenmodell** | Zeilenbasiert (unstrukturiert) | Spalten-/Feld- und Zeilenbasiert (strukturiert) |
| **Fähigkeiten** | Suchen & Ersetzen, Zeilen löschen/einfügen | Echte Programmiersprache (Schleifen, Variablen, Arrays, Mathematik) |
| **Bestes Einsatzgebiet** | Schnelle Dateimodifikationen, z. B. in Konfigurationen | Parsen von Tabellen, Logdateien (CSV, `/etc/passwd`) |
| **Lesbarkeit** | Kompakt, aber bei komplexen Ausdrücken schwer lesbar | Höher, da syntaktisch an C angelehnt |

---

## ✂️ 2. sed (Stream Editor) in der Praxis

`sed` liest den Input Zeile für Zeile in den sogenannten **Pattern Space**, wendet dort die definierten Editierbefehle an und gibt das Ergebnis standardmäßig auf der Standardausgabe aus.

### A. Syntax & wichtige Optionen
```bash
sed [Optionen] 'Skript' Datei
```
* `-i` (In-place): Überschreibt die Datei direkt mit den Änderungen.
* `-i.bak`: Führt die Änderung in-place durch und erstellt ein Backup der Originaldatei unter `Datei.bak`.
* `-n`: Unterdrückt das automatische Ausgeben von Zeilen (wichtig in Kombination mit dem Befehl `p`).
* `-e`: Erlaubt das Ausführen mehrerer Befehle in einem Durchlauf.
* `-E` / `-r`: Aktiviert die Unterstützung für erweiterte reguläre Ausdrücke (ERE).

### B. Suchen & Ersetzen (Substitutions)
Die Syntax für Ersetzungen lautet `s/Suchmuster/Ersatztext/Flags`.

```bash
# Ersetzt das ERSTE Vorkommen von "Linux" pro Zeile durch "Unix"
sed 's/Linux/Unix/' file.txt

# Globales Ersetzen (ALLE Vorkommen einer Zeile) mit dem Flag 'g'
sed 's/Linux/Unix/g' file.txt

# Case-Insensitive Suche mit dem Flag 'I'
sed 's/linux/Unix/I' file.txt

# Ersetzt nur das 2. Vorkommen von "Linux" in jeder Zeile
sed 's/Linux/Unix/2' file.txt

# Ersetzt Tabs (\t) durch vier Leerzeichen
sed 's/\t/    /g' file.txt

# Änderung nur in den Zeilen 1 bis 3 durchführen
sed '1,3 s/Linux/Unix/' file.txt

# Änderung nur auf der exakt 3. Zeile durchführen
sed '3 s/distros/distributions/' file.txt
```

### C. Zeilen löschen, einfügen und filtern
```bash
# Löscht die 2. Zeile des Dokuments ('d' = delete)
sed '2d' file.txt

# Löscht alle leeren Zeilen (RegEx: Zeilenanfang direkt gefolgt von Zeilenende)
sed '/^$/d' file.txt

# Löscht alle Zeilen, die das Wort "kernel" enthalten
sed '/kernel/d' file.txt

# Zeilen 1 und 2 explizit ausgeben ('p' = print)
# Wichtig: Ohne '-n' würden alle Zeilen gedruckt und Zeile 1-2 doppelt erscheinen!
sed -n '1,2p' file.txt

# Nur Zeilen ausgeben, die "Ubuntu" enthalten
sed -n '/Ubuntu/p' file.txt

# Text VOR einer Zeile einfügen ('i' = insert)
# Fügt den Text vor der 2. Zeile ein
sed '2i\Dieser Text wird vor Zeile 2 eingefügt.' file.txt

# Text NACH einer Zeile anhängen ('a' = append)
# Fügt den Text nach der 3. Zeile ein
sed '3a\Dieser Text wird nach Zeile 3 angehängt.' file.txt

# Zeilennummerierung für nicht-leere Zeilen hinzufügen
sed '/./=' file.txt | sed 'N;s/\n/ /'
```

---

## 🧮 3. AWK (Pattern Scanning & Processing) in der Praxis

`awk` interpretiert ein Dokument als Tabelle mit Spalten (Fields) und Zeilen (Records). Standardmäßig ist das Spaltentrennzeichen jedes Whitespace-Zeichen (Leerzeichen oder Tabulator).

### A. Grundlegende Syntax & Arbeitsweise
Ein AWK-Skript besteht aus Blöcken nach dem Prinzip: **Suchmuster { Aktion }**
```bash
awk 'pattern { action }' Datei
```
Wird das `pattern` weggelassen, wird die `action` auf jede Zeile angewendet. Wird die `action` weggelassen, wird standardmäßig `{ print }` (die gesamte Zeile) ausgeführt.

AWK verfügt über zwei spezielle Blöcke:
* `BEGIN { ... }`: Wird ausgeführt, **bevor** die erste Zeile gelesen wird (ideal für Header oder Variableninitialisierung).
* `END { ... }`: Wird ausgeführt, **nachdem** die letzte Zeile verarbeitet wurde (ideal für Zusammenfassungen und Berechnungen).

```bash
# Einfaches Ausgeben der gesamten Datei (äquivalent zu cat)
awk '{ print }' file.txt
```

### B. Trennzeichen (FS/OFS) & Spaltenverarbeitung
* `$0` repräsentiert die gesamte Zeile.
* `$1`, `$2`, `$3` ... repräsentieren die jeweilige Spalte.
* `FS` (Field Separator): Definiert das Eingangstrennzeichen (Standard: Whitespace). Kann auch via `-F` übergeben werden.
* `OFS` (Output Field Separator): Definiert das Trennzeichen für die Ausgabe.

```bash
# Gibt nur die 1. und 3. Spalte einer Datei aus
awk '{ print $1, $3 }' file.txt

# Parsen der '/etc/passwd' mit Doppelpunkt-Trennzeichen
awk -F ":" '{ print $1 }' /etc/passwd

# Definieren von FS und OFS im BEGIN-Block mit schönem Header und Footer
awk 'BEGIN { FS=":"; OFS="\t"; print "User\tUID\n------------" }
     { print $1, $3 }
     END { print "------------\nFertig!" }' /etc/passwd
```

### C. Interne Variablen (`NR`, `NF`, etc.)
AWK besitzt eingebaute Variablen, die die Dateianalyse stark vereinfachen:
* `NR` (Number of Record): Die aktuelle Zeilennummer.
* `NF` (Number of Fields): Die Anzahl der Spalten in der aktuellen Zeile.
* `FILENAME`: Name der aktuell verarbeiteten Datei.
* `FNR` (File Number of Record): Zeilennummer relativ zur aktuellen Datei (wichtig beim Verarbeiten mehrerer Dateien).

```bash
# Zeilennummer vor jede Zeile schreiben
awk '{ print NR, $0 }' file.txt

# Die Anzahl der Spalten (NF) pro Zeile anzeigen
awk '{ print "Zeile", NR, "hat", NF, "Spalten" }' file.txt

# Die letzte Spalte einer Zeile ausgeben (dynamisch über NF)
awk '{ print $NF }' file.txt
```

### D. Reguläre Ausdrücke & Bedingungen
Mit Operatoren wie `~` (passt auf) und `!~` (passt nicht auf) können Suchen auf bestimmte Spalten eingegrenzt werden.

```bash
# Filtert Zeilen, in denen die 2. Spalte mit "sa" beginnt
awk '$2 ~ /^sa/' favorite_food.txt

# Filtert Zeilen, in denen die 2. Spalte NICHT mit "sa" beginnt
awk '$2 !~ /^sa/' favorite_food.txt

# Komplexe Bedingungen mit logischen Operatoren (&&, ||)
# 2. Spalte beginnt nicht mit "sa" UND die 1. Spalte (Zahl) ist kleiner als 5
awk '$2 !~ /^sa/ && $1 < 5' favorite_food.txt

# Listet alle Systembenutzer aus der /etc/passwd mit einer UID ($3) größer als 1000
awk -F ":" '$3 > 1000 { print $1, $3 }' /etc/passwd
```

### E. Datenaggregation mit Assoziativen Arrays
Assoziative Arrays in AWK verwenden Strings anstelle von Zahlen als Index. Damit lassen sich Daten gruppieren und summieren.

```bash
# 1. Häufigkeiten zählen (z. B. Vorkommen von Früchten in fruits.txt)
# count[$1]++ erhöht den Zähler für die jeweilige Frucht bei jedem Vorkommen.
awk '{ count[$1]++ } 
     END { for (item in count) print item, count[item] }' fruits.txt

# 2. Summen bilden (z. B. Umsatz pro Verkäufer aus sales.txt)
# sum[$1] += $2 addiert den Wert aus Spalte 2 auf das Konto des Verkäufers in Spalte 1.
awk '{ sum[$1] += $2 } 
     END { for (name in sum) print name, sum[name] }' sales.txt

# 3. Maximum ermitteln (z. B. Top-Verkäufer ermitteln)
awk '{ sum[$1] += $2 } 
     END { 
       for (name in sum) {
         if (max == "" || sum[name] > max) { max = sum[name]; top = name }
       }
       print "Top-Seller:", top, "mit Umsatz:", max 
     }' sales.txt
```

---

## 🤖 4. Integration in Shell-Skripte & Pipelines

In der administrativen Praxis werden `sed` und `awk` meist in Pipelines zur Filterung von Befehlsausgaben oder in Bash-Skripten zur Automatisierung verwendet.

### Variablenübergabe aus Bash an AWK
Um eine Shell-Variable sicher in AWK zu verwenden, sollte die Option `-v` genutzt werden. Dies verhindert fehlerhaftes Quoting.
```bash
#!/bin/bash
threshold=100

# Übergibt die Bash-Variable $threshold als AWK-Variable 'limit'
awk -v limit="$threshold" '$2 > limit { print $1, $2 }' sales.txt
```

### Ausgabe von Systembefehlen filtern
```bash
# IPv4-Adresse eines Netzwerkinterfaces (eth0) sauber extrahieren
# -F '[\/ ]+' spaltet Zeilen bei Slashes ODER Leerzeichen auf
ip a show eth0 | awk -F '[\/ ]+' '/inet / { print $3 }'

# Webserver-Log auswerten: Zähle Zugriffe pro IP, die einen 404-Fehler erzeugt haben
grep "404" access.log | awk '{ print $1 }' | sort | uniq -c
```

---

## 🔑 Keywords

| Keyword / Befehl | Erklärung |
| :--- | :--- |
| `sed` | Stream Editor für schnelle, zeilenbasierte Texttransformationen und Suchen/Ersetzen. |
| `awk` | Turing-vollständige Mustersuch- und Textverarbeitungssprache, spezialisiert auf Tabellen. |
| `Substitutions` | Ersetzungsoperationen in sed, typischerweise mit dem Operator `s/alt/neu/`. |
| `Pattern Space` | Der interne Arbeitsspeicher von sed, in dem die aktuelle Zeile bearbeitet wird. |
| `FS` / `OFS` | Field Separator / Output Field Separator (Spaltentrenner für Eingabe/Ausgabe in AWK). |
| `NR` / `NF` | Number of Record (Zeilennummer) / Number of Fields (Spaltenanzahl) in AWK. |
| `Assoziatives Array` | Datenstruktur in AWK, die Schlüssel-Wert-Paare (z. B. `Name -> Umsatz`) speichert. |

---

## 🧠 LPIC-1 Relevanz & Wissenstest

<details>
<summary><b>Fragen zu AWK & sed (Klicken zum Ausklappen)</b></summary>

1. **Was ist der Unterschied zwischen `sed 's/A/B/'` und `sed 's/A/B/g'`?**
   <details><summary>Antwort</summary>Ohne das globale Flag `g` wird nur das erste Vorkommen von `A` in jeder Zeile ersetzt. Mit `g` werden alle Vorkommen in der gesamten Zeile ersetzt.</details>

2. **Wie filtert man mit AWK alle Zeilen einer CSV-Datei (Komma als Trenner), bei denen in der 4. Spalte ein Wert größer als 50 steht?**
   <details><summary>Antwort</summary>`awk -F "," '$4 > 50' datei.csv`</details>

3. **Welcher sed-Befehl löscht alle leeren Zeilen aus einer Datei und schreibt die Änderungen direkt in die Datei zurück?**
   <details><summary>Antwort</summary>`sed -i '/^$/d' datei.txt`</details>

4. **Wie kann eine in Bash definierte Variable `SUCHBEGRIFF` sicher in einem AWK-Befehl verwendet werden?**
   <details><summary>Antwort</summary>Über das Flag `-v`: `awk -v suche="$SUCHBEGRIFF" '$0 ~ suche' datei.txt`</details>

5. **Wofür werden BEGIN und END Blöcke in AWK verwendet?**
   <details><summary>Antwort</summary>Der `BEGIN`-Block wird vor dem Einlesen der Daten ausgeführt (z.B. um Trennzeichen oder Tabellenköpfe festzulegen). Der `END`-Block wird nach dem Verarbeiten der letzten Zeile ausgeführt (z.B. für Berechnungen oder Gesamtsummen).</details>

</details>

---

## 🔗 Zurück zur Übersicht

* **Tag 28 (Docker Swarm Monitoring & CD):** [⬅️ Tag 28](../Day_28/README.md)
* **Tag 30 (LPIC-1 Simulation 102):** [➡️ Tag 30](../Day_30/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
