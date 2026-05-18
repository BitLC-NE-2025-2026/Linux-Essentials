#!/bin/bash
# ==============================================================================
# Script:      task_8_unique_protocols.sh
# Beschreibung: Ermittelt die Anzahl der unterschiedlichen (einzigartigen)
#              Transportprotokolle in der in Aufgabe 5 erstellten Datei.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 8: Einzigartige Transportprotokolle zählen ===${NC}"
echo -e "Extrahiert und zählt alle einzigartigen Protokolle (z.B. tcp, udp, sctp).\n"

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
# REGEX & PIPELINE ERKLÄRUNG:
# Jede Zeile in services_extracted.txt hat das Format 'port/protokoll'.
#
# Pipeline-Schritte:
# 1. grep -E -o '[a-zA-Z0-9_-]+$'
#    - Extrahiert nur den Protokoll-Namen (das Wort nach dem Schrägstrich am Zeilenende)
#    - [a-zA-Z0-9_-]+ -> Beliebige Wortzeichen und Bindestriche
#    - $              -> Verankert am Zeilenende
# 2. sort -u
#    - Sortiert die Ausgabe alphabetisch und entfernt alle Duplikate (-u steht für unique)
# ------------------------------------------------------------------------------

echo -e "\nGefundene einzigartige Transportprotokolle:"
echo -e "-------------------------------------------"

# Protokolle extrahieren, deduplizieren und ausgeben
protocols=$(grep -E -o '[a-zA-Z0-9_-]+$' "$EXTRACTED_FILE" | sort -u)
echo -e "${GREEN}$protocols${NC}"

# Anzahl zählen (Zeilen zählen)
count=$(echo "$protocols" | wc -l)

echo -e "-------------------------------------------"
echo -e "${CYAN}Gesamtanzahl unterschiedlicher Protokolle: $count${NC}"
