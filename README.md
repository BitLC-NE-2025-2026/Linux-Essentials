# Linux Distributionen und Systemarchitektur

## Unix und Linux Historie
* 1969: Entstehung von Unix bei AT&T durch Dennis Ritchie und Ken Thompson.
* 1972: Veröffentlichung des Buches The C Programming Language durch Dennis Ritchie und Brian Kernighan.
* 1991: Start der Entwicklung des Linux Kernels durch Linus Torvalds.
* Architektur: Bis Version 2.4 lief der Kernel als 32 Bit Version, ab Version 2.6 erfolgte die Umstellung auf 64 Bit.

## Verbreitung und Marktanteil
* Bildet das absolute Fundament im Cloud Computing bei Anbietern wie AWS oder Microsoft Azure
* Betreibt exakt 500 der 500 weltweit leistungsstärksten Supercomputer.
* Dient als Basis für extrem viele Embedded Systems, Smart Home Geräte und das Android Betriebssystem
* Bietet enorme Skalierbarkeit vom kleinen Einplatinencomputer bis hin zum Server Cluster
* Betreibt 99 Prozent aller weltweiten IT Systeme.
* Das Unternehmen Red Hat wurde an IBM verkauft.
  
## Linux Hauptfamilien und Distributionen

| Familie | Fokus und Beschreibung | Paketmanager | Bekannte Distributionen |
| :--- | :--- | :--- | :--- |
| **Debian** | Basis für viele einsteigerfreundliche und serverseitige Systeme. Hohe Stabilität und riesige Softwareauswahl. | APT, dpkg | Debian, Ubuntu, Linux Mint, Kali Linux |
| **Red Hat** | Fokussiert auf Stabilität, Langzeitunterstützung und Unternehmensumgebungen. Basis für kommerzielle und freie Enterprise Systeme. | DNF, YUM, rpm | Red Hat Enterprise Linux, Fedora, Rocky Linux, AlmaLinux |
| **Arch Linux** | Minimalistisch und flexibel. Nutzt ein Rolling Release Modell für stets hochaktuelle Softwarepakete. Setzt fortgeschrittene Linux Kenntnisse voraus. | Pacman | Arch Linux, Manjaro, EndeavourOS, Garuda Linux |
| **SUSE** | Stark im Unternehmensbereich. Bietet mit YaST ein mächtiges zentrales Werkzeug zur Systemverwaltung. | Zypper, rpm | openSUSE Leap, openSUSE Tumbleweed, SUSE Linux Enterprise |
| **Slackware** | Die älteste noch aktiv gepflegte Distribution. Sehr traditioneller Aufbau, Verzicht auf moderne Automatismen, nah am reinen Unix Konzept. | pkgtools | Slackware, Salix |
| **Unabhängige Systeme** | Systeme mit völlig eigenen Philosophien. Oft quellcodebasiert zur maximalen Systemoptimierung oder extrem minimalistisch für reine Container Anwendungen. | Portage, apk | Gentoo, Alpine Linux, Linux From Scratch, NixOS |
## Weitere Linux Kategorien und Zweige

| Kategorie | Fokus und Beschreibung | Bekannte Systeme |
| :--- | :--- | :--- |
| **Mobile und Cloud** | Nutzen den Linux Kernel, besitzen aber eine völlig andere Systemarchitektur als klassische Desktop Systeme. Es fehlt die typische GNU Umgebung. | Android, ChromeOS |
| **Mandriva Zweig** | Historisch sehr bedeutsam. Ursprünglich aus Red Hat entstanden, entwickelte sich das System zu einem eigenständigen Ökosystem mit eigenen Konfigurationswerkzeugen. | Mageia, OpenMandriva, PCLinuxOS |
| **Embedded und Netzwerk** | Hochgradig optimiert für Router, Firewalls und kleine IoT Geräte mit extrem wenig Speicherplatz. | OpenWrt, DD WRT, pfSense |
| **Immutable OS** | Moderne Architektur mit einem schreibgeschützten Systemabbild. Updates erfolgen atomar und können bei Fehlern sofort rückgängig gemacht werden. | Fedora Silverblue, Vanilla OS, openSUSE MicroOS |

# Allgemeine Notizen zu Linux

