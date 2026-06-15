# 🌐 Zeitverwaltung & Port-Weiterleitung mit iptables — Tag 17

![Linux Essentials Day 17 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 100% Dokumentiert & LPIC-1 Fokussiert  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📑 Inhaltsverzeichnis
- [⏰ 1. Die Zeitverwaltung unter Linux](#-1-die-zeitverwaltung-unter-linux)
  - [A. Hardware- vs. Systemuhr](#a-hardware--vs-systemuhr)
  - [B. Manuelles Stellen der Systemzeit (date)](#b-manuelles-stellen-der-systemzeit-date)
- [🌐 2. Zeitsynchronisation mit NTP](#-2-zeitsynchronisation-mit-ntp)
  - [A. Der klassische Daemon (ntpd & ntp.conf)](#a-der-klassische-daemon-ntpd--ntpconf)
  - [B. Einmaliger Abgleich mit ntpdate](#b-einmaliger-abgleich-mit-ntpdate)
  - [C. Der moderne Standard: chrony](#c-der-moderne-standard-chrony)
  - [D. Leichtgewichtiger Client: systemd-timesyncd](#d-leichtgewichtiger-client-systemd-timesyncd)
- [🔌 3. Port-Weiterleitung mit iptables](#-3-port-weiterleitung-mit-iptables)
  - [Schritt-für-Schritt-Workflow](#schritt-für-schritt-workflow)
- [🎮 Das optionale OmniTUI Showcase-Tool](#-das-optionale-omnitui-showcase-tool)
- [🧠 LPIC-1 Relevanz & Wissenstest](#-lpic-1-relevanz--wissenstest)
- [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

---

## ⏰ 1. Die Zeitverwaltung unter Linux

Eine korrekte Systemzeit ist essenziell für die Auswertung von Protokolldateien, Dateisicherungen und netzwerkweite Authentifizierungsdienste.

### A. Hardware- vs. Systemuhr

Unter Linux existieren zwei voneinander unabhängige Uhren im System:

1. **CMOS-Uhr (Hardware-Uhr / Real Time Clock / RTC):**
   * Batteriebetrieben auf dem Mainboard.
   * Läuft auch bei ausgeschaltetem Computer weiter.
   * Wird beim Systemstart ausgelesen, um die Kernel-Uhr zu initialisieren.

2. **Kernel-Uhr (Systemuhr / Software-Uhr):**
   * Wird vom Linux-Kernel im laufenden Betrieb im RAM gehalten.
   * Zählt fortlaufend die Sekunden (Unix-Zeit) seit dem **01.01.1970 um 00:00:00 UTC** (Epoch).
   * Dient dem System zur Generierung von Dateizeitstempeln und Logbucheinträgen.

#### 🛠️ Steuerung über `hwclock`:
Mit dem Befehl `hwclock` greift der Administrator direkt auf die CMOS-Uhr zu.

```bash
# Zeigt die aktuelle Zeit der Hardware-Uhr an
sudo hwclock --show   # oder: hwclock -r

# CMOS-Uhr in Systemzeit (Kernelzeit) umrechnen & Kernel-Uhr initialisieren
sudo hwclock --hctosys  # oder: hwclock -s

# Aktuelle Kernel-Systemzeit in die CMOS-Uhr schreiben
sudo hwclock --systohc  # oder: hwclock -w
```

> [!NOTE]  
> Die Hardware-Uhr ist physikalisch ungenau. `hwclock` berechnet und protokolliert die systematische Abweichung (Drift) der CMOS-Uhr automatisch in der Datei **`/etc/adjtime`**, um diese bei Systemneustarts zu korrigieren.

---

### B. Manuelles Stellen der Systemzeit (`date`)

Die Systemuhr kann im laufenden Betrieb mit dem Befehl `date` manuell eingestellt werden (erfordert root-Rechte).

```bash
# Syntax: date MMDDhhmmYYYY.ss
# (M=Monat, D=Tag, h=Stunde, m=Minute, Y=Jahr, s=Sekunde)
sudo date 020318012009.30
```

> [!IMPORTANT]  
> **LPIC-1 PRÜFUNGSWISSEN - date-Format:**  
> Das obige Beispiel `date 020318012009.30` stellt das Datum auf den **3. Februar 2009 um 18:01:30 Uhr**.  
> * **UTC-Option:** Mit dem Flag **`-u`** (`date -u ...`) wird die angegebene Zeit als koordinierte Weltzeit (UTC) interpretiert, anstatt die lokale Zeitzone des Systems anzuwenden.

---

## 🌐 2. Zeitsynchronisation mit NTP

Um Abweichungen zu minimieren, wird die Kernel-Zeit über das **Network Time Protocol (NTP)** kontinuierlich mit weltweiten Referenzzeitservern abgeglichen.

### A. Der klassische Daemon (`ntpd` & `ntp.conf`)

Das klassische Werkzeug zur permanenten Synchronisation im Hintergrund ist der Daemon `ntpd`. Er kommuniziert als Client mit Zeitservern und kann im lokalen Netzwerk selbst als NTP-Server für andere Rechner agieren.

* **Konfigurationsdatei:** `/etc/ntp.conf` (bzw. `ntpd.conf`)

#### ⚙️ Beispiel für eine `/etc/ntp.conf` mit Erläuterung:
```text
# Lokale Uhr als Notfall-Zeitquelle definieren (Stratum 10 = unsynchronisiert)
server 127.127.1.0
fudge 127.127.1.0 stratum 10

# Zeitserver aus dem öffentlichen Pool eintragen
server 0.de.pool.ntp.org iburst
server 1.de.pool.ntp.org iburst
server 2.de.pool.ntp.org iburst

# Abweichungsverfolgung (Driftfile) und Logs
driftfile /var/lib/ntp/ntp.drift
logfile /var/log/ntp
```

> [!TIP]  
> Das Flag **`iburst`** (initial burst) sendet beim Verbindungsaufbau vier schnelle Pakete im Abstand von 2 Sekunden an den Server. Dies beschleunigt den ersten Synchronisationsprozess beim Start des Daemons erheblich.

> [!IMPORTANT]  
> **LPIC-1 PRÜFUNGSWISSEN - Stratum-Hierarchie:**  
> NTP organisiert Zeitserver hierarchisch in Schichten (Strata):  
> * **Stratum 0:** Atomuhren oder GPS-Empfänger (physische Referenzzeit).  
> * **Stratum 1:** Direkt an Stratum-0-Geräte angebundene Server.  
> * **Stratum 2:** Server, die ihre Zeit über das Netzwerk von Stratum-1-Servern beziehen (Standard-Pools).  
> * Je höher der Stratum-Wert, desto ungenauer ist die Zeitquelle. Der Maximalwert beträgt **15**; ein Wert von **16** bedeutet unsynchronisiert.

---

### B. Einmaliger Abgleich mit `ntpdate`

Mit dem (inzwischen als veraltet eingestuften) Befehl `ntpdate` kann die Uhrzeit einmalig abrupt auf Basis von Zeitservern eingestellt werden. Dies geschieht oft vor dem Starten des permanenten Daemons oder automatisiert über Cronjobs:

```bash
# Einmalige Synchronisation über zwei Zeitserver
sudo ntpdate 0.pool.ntp.org 1.pool.ntp.org

# Anschließend die korrigierte Systemzeit in die CMOS-Uhr übertragen
sudo hwclock --systohc
```

---

### C. Der moderne Standard: `chrony`

`chrony` ist die moderne, empfohlene Alternative zu `ntpd` auf RedHat, Rocky Linux und vielen anderen Systemen. Es synchronisiert die Uhrzeit erheblich schneller und präziser bei instabilen oder zeitweisen Internetverbindungen.

* **Daemon:** `chronyd`
* **CLI-Konfigurations- & Abfragetool:** `chronyc`
* **Konfigurationsdatei:** `/etc/chrony.conf`

#### ⚙️ Beispiel für eine `/etc/chrony.conf` (Minimale Konfiguration):
```text
pool pool.ntp.org iburst
driftfile /var/lib/chrony/drift
makestep 1 3
rtcsync
allow 192.168.1.0/24
```

> [!IMPORTANT]  
> **LPIC-1 PRÜFUNGSWISSEN - chrony.conf Direktiven:**  
> Sie müssen die Bedeutung dieser fünf Direktiven kennen:  
> 1. **`pool` (oder `server`):** Verweist auf die zu nutzenden NTP-Server pools.  
> 2. **`driftfile`:** Pfad zur Datei, in der chronyd die Frequenzabweichung (Drift) des Systemtakts aufzeichnet, um diese nach Neustarts direkt auszugleichen.  
> 3. **`makestep 1 3`:** Erlaubt der Systemuhr, die Zeit durch einen **harten Sprung (step)** zu korrigieren, falls die Abweichung in den ersten **3 Updates** größer als **1 Sekunde** ist. Standardmäßig gleicht chrony Abweichungen nur langsam durch Beschleunigen/Verlangsamen des Taktes aus.  
> 4. **`rtcsync`:** Aktiviert das automatische Kopieren der Systemzeit in die Hardware-Uhr (CMOS/RTC) durch den Kernel **alle 11 Minuten**.  
> 5. **`allow` / `deny`:** Steuert den Zugriff. `allow 192.168.1.0/24` erlaubt Hosts aus diesem Subnetz, diesen Rechner als NTP-Server anzufragen.  

---

### D. Leichtgewichtiger Client: `systemd-timesyncd`

Für reine Clients, die selbst keine Zeitserver-Funktion bereitstellen müssen, liefert systemd den Dienst `systemd-timesyncd` mit (Standard unter Debian).

```bash
# NTP-Client aktivieren
sudo timedatectl set-ntp true

# Status der Zeitsynchronisation abfragen
timedatectl timesync-status
```

> [!WARNING]  
> ** timesyncd Einschränkungen:**  
> `systemd-timesyncd` ist ein reiner SNTP-Client (Simple NTP) und kann **niemals** als Server für andere Rechner im Netzwerk fungieren.

---

## 🔌 3. Port-Weiterleitung mit iptables

**Port-Weiterleitung (Port Forwarding)** ermöglicht es externen Benutzern, auf einen Dienst (z.B. Webserver, Gameserver) in einem privaten, isolierten Netzwerk zuzugreifen, welcher von außen standardmäßig nicht erreichbar ist.

Hierbei greift der Linux-Kernel in den Paketstrom ein und modifiziert die Ziel-IP/Ziel-Ports mittels Destination NAT (DNAT).

### Schritt-für-Schritt-Workflow

#### 1. Schritt: Aktive Regeln verifizieren
Vor der Konfiguration prüfen wir die aktuellen Paketfilterregeln der Firewall:
```bash
sudo iptables -L -v -n
```
* **`-L` (List):** Listet die Regeln aller Ketten (Chains) auf.
* **`-v` (Verbose):** Zeigt detaillierte Paket- und Byte-Zähler an.
* **`-n` (Numeric):** Verhindert DNS-Auflösungen. IP-Adressen und Portnummern werden rein numerisch dargestellt (beschleunigt die Ausgabe).

#### 2. Schritt: IP-Weiterleitung im Kernel aktivieren
Damit der Kernel Pakete zwischen Netzwerkkarten weiterleitet, muss das IP-Forwarding eingeschaltet werden.
```bash
# In der Konfigurationsdatei eintragen:
sudo nano /etc/sysctl.conf
# Folgende Zeile hinzufügen/entkommentieren:
net.ipv4.ip_forward=1
```

#### 3. Schritt: Änderungen dauerhaft übernehmen
```bash
sudo sysctl -p
```
* **`-p`**: Lädt die Einstellungen aus der `/etc/sysctl.conf` sofort neu in den aktiven Kernel.

#### 4. Schritt: Destination NAT (DNAT) einrichten
Wir leiten eingehende Pakete, die am Router auf Port `8080` ankommen, an die IP des Ziel-Clients im internen Netz auf Port `80` (Standard-Webserver) weiter:
```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 172.16.7.42:80
```
* **`-t nat`**: Aktiviert die NAT-Tabelle (Network Address Translation).
* **`-A PREROUTING`**: Hängt die Regel an die PREROUTING-Kette an (Greift, *bevor* eine Routing-Entscheidung getroffen wird).
* **`-p tcp --dport 8080`**: Filtert auf das TCP-Protokoll und den Zielport 8080.
* **`-j DNAT`**: Führt Destination NAT als Aktion aus.
* **`--to-destination IP:Port`**: Setzt die neue interne Zieladresse und den Zielport fest.

#### 5. Schritt: NAT-Masquerading aktivieren
Damit Pakete den Rückweg zum Router finden, müssen ausgehende Pakete auf der externen Schnittstelle maskiert werden:
```bash
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
```
* **`-A POSTROUTING`**: Greift nach der Routing-Entscheidung, kurz vor dem Verlassen der Netzwerkkarte.
* **`-j MASQUERADE`**: Maskiert die private IP-Adresse der ausgehenden Pakete dynamisch mit der IP-Adresse des WAN-Interfaces.

#### 6. Schritt: Regeln persistent abspeichern
Standardmäßig gehen iptables-Regeln bei einem Neustart verloren.
* **Unter Ubuntu / Debian:**
  ```bash
  sudo apt install iptables-persistent
  # Regeln werden automatisch in /etc/iptables/rules.v4 gespeichert
  ```
* **Unter RHEL / Rocky Linux / Fedora:**
  ```bash
  sudo service iptables save
  # Regeln werden persistent in /etc/sysconfig/iptables gesichert
  ```

#### 7. Schritt: Verifizieren der Weiterleitung
Verbinden Sie sich von einem externen Test-Rechner auf den Quellport `8080` des Routers. Nutzen Sie dazu diese Werkzeuge:
* **`nc` (netcat):** `nc -zv <Router-IP> 8080` (prüft, ob der Port offen ist).
* **`telnet`:** `telnet <Router-IP> 8080`
* **`curl`:** `curl http://<Router-IP>:8080` (lädt die Weboberfläche des internen Webservers herunter).

---

## 🎮 Das optionale OmniTUI Showcase-Tool

Zur vollautomatischen und interaktiven Einrichtung all dieser Netzwerk-, Routing- und Zeitsynchronisationsschritte (einschließlich **iptables**, **nftables**, **chrony** und **timedatectl**) steht Ihnen das menügeführte TUI-Werkzeug **OmniTUI** im Verzeichnis zur Verfügung.

> [!TIP]  
> Ausführliche Details zu Architektur und Funktionsumfang des Tools finden Sie im Handbuch:  
> 📖 **[OmniTUI Handbuch (OMNITUI_README.md)](OMNITUI_README.md)**

---

## 🧠 LPIC-1 Relevanz & Wissenstest

<details>
<summary><b>Fragen zu Zeitverwaltung & NTP-Konfiguration (Klicken zum Ausklappen)</b></summary>

1. **Was ist die Aufgabe der Direktive `makestep 1 3` in `/etc/chrony.conf`?**
   <details><summary>Antwort</summary>Sie erlaubt <code>chronyd</code>, die Systemuhr durch einen **harten Zeitsprung (step)** zu korrigieren, anstatt die Zeit langsam anzugleichen (slew), falls die Abweichung in den ersten **3 Updates** größer als **1 Sekunde** ist.</details>

2. **Wie lautet die genaue Syntax, um mit dem Befehl `date` die Systemzeit manuell auf den 15. Oktober 2026 um 12:30 Uhr einzustellen?**
   <details><summary>Antwort</summary>Die Syntax lautet:
   `sudo date 101512302026`  
   *(10 = Monat, 15 = Tag, 12 = Stunde, 30 = Minute, 2026 = Jahr)*</details>

3. **Welche Bedeutung hat der Eintrag `rtcsync` in der chrony-Konfiguration?**
   <details><summary>Antwort</summary>Er veranlasst den Linux-Kernel, die genaue Systemzeit **alle 11 Minuten** automatisch in die Hardware-Uhr (CMOS/Real Time Clock) zurückzuschreiben.</details>

</details>

<details>
<summary><b>Fragen zu iptables & Port-Forwarding (Klicken zum Ausklappen)</b></summary>

4. **Wozu dienen die Optionen `-L -v -n` beim Aufruf von `iptables`?**
   <details><summary>Antwort</summary>
   * **`-L`**: Listet alle konfigurierten Regeln auf.  
   * **`-v`**: Verbose-Modus (zeigt Paket- und Bytezähler an).  
   * **`-n`**: Numerische Darstellung (verhindert langsame DNS-Namensauflösungen von IP-Adressen und Ports).
   </details>

5. **Welche iptables-Tabelle (`-t`) und Kette (`-A`) müssen Sie verwenden, um ein Port-Forwarding (Destination NAT) zu realisieren?**
   <details><summary>Antwort</summary>Sie müssen die Tabelle **`nat`** (`-t nat`) und die Kette **`PREROUTING`** (`-A PREROUTING`) verwenden, da das Zielpaket modifiziert werden muss, *bevor* die Routingentscheidung des Kernels stattfindet.</details>

6. **In welcher Datei werden persistente iptables-Regeln unter RHEL-basierten Systemen standardmäßig abgespeichert, wenn Sie den Dienst `service iptables save` aufrufen?**
   <details><summary>Antwort</summary>In der Datei **`/etc/sysconfig/iptables`**.</details>

</details>

---

## 🔗 Zurück zur Übersicht

* **Tag 16 (Netzwerk-Routing & Forwarding):** [⬅️ Tag 16](../Day_16/README.md)
* **Tag 18 (System-Hardware & Kernel-Module):** [➡️ Tag 18](../Day_18/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
