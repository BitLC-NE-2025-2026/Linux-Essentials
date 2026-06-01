# 📋 LPIC-1 Lückenanalyse & Offene Themen (Stand Tag 17)

![Master Banner](./banner.png)

> **Erstellt von:** Tobias Boyke / Antigravity AI
> **Status:** 🔍 Tiefenanalyse abgeschlossen
> **Fokus:** Abgleich des aktuellen Stands (Tag 01 - 17) mit den offiziellen LPI-Prüfungszielen (Syllabus v5.0) für die Prüfungen **101-500** und **102-500**.
> **Ziel:** Dokumentation aller abgedeckten, teilweise abgedeckten und offenen Themen sowie ein exakter, modularer Fahrplan für die verbleibenden Tage 18 bis 30.

---

## 🗺️ 1. Gesamt-Status & Prüfungsbereitschaft

Bis einschließlich **Tag 17** wurden die essenziellen administrativen Grundlagen, Unix-Core-Utilities, Shell-Scripting-Basics und Netzwerk-Zeit-Konfigurationen intensiv vermittelt.

### 📊 Statistische LPIC-1 Abdeckung
* **LPIC-1 Prüfung 101 (LPI-101-500):** ca. **70%** abgedeckt.
* **LPIC-1 Prüfung 102 (LPI-102-500):** ca. **45%** abgedeckt.
* **Gesamtabdeckung (Soll-Ist-Abgleich):** ca. **57%**.

> [!NOTE]
> Die prozentuale Abdeckung bezieht sich auf die Anzahl der LPIC-1-Prüfungsziele (Objectives) und deren Gewichtung (Weight). Themen wie GNU/Unix-Befehle (Thema 103) besitzen eine sehr hohe Gewichtung und sind bereits vollständig abgedeckt.

> [!WARNING]
> Obwohl die Befehlszeile (Thema 103) beherrscht wird, fehlen für eine erfolgreiche Prüfung noch die systemnahen Themen wie Partitionierung (Thema 104), Bootloader (Thema 102) und System-Logging (Thema 108). Ein Antreten zur Prüfung ohne diese Themen führt unweigerlich zum Nichtbestehen.

---

## 🔎 2. Detaillierter Soll-Ist-Abgleich (Thema für Thema)

Nachfolgend ist jedes offizielle LPIC-1-Themengebiet (Syllabus v5.0) analysiert. Die Stati sind wie folgt definiert:
* **[A] Abgedeckt:** Vollständig behandelt und in den Tages-Readmes dokumentiert.
* **[T] Teilweise abgedeckt:** Grundkonzepte vorhanden, aber spezifische LPIC-Prüfungsdetails (Befehle/Flags/Pfade) fehlen.
* **[O] Offen:** Noch nicht im Kurs behandelt.

---

### 📘 LPIC-1: EXAM 101 (LPI-101-500)

#### Thema 101: Systemarchitektur

* **101.1 Hardware-Einstellungen ermitteln & konfigurieren [T]**  
  * *Abgedeckt (Tag 02):* `lspci`, `lsusb`, `lsmod`, `modinfo`.
  * *Offen (Lücken):* `/proc/cpuinfo`, `/proc/dma`, `/proc/interrupts`, `/proc/ioports`, udev-Regeln (`/etc/udev/rules.d/`), `udevadm` (Monitor, Trigger, Info), `/lib/modules/$(uname -r)/modules.dep`.
  > [!IMPORTANT]
  > **LPIC-1 Prüfungsrelevanz:**
  > * Wissen über den Unterschied von Kalt- (Coldplug) und Warmstart-Geräten (Hotplug).
  > * Modulabhängigkeiten auflösen: `modprobe` liest `/lib/modules/.../modules.dep` aus, das durch `depmod` generiert wird. `insmod` hingegen benötigt den direkten Pfad zur `.ko`-Datei und ignoriert Abhängigkeiten!

* **101.2 System booten [O]**  
  * *Offen:* BIOS vs. UEFI, GRUB2-Bootvorgang, Kernel-Initialisierung, `initramfs`, systemd-Initialisierung.
  * *Relevante Befehle/Dateien:* `dmesg`, `/var/log/dmesg`, `/var/log/syslog` bzw. `/var/log/messages`.
  > [!IMPORTANT]
  > **LPIC-1 Prüfungsrelevanz:**
  > * Systemstart abfangen: Kernel-Boot-Parameter zur Laufzeit ändern (z. B. `init=/bin/bash` oder `systemd.unit=rescue.target`), um ein kompromittiertes Root-Passwort zurückzusetzen.