## Enterprise Distributionen
* Konzipiert für absolute Stabilität und Vorhersehbarkeit im Geschäftsbetrieb
* Bieten Zertifizierungen für proprietäre Unternehmenssoftware wie SAP oder Oracle
* Gewährleisten garantierte Sicherheitsupdates und Fehlerbehebungen für einen Zeitraum von bis zu 10 Jahren
* Umfassen oft kostenpflichtige Service Level Agreements für garantierten Herstellersupport

## Verbreitung und Marktanteil
* Bildet das absolute Fundament im Cloud Computing bei Anbietern wie AWS oder Microsoft Azure
* Betreibt nahezu 100 Prozent der weltweit leistungsstärksten Supercomputer
* Dient als Basis für extrem viele Embedded Systems, Smart Home Geräte und das Android Betriebssystem
* Bietet enorme Skalierbarkeit vom kleinen Einplatinencomputer bis hin zum Server Cluster

## Lizenzierung und Kosten
* Entwickelt nach der Open Source Philosophie unter Lizenzen wie der GNU General Public License
* Der Quellcode ist für jedermann frei einsehbar, auditierbar und modifizierbar
* Die Betriebssysteme sind in der Regel völlig kostenlos herunterladbar und nutzbar
* Kommerzielle Anbieter generieren Umsatz primär über Supportverträge, Schulungen und Zertifizierungen

## Hardware und Kernel Module
* Linux verwendet eine monolithische Architektur mit dynamisch ladbaren Modulen
* Hardwaretreiber sind direkt als Kernel Module implementiert
* Module lassen sich im laufenden Betrieb bedarfsgerecht laden und entladen
* Diese dynamische Verwaltung schont Systemressourcen und verhindert Neustarts bei Hardwareänderungen

# Systemarten und Virtualisierung

## Release Modelle
* **LTS, Long Term Support:** Die Laufzeit ist an den Kernel gebunden. Eine neue Version erscheint oft alle zwei Jahre. Nach vier bis fünf Jahren werden keine Sicherheitsupdates mehr bereitgestellt.
* **RR, Rolling Release:** Das System erhält ständige Updates für Sicherheit und Software. Eine komplette Neuinstallation ist für Versionssprünge nicht notwendig.

## Virtualisierung und Containerisierung
| Technologie | Beschreibung | Eigenschaften | Beispiele |
| :--- | :--- | :--- | :--- |
| **Hypervisor Typ 1** | Bare Metal Virtualisierung | Benötigt kein Host Betriebssystem. Die Software bringt eigene Hardware Treiber mit. Geeignet für hochperformante Systeme. | Proxmox, ESXi |
| **Hypervisor Typ 2** | Gehostete Virtualisierung | Setzt ein installiertes Host Betriebssystem und ein ISO Image der Linux Distribution voraus. Das Gastsystem ist gekapselt, nutzt aber die Hardware über das Hostsystem. Entwickelt für Experimentierumgebungen. | VMware, VirtualBox |
| **Container Management** | Isolierte Instanzen | Erzeugt Instanzen zur Abfangung hoher Datenlasten von Anwendungen, vergleichbar mit Objekten in der objektorientierten Programmierung. Container lassen sich extrem schnell erzeugen und löschen. | Docker, Podman |

# Linux Systemverzeichnisse nach Filesystem Hierarchy Standard

