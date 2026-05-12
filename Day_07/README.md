# 📦 Day 07: Archive, Kompression & Software-Builds

---

## 🎯 Lernziele für heute
* Erstellen und Verwalten von Datei-Archiven mit `tar`.
* Verstehen der verschiedenen Kompressionsalgorithmen (Gzip, Bzip2, XZ).
* Kombinieren von Archivierung und Kompression.
* Einführung in moderne Build-Systeme am Beispiel von `meson`.

---

## 📂 1. Der Tape Archiver (`tar`)

`tar` ist das Standard-Werkzeug, um viele Dateien und Verzeichnisse in einer einzigen Datei (einem "Tarball") zusammenzufassen. **Wichtig:** `tar` allein komprimiert nicht, es packt nur zusammen.

### Grundbefehle:
| Flag | Bedeutung | Beschreibung |
| :---: | :--- | :--- |
| `-c` | **c**reate | Erstellt ein neues Archiv. |
| `-x` | e**x**tract | Entpackt ein Archiv. |
| `-t` | **t**ist | Listet den Inhalt eines Archivs auf, ohne zu entpacken. |
| `-v` | **v**erbose | Zeigt detailliert an, welche Dateien verarbeitet werden. |
| `-f` | **f**ile | Gibt den Dateinamen des Archivs an (muss immer am Ende der Flag-Liste stehen). |

**Beispiele:**
```bash
tar -cvf archiv.tar /pfad/zum/ordner  # Archiv erstellen
tar -tvf archiv.tar                   # Inhalt ansehen
tar -xvf archiv.tar                   # Archiv entpacken
```

---

## 🗜 2. Kompressionsalgorithmen

Um Speicherplatz zu sparen, werden Archive komprimiert. Hier die gängigsten Tools im Vergleich:

| Tool | Dateiendung | Algorithmus | Fokus |
| :--- | :--- | :--- | :--- |
| `gzip` | `.gz` | DEFLATE | Schnelligkeit, geringe CPU-Last. |
| `bzip2` | `.bz2` | Burrows-Wheeler | Gutes Gleichgewicht zwischen Zeit & Rate. |
| `xz` | `.xz` | LZMA2 | Maximale Kompression (benötigt viel RAM/Zeit). |

---

## 🚀 3. Alles in einem Schritt (tar + Kompression)

Moderne `tar`-Versionen können die Kompression direkt über Flags mitsteuern:

| Flag | Kompression | Typische Endung | Befehl-Beispiel |
| :---: | :--- | :--- | :--- |
| `-z` | **gzip** | `.tar.gz` / `.tgz` | `tar -czvf backup.tar.gz /home` |
| `-j` | **bzip2** | `.tar.bz2` | `tar -cjvf backup.tar.bz2 /home` |
| `-J` | **xz** | `.tar.xz` | `tar -cJvf backup.tar.xz /home` |

> [!NOTE]
> Beim Entpacken erkennt `tar` das Format meist automatisch: `tar -xvf datei.tar.gz` funktioniert oft ohne das `-z`.

---

## 🛠 4. Software-Builds mit Meson

Wenn Software nicht über einen Paketmanager (wie `dnf`) verfügbar ist, muss sie oft selbst kompiliert werden. `meson` ist ein modernes Build-System (Alternative zu CMake/Autotools).

### Der typische Meson-Workflow:
1. **Konfiguration:** Meson prüft die Abhängigkeiten und bereitet den Build-Ordner vor.
   ```bash
   meson setup builddir
   ```
2. **Kompilierung:** Der eigentliche Build-Prozess (Umwandeln von Quellcode in Binärdateien).
   ```bash
   meson compile -C builddir
   ```
3. **Installation:** Kopieren der fertigen Dateien in die Systemverzeichnisse.
   ```bash
   sudo meson install -C builddir
   ```

---

## 📝 Praktische Übungen (Day 07)

1. **Archiv erstellen:** Erstelle ein unkomprimiertes Archiv deiner Dokumente.
2. **Kompression vergleichen:**
   - Erstelle ein `.tar.gz`, ein `.tar.bz2` und ein `.tar.xz` desselben Ordners.
   - Vergleiche die Dateigrößen mit `ls -lh`.
3. **Selektives Entpacken:** Suche im Handbuch (`man tar`) nach der Option, nur eine einzelne Datei aus einem großen Archiv zu extrahieren.
4. **Meson-Simulation:** Navigiere in ein (fiktives oder bereitgestelltes) Projektverzeichnis und führe die Schritte `setup` und `compile` durch.

---

*Letztes Update: 12. Mai 2026*