* **101.3 Runlevels / Boot-Targets wechseln, System herunterfahren/neustarten [O]**  
  * *Offen:* Systemd-Targets vs. SysV-Runlevels, Einstellungsdateien, System-Shutdown.
  * *Relevante Befehle/Dateien:* `systemctl isolate`, `systemctl get-default`, `systemctl set-default`, `/etc/inittab`, `init`, `telinit`, `runlevel`, `shutdown`, `reboot`, `halt`, `poweroff`, `wall`.
  > [!IMPORTANT]
  > **LPIC-1 Prüfungsrelevanz:**
  > * **Systemd vs. SysV-Init Zuordnung:**
  >   * Runlevel 1 (Single User) ➡️ `rescue.target`
  >   * Runlevel 3 (Multi-User CLI) ➡️ `multi-user.target`
  >   * Runlevel 5 (Graphical GUI) ➡️ `graphical.target`
  >   * Runlevel 6 (Reboot) ➡️ `reboot.target`
  > * Der Befehl `wall "Nachricht"` sendet eine Broadcast-Nachricht an alle angemeldeten Benutzer-Terminals, bevor das System heruntergefahren wird.

---

#### Thema 102: Installation und Paketmanagement

* **102.1 Festplattenlayout entwerfen [O]**  
  * *Offen:* MBR (Master Boot Record) vs. GPT (GUID Partition Table), Swap-Konzeption, Einhängepunkte separat partitionieren (`/home`, `/var`, `/boot`), LVM-Konzepte.
  > [!TIP]
  > **Prüfungskniff:** MBR erlaubt maximal 4 primäre Partitionen (oder 3 primäre und 1 erweiterte mit logischen Partitionen). GPT erlaubt standardmäßig bis zu 128 primäre Partitionen und nutzt 64-Bit-LBA-Adressierung.

* **102.2 Bootmanager installieren [O]**  
  * *Offen:* GRUB 2 Architektur, Konfiguration, Installation auf dem Bootsektor.
  * *Relevante Befehle/Dateien:* `grub-install`, `/etc/default/grub`, `/boot/grub/grub.cfg`, `grub2-mkconfig`.
  > [!CAUTION]
  > Die Datei `/boot/grub/grub.cfg` darf **niemals direkt** editiert werden! Jede manuelle Änderung wird beim nächsten Kernel-Update überschrieben. Änderungen müssen in `/etc/default/grub` oder `/etc/grub.d/` vorgenommen und mittels `grub-mkconfig -o /boot/grub/grub.cfg` (bzw. `update-grub` unter Debian) neu generiert werden.

* **102.3 Shared Libraries verwalten [A]**  
  * *Abgedeckt (Tag 07):* `ldd`, `ldconfig`, `/etc/ld.so.conf`, `/etc/ld.so.cache`, `LD_LIBRARY_PATH`.
  > [!IMPORTANT]
  > **LPIC-1 Prüfungsrelevanz:**
  > * Wenn neue Bibliotheken in `/usr/local/lib` installiert werden, müssen sie in `/etc/ld.so.conf` eingetragen und mit dem Befehl `ldconfig` (als root) in den Cache `/etc/ld.so.cache` eingelesen werden, damit Programme sie finden.

* **102.4 Debian-Paketverwaltung nutzen [O]**  
  * *Offen:* Low-Level- und High-Level-Paketmanagement unter Debian/Ubuntu.
  * *Relevante Befehle/Dateien:* `dpkg` (inkl. Flags `-i`, `-r`, `-P`, `-l`, `-s`, `-S`, `-L`), `apt`, `apt-get`, `apt-cache`, `/etc/apt/sources.list`.
  > [!IMPORTANT]
  > **Debian-Befehlsmatrix:**
  > * **Paket suchen:** `apt-cache search`
  > * **Paket details anzeigen:** `apt-cache show`
  > * **Paket restlos entfernen (inkl. Konfig):** `dpkg -P` (Purge) oder `apt-get purge`
  > * **Herausfinden, zu welchem Paket eine installierte Datei gehört:** `dpkg -S /pfad/zur/datei`