| Verzeichnis | Inhalt und Funktion |
| :--- | :--- |
| `/` | Wurzelverzeichnis. Die höchste Ebene im Dateisystem. Alle anderen Verzeichnisse sind diesem untergeordnet. |
| `/bin` | Wichtige ausführbare Programme und grundlegende Befehle für alle Benutzer. |
| `/boot` | Statische Dateien des Bootloaders und der kompilierte Linux Kernel. |
| `/dev` | Gerätedateien. Physische und virtuelle Hardwarekomponenten werden hier als Dateien repräsentiert. |
| `/etc` | Systemweite Konfigurationsdateien und lokale Skripte für den Systemstart. |
| `/home` | Benutzerverzeichnisse. Speichert persönliche Dokumente und benutzerspezifische Programmeinstellungen. |
| `/lib` | Essenzielle Systembibliotheken und Kernelmodule. Diese werden von Binärdateien in `/bin` und `/sbin` zwingend benötigt. |
| `/lib32` | 32 Bit Systembibliotheken. |
| `/lib64` | 64 Bit Systembibliotheken. |
| `/media` | Automatische Einhängepunkte für erkannte Wechseldatenträger wie USB Sticks oder externe Festplatten. |
| `/mnt` | Temporäre Einhängepunkte für manuell verbundene Dateisysteme durch den Administrator. |
| `/opt` | Zusätzliche Anwendungsprogramme und Softwarepakete von Drittanbietern. |
| `/proc` | Virtuelles Dateisystem. Beinhaltet Laufzeitinformationen über aktive Systemprozesse und den Kernel. |
| `/root` | Eigenes Home Verzeichnis des Systemadministrators Root. |
| `/run` | Temporäre Laufzeitdaten aktiver Prozesse. Dieses Verzeichnis wird bei jedem Systemstart vollständig geleert. |
| `/sbin` | Administrative Systemprogramme für die Systemverwaltung. Primär für den Administrator ausführbar. |
| `/srv` | Spezifische Daten für vom System bereitgestellte Dienste wie Webserver oder FTP Server. |
| `/sys` | Virtuelles Dateisystem zur Interaktion mit Hardwareinformationen und Treibereinstellungen des Kernels. |
| `/tmp` | Speicherort für temporäre Dateien. Von Programmen erstellt und periodisch oder beim Systemstart bereinigt. |
| `/usr` | Sekundäre Hierarchie für schreibgeschützte Anwenderdaten. Beinhaltet Benutzerprogramme, Bibliotheken und Dokumentationen. |
| `/usr/local` | Speicherort für lokale Softwareinstallationen durch den Systemadministrator zum Schutz vor Überschreibungen bei Systemupdates. |
| `/var` | Variable Systemdaten. Umfasst Systemprotokolle, Cache Dateien, Datenbanken und Spool Daten für Drucker. |

# Linux Konsolenbefehle

## Navigation und System
| Befehl | Funktion |
| :--- | :--- |
| `clear` | Leert die Konsolenausgabe |
| `pwd` | Print Working Directory. Zeigt den absoluten Pfad des aktuellen Verzeichnisses an |
| `cd ~` | Wechselt in das eigene Home Verzeichnis |
| `cd /` | Wechselt in das Wurzel Verzeichnis |
| `cd ..` | Wechselt eine Verzeichnisebene nach oben |
| `cd ORDNER` | Wechselt in das angegebene Verzeichnis |
| `ls` | Zeigt Dateien und Ordner im aktuellen Verzeichnis an |
| `ls -al` | Zeigt alle Dateien inklusive versteckter mit detaillierten Rechten und Status an |
| `man BEFEHL` | Öffnet das Handbuch, Manual, für den jeweiligen Befehl |
| `man info --help` | Öffnet die Info seite, für den jeweiligen Befehls |
| `q` | Beendet Programme wie `less` oder `man` |
| `exit` | Meldet den aktuellen Benutzer ab oder schließt das Terminal |
| `history` | Zeigt den Verlauf der bisher eingegebenen Befehle an |
| `reboot` | Startet das System neu |

## Datei und Textverarbeitung
| Befehl | Funktion |
| :--- | :--- |
| `less` | Der Pipe Operator leitet die Ausgabe an den Pager `less` zur seitenweisen Anzeige weiter |
| `head -n 10 DATEI` | Gibt nur die ersten 10 Zeilen einer Datei aus |
| `echo "Text"` | Gibt den Text auf der Konsole aus. `$0` zeigt die aktuell verwendete Shell an |
| `cat DATEI` | Gibt den gesamten Inhalt einer Datei in der Konsole aus |
| `wc DATEI` | Word Count. Zeigt Zeilen, Wörter und Bytes einer Datei an |
| `wc -c DATEI` | Zeigt nur die Anzahl der Bytes an |
| `wc -m DATEI` | Zeigt nur die Anzahl der Zeichen an |
| `wc -l DATEI` | Zeigt nur die Anzahl der Zeilen an |
| `wc -w DATEI` | Zeigt nur die Anzahl der Wörter an |
| `date` | Gibt das aktuelle Systemdatum aus |
| `date +%Y` | Zeigt das aktuelle Jahr vierstellig an |
| `date +%F` | Formatiert die Datumsausgabe als vollständiges Datum |
| `> DATEI` | Leitet die Konsolenausgabe in die angegebene Datei um |
| `history > datei.txt` | Speichert den kompletten Befehlsverlauf in einer Textdatei |

