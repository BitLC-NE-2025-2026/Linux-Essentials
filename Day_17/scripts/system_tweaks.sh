#!/usr/bin/env bash
# ==============================================================================
# MNBTUI Module: system_tweaks.sh
# Zweck: System Tuning, TCP/IP Optimierung, BBR, DNS-Cache & Limits (Checklist)
# ==============================================================================

set -euo pipefail

# Lade Konfigurationspfad
CONFIG_PATH="$(dirname "$0")/../config.yaml"
PARSER="$(dirname "$0")/parse_config.py"

# FHD-optimierte Whiptail-Größen
W_HEIGHT=24
W_WIDTH=95
W_LIST=8

# Menü zur Auswahl der Tweaks
TWEAKS=$(whiptail --title "System Tuning & Optimierungen" \
                  --checklist "Wählen Sie die gewünschten Kernel- und Netzwerk-Tweaks:" $W_HEIGHT $W_WIDTH $W_LIST \
                  "BBR" "Google BBR Congestion Control (TCP Staukontrolle)" ON \
                  "TCP" "TCP/IP Buffer Tuning (Performance für hohe Bandbreiten)" ON \
                  "FASTOPEN" "TCP Fast Open (Reduziert Verbindungs-Overhead)" ON \
                  "DNSCACHE" "Lokalen DNS-Caching Resolver (systemd-resolved/dnsmasq)" ON \
                  "LIMITS" "Systemlimits erhöhen (maximale offene Dateien in limits.conf)" ON 3>&1 1>&2 2>&3)

if [[ -z "$TWEAKS" ]]; then
    exit 0
fi

# Erstelle temporäre sysctl Datei
SYSCTL_CONF="/etc/sysctl.d/99-network-tweaks.conf"
sudo mkdir -p /etc/sysctl.d
sudo rm -f "$SYSCTL_CONF"

whiptail --title "Tuning läuft" --infobox "Die ausgewählten Optimierungen werden angewendet..." 8 50

# 1. BBR
if [[ "$TWEAKS" =~ "BBR" ]]; then
    {
        echo "# Google BBR Congestion Control"
        echo "net.core.default_qdisc = fq"
        echo "net.ipv4.tcp_congestion_control = bbr"
    } | sudo tee -a "$SYSCTL_CONF" >/dev/null
fi

# 2. TCP Buffers
if [[ "$TWEAKS" =~ "TCP" ]]; then
    {
        echo ""
        echo "# High-Performance TCP/IP Tuning"
        echo "net.ipv4.tcp_rmem = 4096 87380 16777216"
        echo "net.ipv4.tcp_wmem = 4096 65536 16777216"
        echo "net.core.rmem_max = 16777216"
        echo "net.core.wmem_max = 16777216"
        echo "net.ipv4.tcp_mtu_probing = 1"
    } | sudo tee -a "$SYSCTL_CONF" >/dev/null
fi

# 3. Fast Open
if [[ "$TWEAKS" =~ "FASTOPEN" ]]; then
    {
        echo ""
        echo "# TCP Fast Open"
        echo "net.ipv4.tcp_fastopen = 3"
    } | sudo tee -a "$SYSCTL_CONF" >/dev/null
fi

# Sysctl anwenden
sudo sysctl --system >/dev/null

# 4. DNS Cache
if [[ "$TWEAKS" =~ "DNSCACHE" ]]; then
    # Für systemd-resolved (standardmäßig auf Debian/Ubuntu/Arch)
    if systemctl list-unit-files | grep -q "systemd-resolved.service"; then
        sudo systemctl enable systemd-resolved --now >/dev/null 2>&1 || true
        sudo mkdir -p /etc/systemd/resolved.conf.d
        echo -e "[Resolve]\nCache=yes\nDNSStubListener=yes" | sudo tee /etc/systemd/resolved.conf.d/cache.conf >/dev/null
        sudo systemctl restart systemd-resolved >/dev/null 2>&1 || true
    elif command -v apt-get >/dev/null 2>&1 || command -v dnf >/dev/null 2>&1; then
        # DNSmasq als fallback falls kein systemd-resolved
        if command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y dnsmasq >/dev/null 2>&1 || true
        elif command -v apt-get >/dev/null 2>&1; then
            sudo apt-get install -y dnsmasq >/dev/null 2>&1 || true
        fi
        
        if command -v dnsmasq >/dev/null 2>&1; then
            echo -e "listen-address=127.0.0.1\ncache-size=1000" | sudo tee /etc/dnsmasq.d/cache.conf >/dev/null 2>&1 || echo -e "listen-address=127.0.0.1\ncache-size=1000" | sudo tee -a /etc/dnsmasq.conf >/dev/null
            sudo systemctl enable dnsmasq --now >/dev/null 2>&1 || true
        fi
    fi
fi

# 5. Limits.conf
if [[ "$TWEAKS" =~ "LIMITS" ]]; then
    LIMITS_CONF="/etc/security/limits.d/99-performance.conf"
    sudo mkdir -p /etc/security/limits.d
    {
        echo "# Performance Limits"
        echo "* soft nofile 65535"
        echo "* hard nofile 65535"
        echo "* soft nproc 65535"
        echo "* hard nproc 65535"
    } | sudo tee "$LIMITS_CONF" >/dev/null
fi

whiptail --title "Tweaks erfolgreich" --msgbox "Die ausgewählten Optimierungen wurden erfolgreich angewendet!\n\nDetails wurden in /etc/sysctl.d/99-network-tweaks.conf geschrieben." $W_HEIGHT $W_WIDTH