* **102.5 RPM- und YUM/DNF-Paketverwaltung nutzen [T]**  
  * *Abgedeckt (Tag 08):* DNF-Basics (`install`, `upgrade`, `remove`).
  * *Offen (Lücken):* RPM Low-Level-Befehle, RPM-Verifikation, YUM-Repositories.
  * *Relevante Befehle/Dateien:* `rpm` (Flags: `-i`, `-U`, `-e`, `-q`, `-qa`, `-qf`, `-ql`, `-qi`, `-V`), `/etc/yum.repos.d/`.
  > [!IMPORTANT]
  > **RPM-Befehlsmatrix:**
  > * **Update (installiert falls nicht vorhanden):** `rpm -Uvh paket.rpm`
  > * **Installieren (schlägt fehl, falls bereits vorhanden):** `rpm -ivh paket.rpm`
  > * **Abfragen, zu welchem Paket eine Datei gehört:** `rpm -qf /bin/bash`
  > * **Verifizieren aller installierten Paketdateien:** `rpm -V` (meldet Abweichungen in Größe, MD5, Rechten).

* **102.6 Linux als Virtualisierungs-Gast betreiben [O]**  
  * *Offen:* VM-Erkennung, Gasterweiterungen, Cloud-init Konzepte.
  > [!NOTE]
  > Ein Linux-System kann über Befehle wie `systemd-detect-virt` oder das Auslesen von `/sys/class/dmi/id/product_name` herausfinden, ob es in einer virtuellen Umgebung (KVM, VirtualBox, VMware) läuft.

---

#### Thema 103: GNU- und Unix-Befehle

* **103.1 Auf der Befehlszeile arbeiten [A]**  
  * *Abgedeckt (Tag 01):* Bash-Syntax, Umgebungsvariablen (`export`, `unset`), Aliase, History.
* **103.2 Textströme mit Filtern verarbeiten [A]**  
  * *Abgedeckt (Tag 04 & 10):* `cat`, `tac`, `less`, `head`, `tail`, `wc`, `tr`, `cut`, `sort`, `uniq`, `od`, `paste`, `split`, `join`, `sed` (Suchen & Ersetzen).
* **103.3 Grundlegende Dateiverwaltung durchführen [A]**  
  * *Abgedeckt (Tag 02):* `cp`, `rm`, `mv`, `mkdir`, `rmdir`, `touch`, `stat`, `file`, Wildcards, Globbing.
  > [!TIP]
  > **Prüfungs-Liebling:** `cp -a` (Archive) ist äquivalent zu `-dpR` (erhält Symlinks, Rechte, Besitzer und kopiert rekursiv).
* **103.4 Ströme, Pipes und Umlenkungen nutzen [A]**  
  * *Abgedeckt (Tag 01):* `stdin` (0), `stdout` (1), `stderr` (2), Umlenkungen (`2>`, `&>`), `xargs`, `tee`.
* **103.5 Prozesse erstellen, überwachen und beenden [A]**  
  * *Abgedeckt (Tag 06):* `ps`, `pstree`, `top`, `kill`, `pkill`, `killall`, Signale (SIGTERM=15, SIGKILL=9, SIGHUP=1).
* **103.6 Prioritäten von Prozessen ändern [A]**  
  * *Abgedeckt (Tag 06):* `nice` (Wert setzen bei Start, Standard: +10), `renice` (Wert zur Laufzeit ändern mit `-p`). Nice-Bereich: `-20` (höchste Prio) bis `19` (niedrigste Prio). Nur root darf negative Werte vergeben!
* **103.7 Textdateien mit regulären Ausdrücken durchsuchen [A]**  
  * *Abgedeckt (Tag 09 & 10):* `grep`, `egrep` (`grep -E`), `fgrep` (`grep -F`), BRE vs. ERE.
* **103.8 Grundlegende Dateieditierung mit vi [A]**  
  * *Abgedeckt (Tag 11):* vi-Modi (Befehl, Einfügen, Ex), Navigation, Absturzwiederherstellung (`-r`).
  > [!NOTE]
  > Im Befehlsmodus verbindet die Taste **`J`** (großes J) die aktuelle Zeile mit der darunterliegenden Zeile unter Entfernung des Zeilenumbruchs. Zum schnellen Speichern und Verlassen kann **`ZZ`** genutzt werden.

---

#### Thema 104: Geräte, Linux-Dateisysteme, FHS

* **104.1 Partitionen und Dateisysteme erstellen [O]**  
  * *Offen:* `fdisk`, `gdisk`, `parted`, Dateisysteme formatieren (`mkfs.ext4`, `mkfs.xfs`), Swap-Bereiche anlegen.
  * *Relevante Befehle/Dateien:* `mkswap`, `swapon`, `swapoff`.
