#!/bin/bash
# ==============================================================================
# Script:      task_4_group_names.sh
# Beschreibung: Extrahiert alle Gruppennamen aus /etc/group, deren GID >= 1000 ist.
#              Nutzt Regex zur Identifikation der GID.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 4: Gruppennamen mit GID >= 1000 aus /etc/group ===${NC}"
echo -e "Dieses Skript liest die Gruppendatenbank und filtert reguläre Gruppen heraus.\n"

# Datei finden
GROUP_FILE=""
for file in "groupdat" "groupDat" "assets/groupdat" "assets/groupDat" "../assets/groupdat" "../assets/groupDat" "/etc/group"; do
    if [ -f "$file" ]; then
        GROUP_FILE="$file"
        break
    fi
done

if [ -z "$GROUP_FILE" ]; then
    echo -e "${RED}[Fehler: Weder groupdat noch /etc/group wurde gefunden]${NC}"
    exit 1
fi

echo -e "${YELLOW}[Lese aus Datei: $GROUP_FILE]${NC}"

# ------------------------------------------------------------------------------
# REGEX-ERKLÄRUNG:
# Das Format von /etc/group ist: gruppenname:passwort:GID:userliste
#
# Wir wollen GIDs >= 1000 filtern.
# Regex für GID >= 1000: [1-9][0-9]{3,} (mindestens 4 Ziffern)
#
# Der gesamte Zeilen-Regex:
#   ^[^:]+:[^:]+:[1-9][0-9]{3,}:
#   - ^[^:]+         -> Matcht den Gruppennamen am Zeilenanfang
#   - :[^:]+         -> Matcht das Passwort-Feld (meistens 'x' oder leer)
#   - :[1-9][0-9]{3,}: -> Matcht die GID >= 1000, gefolgt von Doppelpunkt
# ------------------------------------------------------------------------------

echo -e "\nTreffer (Format: Gruppenname (GID)):"
echo -e "------------------------------------"

grep -E '^[^:]+:[^:]+:[1-9][0-9]{3,}:' "$GROUP_FILE" | while read -r line; do
    groupname=$(echo "$line" | cut -d: -f1)
    gid=$(echo "$line" | cut -d: -f3)
    echo -e "${GREEN}- $groupname (GID: $gid)${NC}"
done

total=$(grep -E -c '^[^:]+:[^:]+:[1-9][0-9]{3,}:' "$GROUP_FILE")
echo -e "\n${CYAN}Gesamtanzahl gefundener Gruppen: $total${NC}"
