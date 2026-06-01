#!/usr/bin/env bash
# ==============================================================================
# MNBTUI Module: dns_selector.sh
# Zweck: Latenz-Benchmark für Primary & Secondary DNS, automatisches Doppel-Setup
# ==============================================================================

set -euo pipefail

# Definition der Top 10 DNS Provider mit Primary und Secondary IPs
PROVIDERS=(
    "Cloudflare;1.1.1.1;1.0.0.1;Schnell & Privat"
    "Google;8.8.8.8;8.8.4.4;Sehr verlässlich"
    "Quad9;9.9.9.9;149.112.112.112;Sicher, blockiert Malware"
    "AdGuard;94.140.14.14;94.140.15.15;Filtert Werbung & Tracker"
    "OpenDNS;208.67.222.222;208.67.220.220;Anpassbar, Jugendschutz"
    "CleanBrowsing;185.228.168.9;185.228.169.9;Familienfreundlicher Schutz"
    "ControlD;76.76.2.0;76.76.10.0;Ungefiltert & Performant"
    "Comodo;8.26.56.26;8.20.247.20;Secure DNS-Shield"
    "Verisign;64.6.64.6;64.6.65.6;Stabilität & Datenschutz"
    "Uncensored;91.239.100.100;89.233.43.71;Zensurfreies DNS (Dänemark)"
)

# FHD-optimierte Whiptail-Größen
W_HEIGHT=24
W_WIDTH=95
W_LIST=10

TEMP_PING_LOG="/tmp/dns_benchmark.txt"
rm -f "$TEMP_PING_LOG"

# Latenzmessung in einem schönen Info-Fenster ankündigen
whiptail --title "DNS Dual-Latenz-Benchmark" --infobox "Latenzen von Primary & Secondary DNS der 10 bekanntesten Anbieter werden gemessen...\nBitte warten (20 Server werden parallel gepingt)..." 8 85

# Ping-Messung für Primary & Secondary aller Provider parallel im Hintergrund
for entry in "${PROVIDERS[@]}"; do
    IFS=';' read -r name primary secondary desc <<< "$entry"
    
    # Primary ping
    (
        if ping_out=$(ping -c 3 -W 2 "$primary" 2>/dev/null); then
            avg_rtt=$(echo "$ping_out" | tail -n 1 | awk -F '/' '{print $5}' | awk -F '.' '{print $1}')
            if [[ -z "$avg_rtt" ]]; then
                avg_rtt=$(echo "$ping_out" | grep 'rtt' | cut -d'/' -f5 | cut -d'.' -f1)
            fi
            echo "$primary:$avg_rtt ms" >> "$TEMP_PING_LOG"
        else
            echo "$primary:Offline" >> "$TEMP_PING_LOG"
        fi
    ) &
    
    # Secondary ping
    (
        if ping_out=$(ping -c 3 -W 2 "$secondary" 2>/dev/null); then
            avg_rtt=$(echo "$ping_out" | tail -n 1 | awk -F '/' '{print $5}' | awk -F '.' '{print $1}')
            if [[ -z "$avg_rtt" ]]; then
                avg_rtt=$(echo "$ping_out" | grep 'rtt' | cut -d'/' -f5 | cut -d'.' -f1)
            fi
            echo "$secondary:$avg_rtt ms" >> "$TEMP_PING_LOG"
        else
            echo "$secondary:Offline" >> "$TEMP_PING_LOG"
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

# TUI-Menü-Optionen zusammenbauen (nur Primary wählbar, aber beide Latenzen sichtbar!)
MENU_OPTIONS=()
for entry in "${PROVIDERS[@]}"; do
    IFS=';' read -r name primary secondary desc <<< "$entry"
    
    p_latency="${MEASURED[$primary]:-Offline}"
    s_latency="${MEASURED[$secondary]:-Offline}"
    
    # Erzeuge ein schickes, hoch-informatives Label
    label="[Pri: $p_latency | Sec: $s_latency] $name ($desc)"
    MENU_OPTIONS+=("$primary" "$label")
done

# Whiptail Auswahlliste anzeigen
CHOICE=$(whiptail --title "DNS-Provider Auswählen (Benchmark-Ergebnisse)" \
                  --menu "Wählen Sie einen DNS-Anbieter. Es werden automatisch Primary & Secondary eingerichtet:" $W_HEIGHT $W_WIDTH $W_LIST \
                  "${MENU_OPTIONS[@]}" 3>&1 1>&2 2>&3)

if [[ -n "$CHOICE" ]]; then
    # Ermittle die passende Secondary IP für den ausgewählten Primary
    SELECTED_SECONDARY=""
    SELECTED_NAME=""
    for entry in "${PROVIDERS[@]}"; do
        IFS=';' read -r name primary secondary desc <<< "$entry"
        if [[ "$primary" == "$CHOICE" ]]; then
            SELECTED_SECONDARY="$secondary"
            SELECTED_NAME="$name"
            break
        fi
    done
    
    # Speichere beide IPs (durch Leerzeichen getrennt) für nmcli Kompatibilität
    echo "$CHOICE $SELECTED_SECONDARY" > /tmp/selected_dns.txt
    
    # In config.yaml eintragen
    CONFIG_PATH="$(dirname "$0")/../config.yaml"
    if [[ -f "$CONFIG_PATH" ]]; then
        sed -i "s/dns_fallback: .*/dns_fallback: \"$CHOICE $SELECTED_SECONDARY\"/" "$CONFIG_PATH"
    fi
    
    whiptail --title "DNS Aktualisiert" --msgbox "Der DNS-Provider $SELECTED_NAME wurde erfolgreich als Standard gesetzt!\n\n- Primary DNS: $CHOICE\n- Secondary DNS: $SELECTED_SECONDARY\n\nBeide Server werden bei allen folgenden Netzwerkeinrichtungen automatisch eingetragen." 14 65
fi