* **104.2 Integrität von Dateisystemen pflegen [O]**  
  * *Offen:* Systemprüfungen, Superblocks auslesen, Tuning.
  * *Relevante Befehle/Dateien:* `fsck`, `e2fsck`, `tune2fs`, `dumpe2fs`, `debugfs`, `df`, `du`.
  > [!IMPORTANT]
  > **LPIC-1 Prüfungsrelevanz:**
  > * `tune2fs -c 20 /dev/sda1` setzt die maximale Anzahl an Mounts vor einer Dateisystemprüfung auf 20.
  > * `tune2fs -i 3m /dev/sda1` setzt das Prüfungsintervall auf 3 Monate.
  > * `tune2fs -m 1 /dev/sda1` reserviert nur noch 1% des Speicherplatzes exklusiv für root (Standard: 5%).

* **104.3 Einhängen & Aushängen von Dateisystemen steuern [O]**  
  * *Offen:* Mount-Prozeduren, `/etc/fstab`-Syntax, Mount-Flags.
  * *Relevante Befehle/Dateien:* `mount`, `umount`, `/etc/fstab`, UUID, LABEL, `/proc/mounts`.
  > [!IMPORTANT]
  > **`/etc/fstab` Syntax-Schema:**
  > `[Gerät/UUID/LABEL]  [Einhängepunkt]  [Dateisystemtyp]  [Mount-Optionen]  [Dump-Flag]  [FSCK-Reihenfolge]`
  > * **Mount-Optionen:** `noatime` (kein Schreibzugriff beim Lesen - erhöht Performance), `ro` (read-only), `nosuid` (ignoriert SUID-Bits auf dieser Partition - Sicherheitsfeature), `nodev` (ignoriert Gerätedateien).
  > * **Dump:** `0` (nicht sichern), `1` (sichern).
  > * **FSCK:** `0` (nicht prüfen), `1` (höchste Prio für Root-Partition `/`), `2` (andere Partitionen).

* **104.4 Dateiquoten verwalten [O]**  
  * *Offen:* User- und Gruppen-Quotas aktivieren, Limits setzen.
  * *Relevante Befehle/Dateien:* `/etc/fstab` (`usrquota`, `grpquota`), `quotacheck`, `quotaon`, `quotaoff`, `edquota`, `setquota`, `repquota`.
  > [!IMPORTANT]
  > **LPIC-1 Quota-Wissen:**
  > * **Soft-Limit:** Der Benutzer erhält eine Warnung, darf das Limit aber für eine bestimmte Übergangszeit (Grace Period, standardmäßig 7 Tage) überschreiten.
  > * **Hard-Limit:** Absolutes Limit. Ein Überschreiten ist technisch unmöglich und führt zu einem "Disk quota exceeded"-Schreibfehler.
  > * **edquota -u username:** Öffnet den Standard-Texteditor, um Quotas für den User anzupassen.
  > * **repquota -a:** Erstellt einen tabellarischen Quota-Report für alle eingehängten Dateisysteme.

* **104.5 Dateiberechtigungen und -eigentümer verwalten [A]**  
  * *Abgedeckt (Tag 05):* `chmod`, `chown`, `chgrp`, `umask`, SUID, SGID, Sticky Bit.
* **104.6 Harte und symbolische Links erstellen [A]**  
  * *Abgedeckt (Tag 05):* `ln`, `ln -s`, Inode-Verhalten.
* **104.7 Systemdateien finden und am richtigen Ort platzieren [A]**  
  * *Abgedeckt (Tag 01 & 02):* FHS-Verzeichnisse, `find`, `locate`, `which`, `whereis`, `updatedb`.

---

### 📙 LPIC-1: EXAM 102 (LPI-102-500)

#### Thema 105: Shells und Shell-Scripting

* **105.1 Shell-Umgebung anpassen & nutzen [A]**  
  * *Abgedeckt (Tag 03):* `/etc/profile`, `~/.bash_profile`, `~/.bashrc`, `~/.bash_logout`, Aliase, Funktionen.
* **105.2 Einfache Skripte schreiben [A]**  
  * *Abgedeckt (Tag 08, 10, 13):* Shebang (`#!/bin/bash`), Schleifen (`for`, `while`), Bedingungen (`if`, `case`), Variablen, Exit-Codes.

---

#### Thema 106: Benutzeroberflächen und Desktops

