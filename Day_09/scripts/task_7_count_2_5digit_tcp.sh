#!/bin/bash
# ==============================================================================
# Script:      task_7_count_2_5digit_tcp.sh
# Beschreibung: Filtert alle 2- und 5-stelligen Portnummern mit dem Protokoll
#              'tcp' heraus und zählt diese.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 7: 2- und 5-stellige TCP-Ports zählen ===${NC}"
echo -e "Filtert und zählt Ports im Format XX/tcp (2 Ziffern) oder XXXXX/tcp (5 Ziffern).\n"

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

# ------------------------------------------------------------------------------
# REGEX-ERKLÄRUNG:
# Wir wollen Ports mit 2 ODER 5 Ziffern und Protokoll tcp matchen.
# Regex: ^([0-9]{2}|[0-9]{5})/tcp$
# - ^                 -> Zeilenanfang
# - (                 -> Start der Gruppe für Alternation
#   - [0-9]{2}        -> Genau 2 Ziffern
#   - |               -> ODER Operator
#   - [0-9]{5}        -> Genau 5 Ziffern
# - )                 -> Ende der Gruppe
# - /tcp              -> Protokoll tcp
# - $                 -> Zeilenende
# ------------------------------------------------------------------------------

# Zählung für 2-stellige Ports
count_2=$(grep -E -c '^[0-9]{2}/tcp$' "$EXTRACTED_FILE")
# Zählung für 5-stellige Ports
count_5=$(grep -E -c '^[0-9]{5}/tcp$' "$EXTRACTED_FILE")
# Gesamtzählung der Kombination
count_total=$(grep -E -c '^([0-9]{2}|[0-9]{5})/tcp$' "$EXTRACTED_FILE")

echo -e "\nErgebnisse:"
echo -e "------------------------------------"
echo -e "${GREEN}- 2-stellige TCP-Ports: $count_2${NC}"
echo -e "${GREEN}- 5-stellige TCP-Ports: $count_5${NC}"
echo -e "------------------------------------"
echo -e "${CYAN}Gesamtsumme (2- oder 5-stellig): $count_total${NC}"
