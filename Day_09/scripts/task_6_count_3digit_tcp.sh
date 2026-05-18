#!/bin/bash
# ==============================================================================
# Script:      task_6_count_3digit_tcp.sh
# Beschreibung: Nutzt das Ergebnis aus Aufgabe 5 und filtert alle 3-stelligen
#              Portnummern mit dem Protokoll 'tcp' heraus und zählt diese.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 6: 3-stellige TCP-Ports zählen ===${NC}"
echo -e "Filtert und zählt Ports im Format XXX/tcp (genau 3 Ziffern).\n"

# Ausgabedatei aus Aufgabe 5 suchen (prüft verschiedene Verzeichnisebenen)
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
# Wir suchen nach exakt 3 Ziffern, gefolgt von '/tcp'.
# Regex: ^[0-9]{3}/tcp$
# - ^         -> Zeilenanfang (verhindert z.B. das Matchen von 4-stelligen Ports von hinten)
# - [0-9]{3}  -> Genau 3 Ziffern (000 bis 999)
# - /tcp      -> Das Protokoll tcp
# - $         -> Zeilenende (verhindert das Matchen von mehrstelligen Ports von vorne)
# ------------------------------------------------------------------------------

# Treffer anzeigen
echo -e "\nEinige Treffer-Beispiele (erste 10):"
echo -e "------------------------------------"
grep -E '^[0-9]{3}/tcp$' "$EXTRACTED_FILE" | head -n 10 | sed 's/^/- /'

# Zählen der Treffer (-c Option in grep gibt direkt die Anzahl aus)
count=$(grep -E -c '^[0-9]{3}/tcp$' "$EXTRACTED_FILE")

echo -e "------------------------------------"
echo -e "${GREEN}Gesamtanzahl 3-stelliger TCP-Ports: $count${NC}"