* **106.1 X11 installieren & konfigurieren [O]**  
  * *Offen:* Xorg-Architektur, Konfigurationen, Display-Manager.
  * *Relevante Befehle/Dateien:* `/etc/X11/xorg.conf`, `DISPLAY` Variable, `xhost`, `xauth`, Wayland.
  > [!IMPORTANT]
  > **LPIC-1 Prüfungsrelevanz:**
  > * `DISPLAY=:0.0` verweist auf den ersten lokalen Bildschirm des ersten X-Servers auf dem Rechner.
  > * `xhost +192.168.1.50` erlaubt diesem entfernten Host, Fenster auf dem lokalen X-Server darzustellen.
  > * `/etc/X11/xorg.conf` ist in Sektionen unterteilt: `Files`, `InputDevice`, `Monitor`, `Device` (Grafikkarte), `Screen` (Kombination aus Monitor & Device), `ServerLayout`.

* **106.2 Grafische Desktops [O]**  
  * *Offen:* Desktop-Umgebungen (KDE, GNOME, XFCE), Remote-Desktops (VNC, RDP, X11-Forwarding via `ssh -X`).
* **106.3 Barrierefreiheit (Accessibility/a11y) [O]**  
  * *Offen:* Hilfen für eingeschränkte Nutzer.
  * *Konzepte:* Sticky Keys (Einrastende Tasten), Bounce Keys (Tastaturverzögerung), Slow Keys, Screen Reader (Orca), Bildschirmlupe.

---

#### Thema 107: Administrative Aufgaben

* **107.1 Benutzer- und Gruppenkonten verwalten [A]**  
  * *Abgedeckt (Tag 13):* `/etc/passwd`, `/etc/shadow`, `/etc/group`, `/etc/gshadow`, `useradd`, `usermod`, `userdel`, `groupadd`, `groupmod`, `groupdel`, `passwd`, `chage`.
  > [!IMPORTANT]
  > **LPIC-1 Schattenpasswort-Aufbau (`/etc/shadow`):**
  > `student:$6$rounds=4096$...:19143:0:99999:7:3:20000:`
  > 1. Username (`student`)
  > 2. Verschlüsseltes Passwort (beginnt mit `$6$` für SHA-512)
  > 3. Letzte Passwortänderung in Tagen seit dem 01.01.1970 (`19143`)
  > 4. Mindestalter in Tagen vor einer erneuten Änderung (`0`)
  > 5. Maximalalter in Tagen vor erzwungener Änderung (`99999`)
  > 6. Vorwarnzeit in Tagen (`7`)
  > 7. Inaktivitätszeit in Tagen nach Ablauf (`3`)
  > 8. Ablaufdatum des Kontos als Epochen-Tage (`20000`)
  > 9. Reserviertes Feld

* **107.2 Systemadministration durch Job-Scheduling automatisieren [A]**  
  * *Abgedeckt (Tag 12):* `cron`, `crontab`, `anacron`, `at`, `/etc/cron.allow`, `/etc/cron.deny`.
  > [!IMPORTANT]
  > **Cron-Aufbau-Unterschiede:**
  > * **User-Crontab (`crontab -e`):** 5 Zeitfelder + Befehl.
  >   `* * * * * /usr/bin/mybackup.sh`
  > * **System-Crontab (`/etc/crontab`):** 6 Zeitfelder + **Benutzer** + Befehl!
  >   `* * * * * root /usr/bin/mybackup.sh`

* **107.3 Lokalisierung und Internationalisierung [O]**  
  * *Offen:* Locale-Variablen, Tastaturlayouts, Zeitzonen.
  * *Relevante Befehle/Dateien:* `locale`, `localectl`, `LANG`, `LC_ALL`, `LC_CTYPE`, `LC_TIME`, `/usr/share/zoneinfo/`, `/etc/localtime`, `/etc/timezone`.
  > [!IMPORTANT]
  > **Locale-Hierarchie:**
  > * **`LANG`** definiert das systemweite Standard-Sprachverhalten.
  > * **`LC_ALL`** überschreibt **alle** anderen `LC_*` Variablen bedingungslos!
  > * **`LC_CTYPE`** bestimmt die Zeichenkodierung (z.B. UTF-8).
  > * **`LC_TIME`** steuert das Datums- und Uhrzeitformat.

---

#### Thema 108: Essenzielle Systemdienste

* **108.1 Systemzeit pflegen [A]**  
  * *Abgedeckt (Tag 17):* `hwclock`, `timedatectl`, `chrony`, NTP-Konfiguration.
