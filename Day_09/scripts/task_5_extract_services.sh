#!/bin/bash
# ==============================================================================
# Script:      task_5_extract_services.sh
# Beschreibung: Extrahiert die 2. Spalte aus /etc/services (ohne Kommentar-
#              und Leerzeilen) und speichert sie in einer neuen Datei ab.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 5: 2. Spalte aus /etc/services extrahieren ===${NC}"
echo -e "Dieses Skript extrahiert die Port/Protokoll-Spalte aus der Services-Datenbank.\n"

# Datei finden
SERVICES_FILE=""
for file in "servicesDat" "assets/servicesDat" "../assets/servicesDat" "/etc/services"; do
    if [ -f "$file" ]; then
        SERVICES_FILE="$file"
        break
    fi
done

if [ -z "$SERVICES_FILE" ]; then
    echo -e "${RED}[Fehler: Weder servicesDat noch /etc/services wurde gefunden]${NC}"
    exit 1
fi

# Bestimme Speicherort der Ausgabedatei
# Wenn das Skript im Ordner 'scripts' ausgeführt wird, speichern wir eine Ebene höher (in Day_09).
OUTPUT_FILE="services_extracted.txt"
if [ "$(basename "$PWD")" = "scripts" ]; then
    OUTPUT_FILE="../services_extracted.txt"
fi

echo -e "${YELLOW}[Lese aus Datei: $SERVICES_FILE]${NC}"
echo -e "${YELLOW}[Schreibe in Datei: $OUTPUT_FILE]${NC}"

# ------------------------------------------------------------------------------
# REGEX & SED ERKLÄRUNG:
# Wir wollen Leerzeilen und Kommentarzeilen (beginnen mit #, evtl. Leerzeichen davor)
# ignorieren. Die verbleibenden Zeilen haben das Format:
# dienstname    port/protokoll    # kommentar
#
# Wir nutzen sed mit zwei Operationen, getrennt durch ein Semikolon:
# 1. '/^[[:space:]]*(#|$)/d' -> Löscht Zeilen (d für delete), die mit optionalen
#    Leerzeichen und einem '#' beginnen, ODER die ganz leer sind ($).
# 2. 's/^[[:space:]]*[^[:space:]]+[[:space:]]+([^[:space:]]+).*/\1/'
#    - s/                       -> Substitutions-Befehl (Suchen und Ersetzen)
#    - ^[[:space:]]*            -> Optionaler Whitespace am Zeilenanfang
#    - [^[:space:]]+            -> Der Dienstname (beliebige Nicht-Whitespace-Zeichen)
#    - [[:space:]]+             -> Das Whitespace-Trennzeichen zur 2. Spalte
#    - ([^[:space:]]+)          -> Capture Group 1: Das zweite Feld (port/protokoll)
#    - .*                       -> Der Rest der Zeile (weitere Tabs, Kommentare)
#    - / \1 /                   -> Ersetzt die gesamte Zeile durch den gematchten Inhalt der Capture Group 1
# ------------------------------------------------------------------------------

# Führe Extraktion aus
sed -E '/^[[:space:]]*(#|$)/d; s/^[[:space:]]*[^[:space:]]+[[:space:]]+([^[:space:]]+).*/\1/' "$SERVICES_FILE" > "$OUTPUT_FILE"

if [ $? -eq 0 ] && [ -s "$OUTPUT_FILE" ]; then
    echo -e "\n${GREEN}Erfolgreich extrahiert!${NC}"
    echo -e "Erste 10 Zeilen der neuen Datei:"
    echo -e "--------------------------------"
    head -n 10 "$OUTPUT_FILE" | sed 's/^/- /'
    total_lines=$(wc -l < "$OUTPUT_FILE")
    echo -e "--------------------------------"
    echo -e "${CYAN}Gesamtanzahl extrahierter Zeilen: $total_lines${NC}"
else
    echo -e "${RED}[Fehler bei der Extraktion oder Datei ist leer]${NC}"
    exit 1
fi