## Benutzer und Rechteverwaltung
| Befehl | Funktion |
| :--- | :--- |
| `id` | Zeigt die Benutzer ID und die Gruppenzugehörigkeiten an |
| `su -` | Switch User. Wechselt den Benutzer und lädt dessen Umgebungsvariablen |
| `sudo usermod -aG wheel USER` | Fügt den angegebenen Benutzer zur Gruppe `wheel` hinzu für Administratorrechte |
| `sudo dnf update` | Führt ein Systemupdate mit Administratorrechten über den Paketmanager DNF aus |
| `sudo cat /etc/shadow` | Zeigt die gehashten Passwörter der Benutzer an |

## Überprüfungsbefehle
| Befehl | Funktion |
| :--- | :--- |
| `sha256sum -c DATEI` | Überprüft eine Datei anhand einer Prüfsumme nach dem Secure Hash Algorithm 256. `-c` steht für check. Nützlich zur Validierung von ISO Images |
| `sha256sum -c Rocky-9.7-x86_64-boot.iso` | Überprüft die Boot ISO anhand des Hashwertes 3b5c87b2f9e62fdf0235d424d64c677906096965aad8a580e0e98fcb9f97f267 |
| `sha256sum -c Rocky-9.7-x86_64-dvd.iso` | Überprüft die DVD ISO anhand des Hashwertes d48e902325dce6793935b4e13672a0d9a4f958e02d4e23fcf0a8a34c49ef03da |

# Dateirechte und Besitzverhältnisse

## Rechtesystem verstehen
Dateirechte in Linux bestehen aus drei Kategorien: Besitzer, Gruppe und Andere. Jede Kategorie hat Leserechte, Schreibrechte und Ausführungsrechte.

| Buchstabe | Oktalwert | Bedeutung |
| :--- | :--- | :--- |
| `r` | 4 | Read. Leserecht |
| `w` | 2 | Write. Schreibrecht |
| `x` | 1 | Execute. Ausführungsrecht |

## chmod, Change Mode
Ändert die Zugriffsrechte von Dateien oder Verzeichnissen.

| Befehl | Funktion |
| :--- | :--- |
| `chmod 755 DATEI` | Besitzer darf alles lesen, schreiben, ausführen. Gruppe und Andere dürfen lesen und ausführen |
| `chmod 644 DATEI` | Besitzer darf lesen und schreiben. Gruppe und Andere dürfen nur lesen |
| `chmod +x DATEI` | Macht eine Datei für alle ausführbar |
| `chmod u+w DATEI` | Gibt dem Besitzer das Schreibrecht |

## chown, Change Owner
Ändert den Besitzer und die Gruppenzugehörigkeit von Dateien oder Verzeichnissen.

| Befehl | Funktion |
| :--- | :--- |
| `chown user DATEI` | Ändert den Besitzer der Datei auf `user` |
| `chown user:gruppe DATEI` | Ändert Besitzer auf `user` und Gruppe auf `gruppe` |
| `chown -R user ORDNER` | Ändert den Besitzer rekursiv für alle Dateien im Verzeichnis |

# Grundlagen Shell Scripting

Ein Shell Script ist eine Textdatei mit einer Abfolge von Konsolenbefehlen.

## Erstellung und Ausführung
1. Datei erstellen: `touch script.sh`
2. Ausführbar machen: `chmod +x script.sh`
3. Script starten: `./script.sh`

## Script Beispiel
```bash
#!/bin/bash
# Die Shebang Zeile definiert den absoluten Pfad zum Interpreter für das Script.
# Hiermit wird sichergestellt, dass das Script mit der Bash Shell ausgeführt wird.

# Deklaration und Initialisierung einer Variablen.
# Best Practice: Variablennamen in Großbuchstaben schreiben und keine Leerzeichen am Gleichheitszeichen verwenden.
SYSTEM_BENUTZERNAME="Admin"

# Ausgabe eines einfachen Textes auf der Standardausgabe.
echo "Systemprüfung wird gestartet"

# Bedingte Anweisung zur Prüfung des Variablenwertes.
# Der Operator == vergleicht den Inhalt der Variablen mit der Zeichenkette Admin.
if [ "$SYSTEM_BENUTZERNAME" == "Admin" ]; then
    # Block wird ausgeführt, wenn die Bedingung wahr ist.
    echo "Administratorrechte wurden bestätigt"
else
    # Block wird ausgeführt, wenn die Bedingung falsch ist.
    echo "Standardbenutzer aktiv, eingeschränkte Rechte"
fi
# Beendet die if Anweisung.
