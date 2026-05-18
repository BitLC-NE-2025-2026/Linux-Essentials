#!/bin/bash
# ==============================================================================
# Script:      task_9_count_udp.sh
# Beschreibung: Führt die Analysen aus Aufgaben 6 und 7 für das Transport-
#              protokoll 'udp' aus (3-stellig sowie 2- und 5-stellig).
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 9: UDP-Ports zählen (wie 6 & 7) ===${NC}"
echo -e "Zählt 3-stellige, sowie 2- und 5-stellige Ports für das Protokoll 'udp'.\n"

EXTRACTED_FILE=""
for file in "services_extracted.txt" "../services_extracted.txt" "assets/services_extracted.txt" "../assets/services_extracted.txt"; do
    if [ -f "$file" ]; then
        EXTRACTED_FILE="$file"
        break
    fi
done

if [ -z "$EXTRACTED_FILE" ] || [ ! -s "$EXTRACTED_FILE" ]; then
    echo -e "${RED}[Fehler: 'services_extracted.txt' nicht gefunden oder leer.]${NC}"
    echo -e "${YELLOW}Bitte führen Sie zuerst Aufgabe 5 aus!${NC}"
    exit 1
fi

echo -e "${YELLOW}[Lese aus Datei: $EXTRACTED_FILE]${NC}"

# Zählungen durchführen mit grep
count_3=$(grep -E -c '^[0-9]{3}/udp$' "$EXTRACTED_FILE")
count_2=$(grep -E -c '^[0-9]{2}/udp$' "$EXTRACTED_FILE")
count_5=$(grep -E -c '^[0-9]{5}/udp$' "$EXTRACTED_FILE")
count_2_5=$(grep -E -c '^([0-9]{2}|[0-9]{5})/udp$' "$EXTRACTED_FILE")

echo -e "\nErgebnisse für UDP:"
echo -e "------------------------------------"
echo -e "${GREEN}- 3-stellige UDP-Ports: $count_3${NC}"
echo -e "${GREEN}- 2-stellige UDP-Ports: $count_2${NC}"
echo -e "${GREEN}- 5-stellige UDP-Ports: $count_5${NC}"
echo -e "------------------------------------"
echo -e "${CYAN}Summe 2- oder 5-stellige UDP-Ports: $count_2_5${NC}"
