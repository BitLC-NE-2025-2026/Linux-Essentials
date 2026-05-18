#!/bin/bash
# ==============================================================================
# Script:      task_1b_ipv6.sh
# Beschreibung: Extrahiert valide IPv6-Adressen aus den Ausgaben von
#              ifconfig, ip addr, ip route und nmcli.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 1.b: IPv6-Adressen extrahieren ===${NC}"
echo -e "Dieses Skript filtert IPv6-Adressen aus Netzwerkbefehlen.\n"

# ------------------------------------------------------------------------------
# REGEX-ERKLÄRUNG:
# IPv6-Adressen bestehen aus 8 Blöcken hexadezimaler Ziffern (0-9, a-f, A-F), 
# getrennt durch Doppelpunkte. Doppelpunkte können komprimiert '::' vorkommen.
# Dieser Regex fängt alle gängigen Schreibweisen (Standard & komprimiert) ab.
# ------------------------------------------------------------------------------
IPV6_REGEX='(([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|::([0-9a-fA-F]{1,4}:){0,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:(:[0-9a-fA-F]{1,4}){1,6})'

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

for item in "ifconfig:ifconfig" "ip addr:ip_addr" "ip route:ip_route" "nmcli:nmcli"; do
    IFS=":" read -r cmd file <<< "$item"
    echo -e "\n--- Extraktion aus: ${CYAN}$cmd${NC} ---"
    
    output=$(get_input "$cmd" "$file")
    if [ $? -eq 0 ] && [ -n "$output" ]; then
        # IPv6 extrahieren und Duplikate ausschließen
        ips=$(echo "$output" | grep -E -o "$IPV6_REGEX" | sort -u)
        if [ -n "$ips" ]; then
            echo -e "${GREEN}$ips${NC}"
        else
            echo "Keine passenden IPv6-Adressen gefunden."
        fi
    fi
done