* **108.2 Systemprotokollierung / Logging [O]**  
  * *Offen:* Syslog-Daemon, Systemd-Journal, Log-Rotation.
  * *Relevante Befehle/Dateien:* `rsyslogd`, `/etc/rsyslog.conf`, `systemd-journald`, `journalctl`, `logrotate`, `/etc/logrotate.conf`, `/var/log/journal/`.
  > [!IMPORTANT]
  > **LPIC-1 Syslog-Regeln in `/etc/rsyslog.conf`:**
  > `[Facility].[Priority]      [Destination]`
  > * **Facilities:** `auth`, `authpriv`, `cron`, `daemon`, `kern`, `mail`, `user`, `local0-7`.
  > * **Priorities:** `debug`, `info`, `notice`, `warning`, `err`, `crit`, `alert`, `emerg`.
  > * **Beispiel:** `mail.err  /var/log/mail.err` (protokolliert alle Mail-Fehler der Stufe *err* und kritischer).
  > * **Beispiel:** `*.emerg   *` (sendet alle Notfallmeldungen als Broadcast an alle Terminals).
  > * **Journalctl Filter:** `journalctl -u sshd.service --since "yesterday" -p err`

* **108.3 Mail Transfer Agent (MTA) Grundlagen [O]**  
  * *Offen:* SMTP-Architektur, Mail-Weiterleitung, Mail-Warteschlange.
  * *Relevante Befehle/Dateien:* `postfix`, `sendmail`, `exim`, `/etc/aliases`, `newaliases`, `mailq`, `mail`.
  > [!NOTE]
  > Nach jeder Modifikation der Alias-Tabelle `/etc/aliases` muss zwingend der Befehl **`newaliases`** ausgeführt werden, um die indexierte Binärdatenbank `/etc/aliases.db` neu aufzubauen!

* **108.4 Drucker und Drucken verwalten [A]**  
  * *Abgedeckt (Tag 03):* CUPS-Architektur, `lp`, `lpq`, `lpstat`, `lprm`, `/etc/cups/`.

---

#### Thema 109: Netzwerk-Grundlagen

* **109.1 Grundlegende Internetprotokolle [A]**  
  * *Abgedeckt (Tag 15):* IPv4/IPv6-Adressierung, Subnetting, `/etc/services`.
* **109.2 Persistente Netzwerkkonfiguration [A]**  
  * *Abgedeckt (Tag 16):* `/etc/network/interfaces` (Debian), Netplan (Ubuntu), `/etc/sysconfig/network-scripts/` (RHEL), `nmcli`, `nmtui`.
* **109.3 Grundlegendes Netzwerk-Troubleshooting [A]**  
  * *Abgedeckt (Tag 16 & 17):* `ping`, `traceroute`, `tracepath`, `ss`, `netstat` (Legacy), `ip route`.
  > [!WARNING]
  > In der LPIC-1-Prüfung werden legacy Netzwerkbefehle wie `ifconfig`, `route` und `netstat` weiterhin aktiv abgefragt, obwohl sie in modernen Distributionen durch die `iproute2`-Suite (`ip addr`, `ip route`, `ss`) abgelöst wurden! Beide Welten müssen zwingend beherrscht werden.
* **109.4 Clientseitiges DNS konfigurieren [A]**  
  * *Abgedeckt (Tag 15 & 16):* `/etc/resolv.conf`, `/etc/hosts`, `/etc/nsswitch.conf`, `host`, `dig`, `getent`.

---

#### Thema 110: Sicherheit

* **110.1 Sicherheitsadministration [T]**  
  * *Abgedeckt (Tag 05 & 06):* SUID/SGID Audit, `/etc/shadow`.
  * *Offen (Lücken):* `ulimit`, `/etc/security/limits.conf`, `/etc/sudoers` Konfiguration via `visudo`.
  > [!IMPORTANT]
  > **Sudoers-Eintrag Syntax:**
  > `student  ALL=(ALL:ALL) NOPASSWD: /usr/bin/systemctl restart nginx`
  > * Benutzer `student` darf auf **allen** Hosts (`ALL`) als **beliebiger Benutzer/Gruppe** (`ALL:ALL`) den spezifischen Befehl zum Neustarten von Nginx ohne Passworteingabe (`NOPASSWD`) ausführen.

* **110.2 Grundlegende Systemsicherheit einrichten [O]**  
  * *Offen:* SSH-Härtung, Key-basierte Authentifizierung, TCP-Wrapper.
  * *Relevante Befehle/Dateien:* `/etc/ssh/sshd_config`, `ssh-keygen`, `ssh-copy-id`, `ssh-agent`, `ssh-add`, `/etc/hosts.allow`, `/etc/hosts.deny`.
  > [!IMPORTANT]
  > **TCP Wrapper Funktionsweise:**
  > Trifft eine Verbindung für einen Service (z.B. `sshd`) ein, wird zuerst `/etc/hosts.allow` geprüft. Gibt es einen Match, wird die Verbindung zugelassen. Falls nicht, wird `/etc/hosts.deny` geprüft. Gibt es dort einen Match, wird sie blockiert. Trifft keines von beiden zu, wird sie **zugelassen** (Standardverhalten).

