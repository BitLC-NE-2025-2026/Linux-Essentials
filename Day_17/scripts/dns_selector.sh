#!/usr/bin/env bash
# ==============================================================================
# MNBTUI Module: dns_selector.sh
# Zweck: Dynamischer DNS-Benchmark mit 3-Packet-Ping & Whiptail TUI
# ==============================================================================

set -euo pipefail

# 10 beliebte öffentliche DNS Server und ihre Beschreibungen
declare -A DNS_SERVERS=(
    ["1.1.1.1"]="Cloudflare (Schnell & Privat)"
    ["8.8.8.8"]="Google DNS (Sehr verlässlich)"
    ["9.9.9.9"]="Quad9 (Sicher, schützt vor Malware)"
    ["208.67.222.222"]="OpenDNS (Anpassbar, Jugendschutz)"
    ["94.140.14.14"]="AdGuard DNS (Filtert Werbung)"
    ["1.0.0.1"]="Cloudflare Secondary"
    ["8.8.4.4"]="Google Secondary"
    ["149.112.112.112"]="Quad9 Secondary"
    ["185.228.168.9"]="CleanBrowsing Security"
    ["76.76.2.0"]="Control D Unfiltered"
)

TEMP_PING_LOG="/tmp/dns_benchmark.txt"
rm -f "$TEMP_PING_LOG"

# Latenzmessung in einem schönen Info-Fenster ankündigen
whiptail --title "DNS Latenz-Benchmark" --infobox "Latenzen der 10 bekanntesten DNS-Server werden gemessen...\nBitte warten (3 Pings pro DNS)..." 8 65

# Ping-Messung durchführen (schnell parallel im Hintergrund)
declare -A LATENCIES
for ip in "${!DNS_SERVERS[@]}"; do
    (
        # 3 Pings, Timeout 2s
        if ping_out=$(ping -c 3 -W 2 "$ip" 2>/dev/null); then
            # Extrahiere den avg RTT-Wert (z.B. rtt min/avg/max/mdev = 12.345/14.567...)
            avg_rtt=$(echo "$ping_out" | tail -n 1 | awk -F '/' '{print $5}' | awk -F '.' '{print $1}')
            if [[ -z "$avg_rtt" ]]; then
                # Fallback falls anderes Ping-Format
                avg_rtt=$(echo "$ping_out" | grep 'rtt' | cut -d'/' -f5 | cut -d'.' -f1)
            fi
            echo "$ip:$avg_rtt ms" >> "$TEMP_PING_LOG"
        else
            echo "$ip:Offline" >> "$TEMP_PING_LOG"
        fi
    ) &
done

# Warten auf alle Hintergrund-Messungen
wait

# Ergebnisse einlesen
declare -A MEASURED
if [[ -f "$TEMP_PING_LOG" ]]; then
    while IFS=: read -r ip val; do
        MEASURED["$ip"]="$val"
    done < "$TEMP_PING_LOG"
fi

# TUI-Menü-Optionen zusammenbauen
MENU_OPTIONS=()
# Sortierte Reihenfolge der Keys für Konsistenz
ORDERED_IPS=("1.1.1.1" "8.8.8.8" "9.9.9.9" "94.140.14.14" "208.67.222.222" "1.0.0.1" "8.8.4.4" "149.112.112.112" "185.228.168.9" "76.76.2.0")

for ip in "${ORDERED_IPS[@]}"; do
    latency="${MEASURED[$ip]:-Offline}"
    desc="${DNS_SERVERS[$ip]}"
    MENU_OPTIONS+=("$ip" "[$latency] $desc")
done

# Whiptail Auswahlliste anzeigen
CHOICE=$(whiptail --title "DNS-Server Auswählen (Benchmark-Ergebnisse)" \
                  --menu "Wählen Sie den gewünschten DNS-Server. Die Latenz (Ping) wurde live ermittelt:" 18 75 10 \
                  "${MENU_OPTIONS[@]}" 3>&1 1>&2 2>&3)

if [[ -n "$CHOICE" ]]; then
    # Gewählten DNS in temporäre Datei speichern zur Weitergabe an andere Skripte
    echo "$CHOICE" > /tmp/selected_dns.txt
    
    # Optional: In der config.yaml aktualisieren
    CONFIG_PATH="$(dirname "$0")/../config.yaml"
    if [[ -f "$CONFIG_PATH" ]]; then
        # Einfache Ersetzung in der config.yaml (Fallback-Wert)
        sed -i "s/dns_fallback: .*/dns_fallback: \"$CHOICE\"/" "$CONFIG_PATH"
    fi
    
    whiptail --title "DNS Aktualisiert" --msgbox "Der primäre DNS-Server wurde auf $CHOICE gesetzt!" 8 45
fi
