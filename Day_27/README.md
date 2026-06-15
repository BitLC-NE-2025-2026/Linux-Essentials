# 🐧 SSH Härtung & Limits — Tag 27

![Linux Essentials Day 27 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 100% Dokumentiert & LPIC-1 Fokussiert  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📑 Inhaltsverzeichnis
- [📖 Themenübersicht](#-themenübersicht)
- [🔑 Keywords](#-keywords)
- [🧠 LPIC-1 Relevanz & Wissenstest](#-lpic-1-relevanz--wissenstest)
- [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

---

## 📖 Themenübersicht

## 🔒 1. Härtung des SSH-Daemons
Die Datei `/etc/ssh/sshd_config` steuert das Verhalten des SSH-Servers. Zu den wichtigsten Härtungsmaßnahmen gehören:
* Deaktivieren des Root-Logins: `PermitRootLogin no`
* Deaktivieren von Passwort-Logins (nur Key-Auth erlauben): `PasswordAuthentication no`
* Ändern des Standard-Ports (z. B. auf 2222): `Port 2222`

## 👥 2. TCP-Wrapper
TCP-Wrapper ermöglichen eine einfache, IP-basierte Zugriffskontrolle auf Netzwerkdienste.
* `/etc/hosts.allow`: Definiert erlaubte Verbindungen (z. B. `sshd: 192.168.1.0/24`).
* `/etc/hosts.deny`: Definiert gesperrte Verbindungen (z. B. `sshd: ALL`).

## 📊 3. Ressourcen-Beschränkung (ulimit)
Ressourcenlimits verhindern DoS-Angriffe durch übermäßige Speicher- oder Prozessbelegung.
* `ulimit -a`: Zeigt alle aktuellen Limits an.
* `/etc/security/limits.conf`: Hier werden Limits persistent pro Benutzer oder Gruppe definiert (z. B. maximale Dateianzahl `nofile` oder maximale Prozesse `nproc`).

---

## 🔑 Keywords

| Keyword / Befehl | Erklärung |
| :--- | :--- |
| `sshd_config` | Zentrale Konfigurationsdatei des SSH-Servers zur Steuerung von Ports, Root-Logins und Sicherheit. |
| `ulimit` | Setzt und zeigt Ressourcenbeschränkungen (wie maximale Dateianzahl oder Speichergröße) für Prozesse. |
| `hosts.allow` | Zentrale Textdatei für TCP-Wrapper zur Definition explizit erlaubter IP-Verbindungen. |
| `limits.conf` | Konfigurationsdatei zur persistenten, benutzerbezogenen Zuweisung von Systemgrenzen. |
| `hosts.deny` | Zentrale Textdatei für TCP-Wrapper zur Sperrung unerwünschter IP-Verbindungen. |

---

## 🧠 LPIC-1 Relevanz & Wissenstest

<details>
<summary><b>Fragen zu SSH Härtung & Limits (Klicken zum Ausklappen)</b></summary>

1. **In welcher Konfigurationsdatei wird der SSH-Daemon gehärtet?**
   <details><summary>Antwort</summary>In der `/etc/ssh/sshd_config` auf dem Server.</details>

2. **Wie deaktiviert man den Root-Login über SSH?**
   <details><summary>Antwort</summary>Durch Setzen des Parameters `PermitRootLogin no` in der `/etc/ssh/sshd_config`.</details>

3. **Mit welchem Tool beschränkt man Systemressourcen (wie maximale Anzahl geöffneter Dateien)?**
   <details><summary>Antwort</summary>Mit `ulimit` zur Laufzeit, oder dauerhaft über `/etc/security/limits.conf`.</details>

4. **Welche Datei steuert die systemweiten SSH-Verbindungen als Client?**
   <details><summary>Antwort</summary>Die `/etc/ssh/ssh_config` (oder benutzerspezifisch in `~/.ssh/config`).</details>

5. **Wie konfiguriert man TCP-Wrapper zur IP-basierten Zugriffskontrolle?**
   <details><summary>Antwort</summary>Über die Konfigurationsdateien `/etc/hosts.allow` (Erlaubte Hosts) und `/etc/hosts.deny` (Gesperrte Hosts).</details>

</details>

---

## 🔗 Zurück zur Übersicht

* **Tag 26 (Docker, Kubernetes & Containerd):** [⬅️ Tag 26](../Day_26/README.md)
* **Tag 28 (Kryptographie & MTAs):** [➡️ Tag 28](../Day_28/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