* **110.3 Daten durch Verschlüsselung sichern [O]**  
  * *Offen:* GnuPG-Verschlüsselung, SSH-Tunneling (Port Forwarding).
  * *Relevante Befehle/Dateien:* `gpg` (inkl. `--gen-key`, `-e`, `-d`, `-s`, `--verify`), `ssh -L` (Local), `ssh -R` (Remote).
  > [!IMPORTANT]
  > **SSH Port Forwarding:**
  > * **Lokales Forwarding (`ssh -L 8080:localhost:80 user@remote`):** Bindet Port 8080 auf dem **lokalen** Client an Port 80 auf dem **entfernten** Server.
  > * **Entferntes Forwarding (`ssh -R 8080:localhost:80 user@remote`):** Bindet Port 8080 auf dem **entfernten** Server an Port 80 auf dem **lokalen** Client (ideal für Reverse Shells / Zugriff hinter NAT).

---

## 📅 3. Exakter Lehrplan für die Tage 18 bis 30

Um alle identifizierten Lücken zu schließen und eine **100%ige Prüfungsreife** zu erzielen, wird folgender chronologischer Lehrplan umgesetzt:

```mermaid
gantt
    title LPIC-1 Rest-Lehrplan (Tage 18 - 30)
    dateFormat  D
    axisFormat Tag %d
    
    section Modul A: Dateisysteme & Speicher (T18 - T20)
    Tag 18: Partitionierung & Formatierung     :active, 18, 19
    Tag 19: Mounts & /etc/fstab                : 19, 20
    Tag 20: Dateisystem-Integrität & Quotas     : 20, 21
    
    section Modul B: Booten & Pakete (T21 - T23)
    Tag 21: Bootprozess & GRUB2                : 21, 22
    Tag 22: Systemd-Targets & Runlevels        : 22, 23
    Tag 23: Paketverwaltung (dpkg/rpm) & VM-Gast: 23, 24
    
    section Modul C: Logging & MTAs (T24 - T25)
    Tag 24: Rsyslog & Journald                 : 24, 25
    Tag 25: MTA (Mail) & Lokalisierung         : 25, 26
    
    section Modul D: Desktop & Sicherheit (T26 - T28)
    Tag 26: X11, Wayland & Barrierefreiheit    : 26, 27
    Tag 27: SSH Hardening & Limits (ulimit)    : 27, 28
    Tag 28: GPG Verschlüsselung & SSH-Tunnel   : 28, 29
    
    section Modul E: Prüfungssimulation (T29 - T30)
    Tag 29: Große LPIC-1 Simulation (101)      : 29, 30
    Tag 30: Große LPIC-1 Simulation (102)      : 30, 31
```

### Detaillierter Tagesplan (Syllabus)

#### 💽 Modul A: Dateisysteme & Speicherverwaltung (Tag 18 – 20)
* **Tag 18: Festplatten-Partitionierung & Formatierung**
  * *Fokus:* MBR vs. GPT. Befehle `fdisk`, `gdisk` und `parted`. Dateisysteme erstellen (`mkfs.ext4`, `mkfs.xfs`). Swap-Bereiche initialisieren (`mkswap`) und steuern (`swapon`, `swapoff`).
* **Tag 19: Dateisystem-Mounts & die `/etc/fstab`**
  * *Fokus:* Temporäre Mounts mit `mount` und `umount`. Struktur und Parameter der persistenten Steuerungsdatei `/etc/fstab` (Mounten über UUIDs, Labels, Einhänge-Flags wie `noatime`, `nodev`, `nosuid`).
* **Tag 20: Dateisystem-Integrität & Quotas**
  * *Fokus:* Dateisystemprüfungen mit `fsck` und `e2fsck`. Parameteränderung an ext-Dateisystemen mit `tune2fs`, Auslesen von Superblocks mit `dumpe2fs` und Speicherplatzanalyse mit `df` und `du`. Quota-Einrichtung (`usrquota`, `grpquota`, `quotacheck`, `edquota`, `repquota`).

#### 🔌 Modul B: Boot-Prozess, Init & Paketverwaltung (Tag 21 – 23)
* **Tag 21: Boot-Vorgang & GRUB2-Bootmanager**
  * *Fokus:* Vom BIOS/UEFI zum Kernel. GRUB2-Installation (`grub-install`), Boot-Parameter zur Laufzeit ändern und dauerhaft in `/etc/default/grub` konfigurieren (`grub2-mkconfig`). Boot-Protokolle mit `dmesg` auslesen.
