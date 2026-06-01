# 🖥️ OmniTUI (OmniTUI) - Tag 17
## Dediziertes OmniTUI Handbuch & Moduldokumentation

![Linux Essentials Day 17 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 100% Optionales Premium-Showcase & Automatisierungstool  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📖 Einführung & Vision

**OmniTUI** (OmniTUI) ist ein hochgradig modulares, interaktives und professionelles Administrations- und Netzwerkeinrichtungs-System auf Basis von **Whiptail TUI**. Es wurde von Tobias Boyke als **100% optionales, over-the-top Zusatzprojekt** für Tag 17 entwickelt, um die manuelle Einrichtung von Netzwerken, Firewalls, Systemoptimierungen und NTP-Synchronisationen in einer erstklassigen, grafischen Terminal-Oberfläche zusammenzuführen.

Das System steuert die gesamte Netzwerkarchitektur (Zentrales Gateway, IP-Forwarding, `nftables` NAT-Masquerading, statisches Routing auf Clients) und erlaubt die Zuweisung von Geräten über ihre spezifischen **ENS-Namen** oder **physikalischen MAC-Adressen** direkt aus der YAML-Datei.

Zusätzlich integriert die Suite **fortgeschrittene Kernel-Tweaks** (Google BBR, TCP Window-Size-Scaling), lokale **DNS-Caching-Resolver**, einen **interaktiven Cronjob-Builder**, ein **Konnektivitäts-Diagnosewerkzeug**, einen **Backup & Restore Manager** sowie eine **NTP-Zeitsynchronisation** für absolut zeitsynchronisierte Protokolle und Logfiles im gesamten Subnetz.

---

## 🏗️ System-Architektur & Modulstruktur

Das System teilt sich in eine zentrale TUI-Hauptsteuerung, eine geteilte System-Bibliothek (`common.sh`) und dedizierte, modular gekapselte Skripte im Ordner `scripts/` auf:

```mermaid
graph TD
    A["OmniTUI.sh (Hauptmenü Loop)"] --> B["config.yaml (Single Source of Truth)"]
    
    %% Shared library & helpers
    A -.-> CO["scripts/common.sh (Shared Constants & Helpers)"]
    CO -.-> C
    CO -.-> D
    CO -.-> E
    CO -.-> F
    CO -.-> G
    CO -.-> H
    CO -.-> I
    CO -.-> J
    CO -.-> K
    CO -.-> L
    CO -.-> M
    CO -.-> N
    CO -.-> SC
    CO -.-> CE
    
    %% Action Modules
    A --> C["scripts/sys_check.sh (Dependency & Sudoers)"]
    A --> D["scripts/dns_selector.sh (Dual-IP Benchmark)"]
    A --> E["scripts/router_setup.sh (Routing & nftables NAT)"]
    A --> F["scripts/client_setup.sh (Dynamic IP & nmcli config)"]
    A --> G["scripts/services_mgmt.sh (SSH Hardening & systemd)"]
    A --> H["scripts/system_tweaks.sh (BBR, TCP Tuning, Cache, Editor)"]
    A --> I["scripts/tools_installer.sh (Fastfetch, Terminals, OMZ ZSH)"]
    A --> J["scripts/cron_maker.sh (Cronjob-TUI Assistant)"]
    A --> K["scripts/desktop_ricing.sh (GNOME, KDE, Hyprland Rices)"]
    A --> L["scripts/diagnostics.sh (Auto Self-Healing Doctor)"]
    A --> SC["scripts/subnet_scanner.sh (High-Speed Sweep)"]
    A --> M["scripts/ntp_setup.sh (timedatectl & chronyd Sync)"]
    A --> N["scripts/backup_manager.sh (Config tar.gz Backup/Restore)"]
    A --> CE["scripts/config_editor.sh (TUI YAML Parameter Modifier)"]
    
    %% Parsing layer
    CE --> UC["scripts/update_config.py (Write YAML)"]
    D --> UC
    
    C --> PY["scripts/parse_config.py (Read YAML)"]
    E --> PY
    F --> PY
    L --> PY
    CE --> PY
```

---

## ⚙️ Zentrale YAML-Konfiguration (`config.yaml`)

Die Datei `config.yaml` dient als Single Source of Truth für die gesamte Netzwerk-Topologie.

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

clients:
  - hostname: "srv-deb-01"
    name: "ens192"
    mac: "00:0C:29:9E:B3:3A"
    ip: "172.16.7.42/27"
    gateway: "172.16.7.33"
```

---

## 📦 Die Modul-Skripte im Detail

| Skriptname | Hauptfunktion | LPIC-1 Bezug | TUI-Typ |
| :--- | :--- | :--- | :--- |
| **`OmniTUI.sh`** | Hauptmenü, Navigations-Loop & Config-Viewer | - | Menü (FHD) |
| **`sys_check.sh`** | Sudoers-Härtung, OS-Erkennung & Dependency-Install | 109.4 | Info-Box |
| **`dns_selector.sh`** | Dual-Ping Benchmark & sofortige systemweite Aktivierung | 109.1, 109.4 | Menü (Live-Werte) |
| **`router_setup.sh`** | IP-Forwarding, nmcli Interface-Profile, nftables NAT | 109.1, 110.1 | Status-Box |
| **`client_setup.sh`** | Dynamic card-mapping (MAC/Name) & statische IPs | 109.1, 109.2 | Status-Box |
| **`services_mgmt.sh`**| OpenSSH Härtung & systemd Überwachung | 110.1 | Yes/No & Dashboard |
| **`system_tweaks.sh`**| Google BBR Tuning, TCP/IP Buffer Sizing, DNS-Caching | 109.1, 110.1 | Checklist (FHD) |
| **`tools_installer.sh`**| Installation CLI-Tools, legendäre fastfetch & OMZ ZSH | 109.4 | Checklist (FHD) |
| **`cron_maker.sh`** | Menügeführter, interaktiver Cronjob-Generator | 105.2 | Menü-Assistent |
| **`desktop_ricing.sh`**| r/unixporn Premium Eyecandy, Wallpaper & Visualizer | - | Checklist (FHD) |
| **`diagnostics.sh`** | Automatisierter Diagnosebericht & Konnektivitäts-Check / Doctor | 109.2 | TextBox (Scroll) |
| **`subnet_scanner.sh`**| Paralleler Hochgeschwindigkeits-Subnetz-Scanner (Ping Sweep) | 109.2 | TextBox (Scroll) |
| **`ntp_setup.sh`** | timedatectl & chronyd/systemd-timesyncd Zeitsynchronisation | 108.1 | Menü-Assistent |
| **`backup_manager.sh`**| Systemkonfigurations-Backup & Wiederherstellung | 105.2 | Menü-Assistent |
| **`config_editor.sh`**| Interaktiver YAML-Konfigurations-Parameter-Editor | - | Menü-Assistent |
| **`parse_config.py`** | YAML-Parser ohne Abhängigkeiten zur Systemkopplung (Read) | - | CLI-Hilfstool |
| **`update_config.py`**| YAML-Updater ohne Abhängigkeiten zur Systemkopplung (Write)| - | CLI-Hilfstool |

---

### 1. Systemprüfung (`sys_check.sh`)
* **Sudoers Hinzufügung:** Ist der aktuelle User nicht berechtigt, fragt das Skript nach dem Root-Passwort und fügt ihn der Administratorengruppe (`wheel` bei RHEL/Arch, `sudo` bei Debian) hinzu.
* **Uniformer Paket-Resolver:** Erkennt das OS und installiert fehlende TUI-Abhängigkeiten wie `newt` / `whiptail` und `ping`.

### 2. Dual-DNS Benchmark & Selektor (`dns_selector.sh`)
* **Hintergrund Live-Ping:** Pingt parallel **sowohl die Primary als auch die Secondary IP** von 10 weltbekannten DNS-Providern an (20 Server insgesamt) und berechnet den Mittelwert.
* **Live Latenzanzeige:** Visualisiert die genauen Reaktionszeiten übersichtlich im TUI-Wahlmenü.
* **Sofortige Aktivierung (Live-Override):** Überschreibt sofort das aktive NetworkManager-Schnittstellenprofil (`ipv4.dns`) und schreibt die Nameserver direkt in `/etc/resolv.conf`.

### 3. System Tuning & Performance (`system_tweaks.sh`)
* **Google BBR Congestion Control:** Modernes TCP/IP Congestion Control für extrem schnelle Übertragungsraten und minimalen Paketverlust.
* **TCP Buffer Tuning:** Skaliert Lese- und Schreib-Buffer des Kernels (`rmem`/`wmem`) auf High-Performance Level.
* **Default-Editor (EDITOR):** Menügeführte, persistente Konfiguration des Standardeditors (`micro`, `nano`, `vim`, `vi`) in `.bashrc` und `.zshrc`.
* **Lokaler DNS-Cache:** Richtet systemweiten Cache via `systemd-resolved` (oder `dnsmasq`) ein, wodurch Latenzen bei wiederholten Anfragen auf **0 ms** sinken!

### 4. Cronjob Maker TUI (`cron_maker.sh`)
* Nimmt dem Administrator das fehleranfällige manuelle Schreiben von Cron-Zeilen ab.
* Bietet vorgefertigte Intervalle (stündlich, täglich, wöchentlich) und Aufgaben (Sicherheitsupdates, Log-Cleanup, Backup) sowie Custom-Befehle an.
* Trägt die Zeilen nach Validierung sicher in die System-Crontab ein.

### 5. Tools & Shell-Branding (`tools_installer.sh`)
* **Legendäre Fastfetch Config:** Richtet ein schickes, farbkodiertes Terminal-Dashboard mit Hardware-Status und lokalen IP-Adressen unter `~/.config/fastfetch/config.jsonc` ein.
* **Moderne Terminals:** Selektive Co-Installation von `Ghostty` (Zig/GPU-beschleunigt), `Alacritty` (Rust) und `Kitty` samt vollautomatischer Catppuccin Mocha Themes.
* **ZSH & Oh My Zsh:** Richtet die Standard-Shell ein und lädt das `agnoster`-Theme sowie Premium-Plugins (`autosuggestions`, `syntax-highlighting`, `completions`, etc.).
* **Nützliche Aliases:**
  * `ipbrief` -> `ip -br -4 a` (Interface-IPs).
  * `fwlist` -> `sudo nft list ruleset` (Firewall).
  * `ports` -> `sudo ss -tulpen` (Aktive Ports & Sockets).

### 6. Desktop Ricing & Premium Eyecandy (`desktop_ricing.sh`)
* **r/unixporn Edition:** Richtet detailverliebte Rices für **KDE Plasma** (Sweet Cyberpunk, Candy Icons), **GNOME** (Orchis GTK Theme, Blur my Shell, custom Dock) und **Hyprland** (Catppuccin Mocha, custom Waybar-Glow, Rofi, Dunst) ein.
* **Wallpaper Downloader:** Zieht hochauflösende, ästhetische Hintergrundbilder und setzt diese live.
* **Showcase-Tools:** Installiert `cava` (Terminal-Audiospektrum) und `cmatrix` (Matrix Code Rain) für beeindruckende Präsentationen.

### 7. System- & Netzwerk-Diagnose (`diagnostics.sh`)
* Führt automatisiert lokale Schnittstellenprüfungen und Routing-Analysen durch.
* Prüft DNS- und HTTPS-Verbindungen ins Internet.
* Liest die `config.yaml` und führt einen automatisierten Latenz-Sweep zwischen allen Topologie-Hosts durch.
* **Self-Healing Doctor:** Erkennt Nameserver-Fehler und unterbrochene Gateways und repariert diese interaktiv durch automatische Schnittstellen-Resets oder Benchmark-Umlenkungen.

### 8. NTP Zeitsynchronisation & Server (`ntp_setup.sh`)
* **LPIC-Fokus:** Konfiguriert den Zeitsynchronisationsdienst auf Basis des verfügbaren Clients (`chronyd` auf RHEL/Rocky, `systemd-timesyncd` auf Debian/Arch).
* **Zeitserver-Auswahl:** Bietet eine Auswahlliste an regionalen NTP-Servern (Deutschland-Pool, Europa-Pool, Cloudflare-NTS, Google).
* Richtet die persistente Konfigurationsdatei ein, erzwingt die Synchronisation und gibt Drift- und Zeitstatus aus.

### 9. Backup & Restore Manager (`backup_manager.sh`)
* Archiviert und komprimiert alle durch OmniTUI modifizierten Konfigurationsdateien in einem datierten `.tar.gz`-Archiv unter `/var/backups/omnitui/`.
* Das **Wiederherstellungsmenü** listet alle vorhandenen Backups samt Dateigröße auf und erlaubt das Zurückspielen alter Zustände mit anschließendem automatischen Dienst-Neustart.

### 10. Subnetz-Scanner / Host-Discovery (`subnet_scanner.sh`)
* **Parallele Ping-Sweeps:** Pingt alle IPs im ausgewählten `/27` Subnetz (Netz A oder Netz B) parallel im Hintergrund an.
* **DNS Reverse Resolution:** Versucht automatisch, Online-Hosts über lokale DNS-Auflösungen (`getent hosts`) einem Rechnernamen zuzuordnen.
* **Scan-Berichte:** Generiert einen scrollbaren Whiptail-Bericht über alle aktiven (ONLINE) und freien (offline) IP-Adressen zur einfachen Netzübersicht.

### 11. Interaktiver Konfigurations-Editor (`config_editor.sh`)
* **Live-Parameteranpassung:** Ermöglicht das Bearbeiten wichtiger Parameter aus `config.yaml` direkt aus der Benutzeroberfläche heraus.
* **Zentraler Schreibzugriff:** Nutzt die Python-Bibliothek `update_config.py`, um Werte sauber und ohne Drittanbieter-Abhängigkeiten in der YAML-Struktur zu aktualisieren.

### 12. Gemeinsame System-Bibliothek (`common.sh`)
* **DRY-Konformität:** Bündelt alle globalen Variablen (FHD-Größen, Parser-Pfade) und Hilfsfunktionen (Root-Rechteprüfung, Farb-Logging) an einem einzigen, zentralen Ort.
* **Wartungsfreundlichkeit:** Änderungen an Anzeigegrößen oder Pfaden müssen nur noch in dieser einen Datei vorgenommen werden und vererben sich automatisch auf alle Sub-Module.

---

## 🚀 Ausführung & Live-Betrieb

Stellen Sie sicher, dass Sie sich im Verzeichnis `Day_17` befinden. Sie können das Hauptmenü direkt starten:

```bash
# Hauptsteuerung starten (Rechte werden automatisch vergeben!)
bash OmniTUI.sh
```

> [!NOTE]
> **Automatische Rechtevergabe:** Beim ersten Start vergibt `OmniTUI.sh` automatisch alle nötigen Ausführungsrechte (`chmod +x`) für sämtliche Sub-Skripte und Parser im Hintergrund. Sie müssen keine manuellen Berechtigungsanpassungen vornehmen.

> [!TIP]
> **FHD-Modus:** Die TUI wurde gezielt für Auflösungen ab Full HD (1920x1080) optimiert (Fenstergröße 24x95). Sie bietet dadurch ein erstklassiges, übersichtliches Layout auf modernen Monitoren.

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
