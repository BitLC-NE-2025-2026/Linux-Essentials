# 🖥️ MiniNetzBuilderTUI (MNBTUI) - Day 17

![Linux Essentials Day 17 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 Vollständig Einsatzbereit & Getestet  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📖 Einführung & Vision

**MNBTUI** (MiniNetzBuilderTUI) ist ein hochgradig modulares, interaktives und professionelles Administrations- und Netzwerkeinrichtungs-System auf Basis von **Whiptail TUI**. Es transformiert die monolithische Automatisierung von Tag 16 in eine zukunftsweisende, benutzerfreundliche und fehlerresistente Suite.

Das System steuert die gesamte Netzwerkarchitektur (Zentrales Gateway, IP-Forwarding, `nftables` NAT-Masquerading, statisches Routing auf Clients) und integriert **fortgeschrittene Kernel-Tweaks** (wie Google BBR und TCP Window-Size-Scaling), lokale **DNS-Caching-Resolver** und einen **interaktiven Cronjob-Builder**.

MNBTUI folgt streng den Paradigmen **SFC** (Single File Component / Modulare Kapselung), **DRY** (Don't Repeat Yourself), **Fail-Fast** (Sofortiger Abbruch bei Fehlern) und **Separation of Concerns** (Trennung der Zuständigkeiten).

---

## 📑 Inhaltsverzeichnis
- [🏗️ System-Architektur & Modulstruktur](#️-system-architektur--modulstruktur)
- [⚙️ Zentrale YAML-Konfiguration (config.yaml)](#️-zentrale-yaml-konfiguration-configyaml)
- [📦 Die Modul-Skripte im Detail](#-die-modul-skripte-im-detail)
  - [1. Systemprüfung (sys_check.sh)](#1-systemprüfung-sys_checksh)
  - [2. Dual-DNS Benchmark & Selektor (dns_selector.sh)](#2-dual-dns-benchmark--selektor-dns_selectorsh)
  - [3. System Tuning & Performance (system_tweaks.sh)](#3-system-tuning--performance-system_tweakssh)
  - [4. Cronjob Maker TUI (cron_maker.sh)](#4-cronjob-maker-tui-cron_makersh)
  - [5. Tools & Shell-Branding (tools_installer.sh)](#5-tools--shell-branding-tools_installersh)
- [🚀 Ausführung & Live-Betrieb](#-ausführung--live-betrieb)
- [🧠 LPIC-1 Relevanz & Wissenstest](#-lpic-1-relevanz--wissenstest)
- [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

---

## 🏗️ System-Architektur & Modulstruktur

Das System teilt sich in eine zentrale TUI-Hauptsteuerung und dedizierte, modular gekapselte Skripte im Ordner `scripts/` auf:

```mermaid
graph TD
    A["MNBTUI.sh (Hauptmenü Loop)"] --> B["config.yaml (Zentrale Topologie)"]
    A --> C["scripts/sys_check.sh (Dependency- & Sudo-Resolver)"]
    A --> D["scripts/dns_selector.sh (Dual-IP Live Ping & Benchmark)"]
    A --> E["scripts/router_setup.sh (Gateway, Routing & nftables NAT)"]
    A --> F["scripts/client_setup.sh (Dynamic Interface nmcli-Config)"]
    A --> G["scripts/services_mgmt.sh (systemd Control & SSH Hardening)"]
    A --> H["scripts/system_tweaks.sh (BBR, TCP Buffer, DNS-Cache)"]
    A --> I["scripts/tools_installer.sh (btop, micro, Custom ZSH, Aliases)"]
    A --> J["scripts/cron_maker.sh (Cronjob-TUI Generator)"]
    A --> K["scripts/parse_config.py (Lightweight Python YAML Parser)"]
```

> [!NOTE]
> Jedes Skript im `scripts/`-Ordner ist vollständig eigenständig lauffähig, nutzt jedoch denselben Parser, um die Konfigurationen aus der `config.yaml` zu laden.

---

## ⚙️ Zentrale YAML-Konfiguration (`config.yaml`)

Die Datei [config.yaml](file:///c:/Users/Tobia/Desktop/cSharpRepo/Linux-Essentials/Day_17/config.yaml) dient als Single Source of Truth für die gesamte Netzwerk-Topologie.

```yaml
global:
  dns_fallback: "1.1.1.1 1.0.0.1"
  domain: "linux.essentials"

router:
  hostname: "srv-rocky"
  interfaces:
    wan:
      name: "ens160"
      mac: "00:0C:29:9E:B3:12"
    lan_a:
      name: "ens161"
      mac: "00:0C:29:9E:B3:26"
      ip: "172.16.7.33/27"
    lan_b:
      name: "ens256"
      mac: "00:0C:29:9E:B3:1C"
      ip: "172.16.7.97/27"
```

---

## 📦 Die Modul-Skripte im Detail

| Skriptname | Hauptfunktion | LPIC-1 Bezug | TUI-Typ |
| :--- | :--- | :--- | :--- |
| **`MNBTUI.sh`** | Hauptmenü, Navigations-Loop & Config-Viewer | - | Menü (FHD) |
| **`sys_check.sh`** | Sudoers-Härtung, OS-Erkennung & Dependency-Install | 109.4 | Info-Box |
| **`dns_selector.sh`** | Dual-Ping Benchmark & sofortige systemweite Aktivierung | 109.1, 109.4 | Menü (Live-Werte) |
| **`router_setup.sh`** | IP-Forwarding, nmcli Interface-Profile, nftables NAT | 109.1, 110.1 | Status-Box |
| **`client_setup.sh`** | Automatische Schnittstellenermittlung & statische IPs | 109.1, 109.2 | Status-Box |
| **`services_mgmt.sh`**| OpenSSH Härtung & systemd Überwachung | 110.1 | Yes/No & Dashboard |
| **`system_tweaks.sh`**| Google BBR Tuning, TCP/IP Buffer Sizing, DNS-Caching | 109.1, 110.1 | Checklist (FHD) |
| **`tools_installer.sh`**| Installation CLI-Tools, legendäre fastfetch & OMZ ZSH | 109.4 | Checklist (FHD) |
| **`cron_maker.sh`** | Menügeführter, interaktiver Cronjob-Generator | 105.2 | Menü-Assistent |
| **`parse_config.py`** | YAML-Parser ohne Abhängigkeiten zur Systemkopplung | - | CLI-Hilfstool |

---

### 1. Systemprüfung (`sys_check.sh`)
* **Sudoers Hinzufügung:** Ist der aktuelle User nicht berechtigt, fragt das Skript nach dem Root-Passwort und fügt ihn der Administratorengruppe (`wheel` bei RHEL/Arch, `sudo` bei Debian) hinzu.
* **Uniformer Paket-Resolver:** Erkennt das OS und installiert fehlende TUI-Abhängigkeiten wie `newt` / `whiptail` und `ping`.

### 2. Dual-DNS Benchmark & Selektor (`dns_selector.sh`)
* **Hintergrund Live-Ping:** Pingt parallel **sowohl die Primary als auch die Secondary IP** von 10 weltbekannten DNS-Providern an (20 Server insgesamt) und berechnet den Mittelwert.
* **Live Latenzanzeige:** Visualisiert die genauen Reaktionszeiten übersichtlich im TUI-Wahlmenü.
* **Sofortige Aktivierung (Live-Override):**
  * Überschreibt sofort das aktive NetworkManager-Schnittstellenprofil (`ipv4.dns`).
  * Sichert `/etc/resolv.conf` und schreibt die neuen Nameserver direkt als System-Override fest.

```bash
# Direkter resolv.conf Override für sofortige systemweite Aktivierung
{
    echo "# Generated by MNBTUI DNS Selector (FHD)"
    echo "nameserver $CHOICE"
    echo "nameserver $SELECTED_SECONDARY"
} | sudo tee /etc/resolv.conf >/dev/null
```

### 3. System Tuning & Performance (`system_tweaks.sh`)
* **Google BBR Congestion Control:** Modernes TCP/IP Congestion Control für extrem schnelle Übertragungsraten und minimalen Paketverlust.
* **TCP Buffer Tuning:** Skaliert Lese- und Schreib-Buffer des Kernels (`rmem`/`wmem`) auf High-Performance Level.
* **Lokaler DNS-Cache:** Richtet systemweiten Cache via `systemd-resolved` (oder `dnsmasq`) ein. DNS-Antworten werden lokal gespeichert, wodurch Latenzen bei wiederholten Anfragen auf **0 ms** sinken!

### 4. Cronjob Maker TUI (`cron_maker.sh`)
* Nimmt dem Administrator das fehleranfällige manuelle Schreiben von Cron-Zeilen ab.
* Bietet vorgefertigte Intervalle (stündlich, täglich, wöchentlich) und Aufgaben (Sicherheitsupdates, Log-Cleanup, Backup) sowie Custom-Befehle an.
* Trägt die Zeilen nach Validierung sicher in die System-Crontab ein.

```bash
# Ermöglicht automatische Backups oder Wartungen ohne Crontab-Frust
(sudo crontab -l 2>/dev/null || true; echo "$FULL_CRON_LINE") | sudo crontab -
```

### 5. Tools & Shell-Branding (`tools_installer.sh`)
* **Legendäre Fastfetch Config:** Richtet ein schickes, farbkodiertes Terminal-Dashboard mit Unicode-Icons, Hardware-Status und lokalen IP-Adressen unter `~/.config/fastfetch/config.jsonc` ein.
* **ZSH & Oh My Zsh:** Richtet die Standard-Shell ein und lädt das `agnoster`-Theme sowie Premium-Plugins:
  * `zsh-autosuggestions` & `zsh-syntax-highlighting`
  * `zsh-completions` & `colored-man-pages`
  * `sudo` (Doppel-ESC fügt ein führendes `sudo` ein).
* **Nützliche Aliases:**
  * `ipbrief` -> `ip -br -4 a` (Interface-IPs).
  * `fwlist` -> `sudo nft list ruleset` (Firewall).
  * `ports` -> `sudo ss -tulpen` (Aktive Ports & Sockets).

---

## 🚀 Ausführung & Live-Betrieb

Stellen Sie vor der Ausführung sicher, dass Sie sich im Verzeichnis `Day_17` befinden:

```bash
# Skript ausführbar machen
chmod +x MNBTUI.sh scripts/*.sh scripts/*.py

# Hauptsteuerung im Full-HD Modus starten
bash MNBTUI.sh
```

> [!TIP]
> **FHD-Modus:** Die TUI wurde gezielt für Auflösungen ab Full HD (1920x1080) optimiert (Fenstergröße 24x95). Sie bietet dadurch ein erstklassiges, übersichtliches Layout auf modernen Monitoren.

---

## 🧠 LPIC-1 Relevanz & Wissenstest

Dieses Modul deckt wesentliche Aspekte der LPIC-Prüfungsinhalte ab und festigt Ihr Wissen zur Systemadministration:

<details>
<summary><b>Fragen zu DNS-Konfiguration & Live-Override (Klicken zum Ausklappen)</b></summary>

1. **Welches System-Tool steuert unter Linux die dynamische DNS-Konfiguration und wie überschreibt man diese dauerhaft für ein Interface?**
   <details><summary>Antwort</summary>Unter modernen Distributionen übernimmt der **NetworkManager** die Konfiguration via **`nmcli`**. Ein dauerhafter Override erfolgt mit:
   `sudo nmcli connection modify <Interface> ipv4.dns "1.1.1.1 1.0.0.1" ipv4.ignore-auto-dns yes` gefolgt von `sudo nmcli connection up <Interface>`.</details>

2. **Warum reicht ein Eintrag in `/etc/resolv.conf` bei aktivem systemd-resolved oft nicht dauerhaft aus?**
   <details><summary>Antwort</summary>Weil `/etc/resolv.conf` in modernen Systemen oft ein symbolischer Link auf `/run/systemd/resolve/stub-resolv.conf` oder `/run/systemd/resolve/resolv.conf` ist und vom `systemd-resolved`-Dienst oder dem `NetworkManager` bei jedem DHCP-Event oder Systemstart automatisch überschrieben wird. Ein dauerhafter Override muss daher in der resolved-Konfiguration (`/etc/systemd/resolved.conf`) oder im NetworkManager vorgenommen werden.</details>

</details>

<details>
<summary><b>Fragen zu Kernel Tuning & Cron-Schnittstellen (Klicken zum Ausklappen)</b></summary>

3. **Was bewirkt der Sysctl-Befehl `sysctl -w net.ipv4.tcp_congestion_control=bbr`?**
   <details><summary>Antwort</summary>Dieser Befehl ändert den TCP-Staukontroll-Algorithmus (Congestion Control) des Kernels im laufenden Betrieb auf **BBR** (Bottleneck Bandwidth and Round-trip propagation time). BBR ermittelt die optimale Bandbreite und RTT der Leitung und verhindert Datenstau, was die Verbindungsgeschwindigkeit im Subnetz drastisch erhöht.</details>

4. **Wie lautet die Cron-Syntax, um ein Skript jeden Montag um exakt 04:30 Uhr morgens auszuführen?**
   <details><summary>Antwort</summary>Die Syntax lautet:
   `30 4 * * 1 /pfad/zum/skript.sh`  
   *(30 = Minute, 4 = Stunde, * = Tag des Monats, * = Monat, 1 = Wochentag [Montag])*</details>

</details>

---

## 🔗 Zurück zur Übersicht

* **Tag 16 (Routing & NAT):** [⬅️ Netzwerk-Routing & Forwarding](../Day_16/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
