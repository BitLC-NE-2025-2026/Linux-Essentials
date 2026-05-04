# Linux-Distributionen und Ausrichtungen

## Hauptfamilien
* **Red Hat:** Rocky Linux, Red Hat Enterprise Linux
* **Debian:** Debian, Ubuntu, Kali Linux, Linux Mint, basiert auf Ubuntu
* **Arch Linux:** Manjaro, Garuda
* **SUSE**
* **LFS:** Linux From Scratch

## Allgemeine Notizen
* Enterprise-Versionen sind für den Unternehmensbereich konzipiert und bieten bis zu 10 Jahre Support.
* Ein sehr großer Teil der weltweiten IT-Systeme läuft unter Linux.
* Die meisten Linux-Distributionen sind, abgesehen von kommerziellen Enterprise-Versionen, kostenlos.
* Hardware-Treiber werden unter Linux als Kernel-Module bezeichnet.

# System- und Virtualisierungsarten
## Release-Modelle
* **LTS, Long Term Support:** Die Laufzeit ist an den Kernel gebunden. Eine neue Version erscheint oft alle zwei Jahre. Nach vier bis fünf Jahren werden keine Sicherheitsupdates mehr bereitgestellt.
* **RR, Rolling Release:** Das System erhält ständige Updates für Sicherheit und Software. Eine komplette Neuinstallation ist für Versionssprünge nicht notwendig.
### NoteNotes
- Linux abgesehen von Enterprise Versionen sind meistens Kostenlos
- Treiber bei Linux = Module

## Virtualisierung und Containerisierung
| Technologie | Beschreibung | Eigenschaften | Beispiele |
| :--- | :--- | :--- | :--- |
| **Hypervisor Typ 1** | Bare-Metal-Virtualisierung | Benötigt kein Host-Betriebssystem. Die Software bringt eigene Hardware-Treiber mit. Geeignet für hochperformante Systeme. | Proxmox, ESXi |
| **Hypervisor Typ 2** | Gehostete Virtualisierung | Setzt ein installiertes Host-Betriebssystem und ein ISO-Image der Linux-Distribution voraus. Das Gastsystem ist gekapselt, nutzt aber die Hardware über das Hostsystem. Eher für Experimentierumgebungen entwickelt. | VMware, VirtualBox |
| **Container-Management** | Isolierte Instanzen | Erzeugt Instanzen zur Abfangung hoher Datenlasten von Anwendungen, vergleichbar mit Objekten in der objektorientierten Programmierung. Container lassen sich extrem schnell erzeugen und löschen. | Docker, Podman |

# Linux-Konsolenbefehle

## Navigation und System
| Befehl | Funktion |
| :--- | :--- |
| `clear` | Leert die Konsolenausgabe |
| `pwd` | Print Working Directory. Zeigt den absoluten Pfad des aktuellen Verzeichnisses an |
| `cd ~` | Wechselt in das eigene Home-Verzeichnis |
| `cd ..` | Wechselt eine Verzeichnisebene nach oben |
| `cd ORDNER` | Wechselt in das angegebene Verzeichnis |
| `ls` | Zeigt Dateien und Ordner im aktuellen Verzeichnis an |
| `ls -al` | Zeigt alle Dateien inklusive versteckter mit detaillierten Rechten und Status an |
| `man BEFEHL` | Öffnet das Handbuch, Manual, für den jeweiligen Befehl |
| `q` | Beendet Programme wie `less` oder `man` |
| `exit` | Meldet den aktuellen Benutzer ab oder schließt das Terminal |
| `history` | Zeigt den Verlauf der bisher eingegebenen Befehle an |
| `reboot` | Startet das System neu |

## Datei- und Textverarbeitung
| Befehl | Funktion |
| :--- | :--- |
| `BEFEHL | less` | Der Pipe-Operator leitet die Ausgabe an den Pager `less` zur seitenweisen Anzeige weiter |
| `head -n 10 DATEI` | Gibt nur die ersten 10 Zeilen einer Datei aus |
| `echo "Text"` | Gibt den Text auf der Konsole aus. `$0` zeigt die aktuell verwendete Shell an |
| `cat DATEI` | Gibt den gesamten Inhalt einer Datei in der Konsole aus |
| `wc DATEI` | Word Count. Zeigt Zeilen, Wörter und Bytes einer Datei an |
| `wc -c DATEI` | Zeigt nur die Anzahl der Bytes an |
| `wc -m DATEI` | Zeigt nur die Anzahl der Zeichen an |
| `wc -l DATEI` | Zeigt nur die Anzahl der Zeilen an |
| `wc -w DATEI` | Zeigt nur die Anzahl der Wörter an |

## Benutzer- und Rechteverwaltung
| Befehl | Funktion |
| :--- | :--- |
| `id` | Zeigt die Benutzer-ID und die Gruppenzugehörigkeiten an |
| `su -` | Switch User. Wechselt den Benutzer und lädt dessen Umgebungsvariablen |
| `sudo usermod -aG wheel USER` | Fügt den angegebenen Benutzer zur Gruppe `wheel` hinzu für Administratorrechte |
| `sudo dnf update` | Führt ein Systemupdate mit Administratorrechten über den Paketmanager DNF aus |
| `sudo cat /etc/shadow` | Zeigt die gehashten Passwörter der Benutzer an |

## Wichtige Systemverzeichnisse
| Verzeichnis | Inhalt |
| :--- | :--- |
| `/` | Wurzelverzeichnis, Root. Höchste Ebene im Dateisystem |
| `/bin` | Essenzielle Binärdateien und grundlegende Anwenderbefehle |
| `/boot` | Dateien für den Systemstart |
| `/etc` | Systemweite Konfigurationsdateien |
| `/home` | Home-Verzeichnisse der Standardbenutzer |
| `/usr` | Anwenderprogramme, Bibliotheken, `lib`, und geteilte Daten, `share` |
| `/var` | Variable Daten wie Logs, `/var/log`, Cache, `/var/cache`, oder temporäre Spool-Daten |

## Überprüfungsbefehle
| Befehl | Funktion |
| :--- | :--- |
| `sha256sum -c DATEI` | Überprüft eine Datei anhand einer Prüfsumme nach dem Secure Hash Algorithm 256. `-c` steht für check. Nützlich zur Validierung von ISO-Images |
  
### Verzeichnisse
```home``` homeverzeichniss  
```~``` homeverzeichniss des Benutzers  
```/``` Wurzelverzeichniss  

### NoteNotes
- less = pager
