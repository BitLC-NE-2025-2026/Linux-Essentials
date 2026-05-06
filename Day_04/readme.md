# 🌐 Linux Essentials - Tag 04

![Linux Essentials Day 04 Header](./header.png)

Am vierten Tag tauchen wir in die Welt der Netzwerke ein. Wir lernen, wie Linux kommuniziert, wie man IP-Adressen verwaltet und wie man sich über **SSH** sicher mit entfernten Systemen verbindet.

---

## 📑 Inhaltsverzeichnis
- [Netzwerk-Grundlagen](#-netzwerk-grundlagen)
- [Wichtige Netzwerk-Befehle](#-wichtige-netzwerk-befehle)
- [Konfigurationsdateien](#-konfigurationsdateien)
- [SSH: Secure Shell](#-ssh-secure-shell)
- [Ports & Sockets](#-ports--sockets)
- [Zurück zum Hauptmenü](#-zurück-zum-hauptmenü)

---

## 🏗 Netzwerk-Grundlagen
Linux ist von Grund auf als Netzwerk-Betriebssystem konzipiert. Jedes System hat mindestens ein Netzwerkinterface (z.B. `eth0`, `ens33` oder das Loopback-Interface `lo`).

### IP-Adressierung
- **IPv4:** 32-Bit Adresse (z.B. `192.168.1.10`).
- **IPv6:** 128-Bit Adresse (z.B. `fe80::...`).
- **DHCP:** Automatische Zuweisung von IP-Adressen.
- **Statische IP:** Manuelle Konfiguration für Server.

---

## 🛠 Wichtige Netzwerk-Befehle
Zur Diagnose und Konfiguration nutzen wir moderne Werkzeuge der `iproute2`-Suite sowie klassische Tools.

| Befehl | Funktion |
| :--- | :--- |
| `ip addr` | Zeigt alle Netzwerkinterfaces und deren IP-Adressen an. |
| `ip route` | Zeigt die Routing-Tabelle (Standard-Gateway) an. |
| `ping <Host>` | Prüft die Erreichbarkeit eines anderen Systems. |
| `nmcli` | Kommandozeilen-Tool für den NetworkManager (Standard in Rocky/RHEL). |
| `nmtui` | Grafische (Text-basierte) Oberfläche zur Netzwerkkonfiguration. |
| `dig <Domain>` | DNS-Abfrage (Domain Information Groper). |

---

## 📄 Konfigurationsdateien
Die wichtigsten Einstellungen werden in einfachen Textdateien unter `/etc` gespeichert.

- `/etc/hostname`: Der Name des lokalen Systems.
- `/etc/hosts`: Lokale Namensauflösung (Mapping von IP zu Name).
- `/etc/resolv.conf`: Konfiguration der DNS-Nameserver.
- `/etc/NetworkManager/`: Hauptverzeichnis für NetworkManager-Einstellungen.

---

## 🔐 SSH: Secure Shell
SSH ist der Standard für den sicheren Fernzugriff auf Linux-Server. Es verschlüsselt die gesamte Kommunikation.

### Grundbefehle
```bash
ssh user@192.168.1.50       # Verbindung zu einem Remote-Host
ssh -p 2222 user@host       # Verbindung über einen alternativen Port
exit                        # Beendet die SSH-Sitzung
```

### Key-based Authentication (Best Practice)
Statt Passwörtern nutzen wir kryptografische Schlüsselpaare (Public/Private Key).
1. `ssh-keygen`: Erzeugt ein neues Schlüsselpaar.
2. `ssh-copy-id user@host`: Überträgt den öffentlichen Schlüssel auf den Server.

---

## 🔌 Ports & Sockets
Dienste hören auf bestimmten "Ports", um Verbindungen entgegenzunehmen.

| Port | Dienst | Beschreibung |
| :---: | :--- | :--- |
| **22** | **SSH** | Secure Shell Fernzugriff. |
| **80** | **HTTP** | Unverschlüsseltes Web (WWW). |
| **443** | **HTTPS** | Verschlüsseltes Web (SSL/TLS). |
| **53** | **DNS** | Namensauflösung. |

### Überprüfung aktiver Verbindungen
- `ss -tunlp`: Zeigt alle offenen Ports und die zugehörigen Prozesse an.
- `netstat -an`: Klassisches Tool für Netzwerkstatistiken (oft durch `ss` ersetzt).

---

## 🔗 Zurück zum Hauptmenü
[⬅ Zurück zur Übersicht](../README.md)

---

*Erstellt am 06. Mai 2026 für den Linux-Essentials Kurs.*
