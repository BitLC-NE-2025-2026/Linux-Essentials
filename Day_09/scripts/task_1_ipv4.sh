#!/bin/bash
# ==============================================================================
# Script:      task_1_ipv4.sh
# Beschreibung: Extrahiert mathematisch valide IPv4-Adressen aus den Ausgaben von
#              ifconfig, ip addr, ip route und nmcli.
#              Es filtert ungültige IPs wie 999.999.999.999 aus.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 1: IPv4-Adressen extrahieren ===${NC}"
echo -e "Dieses Skript filtert IPv4-Adressen aus Netzwerkbefehlen."
echo -e "Es verwendet eine mathematisch präzise Regex, um ungültige Oktette zu verhindern.\n"

# ------------------------------------------------------------------------------
# REGEX-ANALYSE & LEHRER-BUG-ERKLÄRUNG:
# Ein Oktett einer IPv4-Adresse darf Werte von 0 bis 255 annehmen.
# Unser exakter Regex für ein Oktett (0-255):
#   25[0-5]        -> deckt 250 - 255 ab
#   2[0-4][0-9]    -> deckt 200 - 249 ab
#   1[0-9][0-9]    -> deckt 100 - 199 ab
#   [1-9]?[0-9]    -> deckt 0 - 99 ab
#
# Der vom Lehrer angegebene Regex: \b((([0-2]\d[0-5])|(\d{2})|(\d))\.){3}...
# hat zwei gravierende Fehler:
# 1. Er erlaubt ungültige Werte wie 295, da [0-2]\d[0-5] bei einer 9 in der Mitte
#    passt (2 ist in [0-2], 9 ist in \d, 5 ist in [0-5] -> 295).
# 2. Er schließt gültige IPs wie '192.168.1.1' aus! Warum?
#    Für das Oktett '168' gilt:
#    - [0-2]\d[0-5] passt nicht, da '8' am Ende nicht in [0-5] ist.
#    - \d{2} passt nicht, da '168' dreistellig ist.
#    - \d passt nicht, da '168' dreistellig ist.
#    Folglich schlägt das Pattern für '168' komplett fehl!
#
# Wir verwenden deshalb das absolut korrekte Muster:
# ------------------------------------------------------------------------------
IPV4_REGEX='\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b'

# Hilfsfunktion zum Abrufen der Eingabe (Live-Befehl oder Backup-Datei)
get_input() {
    local cmd="$1"
    local file_base="$2"
    
    # Pfade, in denen nach Backup-Dateien gesucht wird (lokal oder im assets-Ordner)
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
    
    # Wenn kein Backup gefunden wurde, führe den Live-Befehl aus
    if command -v "${cmd%% *}" >/dev/null 2>&1; then
        echo -e "${GREEN}[Führe Live-Befehl aus: $cmd]${NC}" >&2
        eval "$cmd" 2>/dev/null
    else
        echo -e "${RED}[Fehler: Befehl '$cmd' nicht verfügbar und kein Backup-File gefunden]${NC}" >&2
        return 1
    fi
}

# Gehe durch die vier geforderten Befehle
for item in "ifconfig:ifconfig" "ip addr:ip_addr" "ip route:ip_route" "nmcli:nmcli"; do
    IFS=":" read -r cmd file <<< "$item"
    echo -e "\n--- Extraktion aus: ${CYAN}$cmd${NC} ---"
    
    output=$(get_input "$cmd" "$file")
    if [ $? -eq 0 ] && [ -n "$output" ]; then
        ips=$(echo "$output" | grep -E -o "$IPV4_REGEX" | sort -u)
        if [ -n "$ips" ]; then
            echo -e "${GREEN}$ips${NC}"
        else
            echo "Keine passenden IPv4-Adressen gefunden."
        fi
    fi
done
