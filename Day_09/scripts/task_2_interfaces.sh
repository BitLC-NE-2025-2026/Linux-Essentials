#!/bin/bash
# ==============================================================================
# Script:      task_2_interfaces.sh
# Beschreibung: Extrahiert die Netzwerkschnittstellennamen aus den Ausgaben von
#              ifconfig, nmcli, ip addr und ip route mittels Regex.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 2: Netzwerkschnittstellen extrahieren ===${NC}"
echo -e "Dieses Skript filtert Netzwerkschnittstellennamen aus verschiedenen Befehlsausgaben.\n"

get_input() {
    local cmd="$1"
    local file_base="$2"
    
    local search_paths=(
        "$file_base" "assets/$file_base" "../assets/$file_base" 
        "${file_base}Dat" "assets/${file_base}Dat" "../assets/${file_base}Dat" 
        "${file_base}.txt" "assets/${file_base}.txt" "../assets/${file_base}.txt"
        "ip_addr_dat" "assets/ip_addr_dat" "../assets/ip_addr_dat"
        "ip_route_dat" "assets/ip_route_dat" "../assets/ip_route_dat"
    )
    
    for path in "${search_paths[@]}"; do
        if [ -f "$path" ]; then
            echo -e "${YELLOW}[Datei-Backup gefunden: $path]${NC}" >&2
            cat "$path"
            return 0
        fi
    done
    
    if command -v "${cmd%% *}" >/dev/null 2>&1; then
        echo -e "${GREEN}[Führe Live-Befehl aus: $cmd]${NC}" >&2
        eval "$cmd" 2>/dev/null
    else
        echo -e "${RED}[Fehler: Befehl '$cmd' nicht verfügbar und kein Backup-File gefunden]${NC}" >&2
        return 1
    fi
}

# 1. ifconfig
echo -e "--- Extraktion aus: ${CYAN}ifconfig${NC} ---"
output_ifconfig=$(get_input "ifconfig" "ifconfig")
if [ $? -eq 0 ] && [ -n "$output_ifconfig" ]; then
    # Bei ifconfig stehen Interfaces am Zeilenanfang, gefolgt von einem Doppelpunkt
    # Regex: ^[a-zA-Z0-9_-]+:
    interfaces=$(echo "$output_ifconfig" | grep -E -o '^[a-zA-Z0-9_-]+:' | tr -d ':' | sort -u)
    if [ -n "$interfaces" ]; then
        echo -e "${GREEN}$interfaces${NC}"
    else
        echo "Keine Schnittstellen gefunden."
    fi
fi

# 2. ip addr
echo -e "\n--- Extraktion aus: ${CYAN}ip addr${NC} ---"
output_ipaddr=$(get_input "ip addr" "ip_addr")
if [ $? -eq 0 ] && [ -n "$output_ipaddr" ]; then
    # Bei ip addr sieht die Zeile so aus: "2: enp0s3: <BROADCAST..."
    # Regex: ^[0-9]+: [a-zA-Z0-9_-]+:
    interfaces=$(echo "$output_ipaddr" | grep -E -o '^[0-9]+: [a-zA-Z0-9_-]+:' | awk -F': ' '{print $2}' | sort -u)
    if [ -n "$interfaces" ]; then
        echo -e "${GREEN}$interfaces${NC}"
    else
        echo "Keine Schnittstellen gefunden."
    fi
fi

# 3. ip route
echo -e "\n--- Extraktion aus: ${CYAN}ip route${NC} ---"
output_iproute=$(get_input "ip route" "ip_route")
if [ $? -eq 0 ] && [ -n "$output_iproute" ]; then
    # Bei ip route folgt das Interface auf das Wort "dev"
    # Regex: \bdev\s+[a-zA-Z0-9_-]+
    interfaces=$(echo "$output_iproute" | grep -E -o '\bdev\s+[a-zA-Z0-9_-]+' | awk '{print $2}' | sort -u)
    if [ -n "$interfaces" ]; then
        echo -e "${GREEN}$interfaces${NC}"
    else
        echo "Keine Schnittstellen gefunden."
    fi
fi

# 4. nmcli
echo -e "\n--- Extraktion aus: ${CYAN}nmcli${NC} ---"
output_nmcli=$(get_input "nmcli" "nmcli")
if [ $? -eq 0 ] && [ -n "$output_nmcli" ]; then
    # Prüfen, ob das Backup oder die Ausgabe tabellarisch ist (DEVICE am Anfang)
    if echo "$output_nmcli" | grep -q '^DEVICE'; then
        # Erste Spalte ausgeben, Header ignorieren
        interfaces=$(echo "$output_nmcli" | awk 'NR>1 {print $1}' | sort -u)
    else
        # Standard nmcli Ausgabe zeigt oft: "eth0: connected to..."
        interfaces=$(echo "$output_nmcli" | grep -E -o '^[a-zA-Z0-9_-]+:' | tr -d ':' | sort -u)
    fi
    if [ -n "$interfaces" ]; then
        echo -e "${GREEN}$interfaces${NC}"
    else
        echo "Keine Schnittstellen gefunden."
    fi
fi