* **Tag 22: Systemd-Diensteverwaltung & Runlevels**
  * *Fokus:* Starten, Stoppen und Aktivieren von Units (`systemctl`). Wechseln von Systemd-Boot-Targets (`systemctl isolate`). Analyse historischer Runlevels (`/etc/inittab`, `init`, `telinit`). System-Shutdowns administrativ absichern (`shutdown`, `wall`).
* **Tag 23: Debian-Pakete & Low-Level RPM/YUM**
  * *Fokus:* Paketverwaltung unter Debian/Ubuntu mit `dpkg` and `apt`. Tiefenprüfung von RPM-Paketen (`rpm` Flags `-ivh`, `-e`, `-qa`, `-qf`, `-V`). Linux als Virtualisierungs-Gast (Virtualisierungs-Erkennung, Cloud-init Basics).

#### 📊 Modul C: Logging, MTAs & Lokalisierung (Tag 24 – 25)
* **Tag 24: Protokollierung mit Rsyslog & Journald**
  * *Fokus:* Konfiguration des Syslog-Daemons in `/etc/rsyslog.conf` (Facilities, Priorities, Destinations). Analyse und Filterung von Systemd-Journal-Dateien mit dem Werkzeug `journalctl` (Zeitfilter, PID-Filter, Unit-Filter). Log-Rotation via `logrotate`.
* **Tag 25: Mail Transfer Agents & Lokalisierung**
  * *Fokus:* Mail-Dienste verstehen (Postfix, Sendmail, Exim). Weiterleitungen in `/etc/aliases` konfigurieren und Testmails senden mit `mail`. Systemsprachen und Zeitzonen dauerhaft anpassen (`localectl`, `locale`, `LANG`, `LC_*`, `/usr/share/zoneinfo/`, `/etc/localtime`).

#### 🔒 Modul D: Desktop-Schnittstellen & Systemhärtung (Tag 26 – 28)
* **Tag 26: X11-Architektur, Wayland & Barrierefreiheit**
  * *Fokus:* Die grafische Oberfläche verstehen. X-Server, Display-Manager (GDM, LightDM, `/etc/X11/xorg.conf`) und Barrierefreiheit (a11y-Tastatureinstellungen wie Sticky Keys, Slow Keys).
* **Tag 27: OpenSSH Server Hardening & Key-basierte Authentifizierung**
  * *Fokus:* Absicherung des SSH-Daemons (`/etc/ssh/sshd_config` - Root-Login verbieten, Ports ändern). Generieren von SSH-Keys (`ssh-keygen`), Key-Verteilung (`ssh-copy-id`). Zugriffsbeschränkung über TCP-Wrapper (`/etc/hosts.allow`, `/etc/hosts.deny`). Festlegen von Benutzer-Ressourcenlimits (`ulimit` und `/etc/security/limits.conf`).
* **Tag 28: GnuPG Verschlüsselung & SSH-Tunneling**
  * *Fokus:* Verschlüsseln und Signieren von Dateien und E-Mails mit GnuPG (`gpg`). SSH-Portweiterleitungen (lokales und entferntes Port-Forwarding über SSH-Tunnel) zur sicheren Kapselung unsicherer Protokolle.

#### 🏁 Modul E: LPIC-1 Prüfungssimulation (Tag 29 – 30)
* **Tag 29: Große Prüfungssimulation - LPI 101**
  * *Fokus:* Realistischer Test über 60 Fragen aus den Themen 101 bis 104 unter Prüfungsbedingungen inklusive detaillierter Fehleranalyse.
* **Tag 30: Große Prüfungssimulation - LPI 102**
  * *Fokus:* Realistischer Test über 60 Fragen aus den Themen 105 bis 110 unter Prüfungsbedingungen inklusive detaillierter Fehleranalyse.

---

## 🎯 4. Fazit & Nächste Schritte

Mit dem Abschluss von Tag 17 ist der Grundstein gelegt. Der Übergang in die systemnähere Administration ab Tag 18 wird die verbleibenden Wissenslücken systematisch schließen.

> [!TIP]
> Um das Gelernte zu festigen, empfiehlt es sich, die in diesem Dokument aufgeführten `> [!IMPORTANT]`-Blöcke als direkte Lernkarten zu verwenden. Sie enthalten exakt die syntaktischen Stolpersteine, die in den echten LPIC-1-Prüfungen den Unterschied zwischen Bestehen und Nichtbestehen ausmachen.
