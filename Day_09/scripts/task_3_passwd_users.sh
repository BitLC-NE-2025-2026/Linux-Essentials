#!/bin/bash
# ==============================================================================
# Script:      task_3_passwd_users.sh
# Beschreibung: Extrahiert alle Benutzernamen aus /etc/passwd, deren UID >= 1000 ist.
#              Nutzt Regex zur Identifikation der UID.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${CYAN}=== Aufgabe 3: Usernamen mit UID >= 1000 aus /etc/passwd ===${NC}"
echo -e "Dieses Skript liest die Benutzerdatenbank und filtert reguläre User heraus.\n"

# Datei finden (verschiedene Pfade prüfen)
PASSWD_FILE=""
for file in "passwdDat" "assets/passwdDat" "../assets/passwdDat" "/etc/passwd"; do
    if [ -f "$file" ]; then
        PASSWD_FILE="$file"
        break
    fi
done

if [ -z "$PASSWD_FILE" ]; then
    echo -e "${RED}[Fehler: Weder passwdDat noch /etc/passwd wurde gefunden]${NC}"
    exit 1
fi

echo -e "${YELLOW}[Lese aus Datei: $PASSWD_FILE]${NC}"

# ------------------------------------------------------------------------------
# REGEX-ERKLÄRUNG:
# Das Format von /etc/passwd ist: username:password:UID:GID:gecos:home:shell
#
# Wir wollen UIDs >= 1000 filtern.
# Eine Zahl ist >= 1000, wenn sie mindestens 4 Stellen hat und nicht mit 0 beginnt.
# Regex für UID >= 1000: [1-9][0-9]{3,} (also eine Ziffer ab 1, gefolgt von mindestens 3 Ziffern).
#
# Der gesamte Zeilen-Regex:
#   ^[^:]+:[^:]+:[1-9][0-9]{3,}:
#   - ^[^:]+         -> Matcht den Usernamen am Zeilenanfang (alles außer Doppelpunkt)
#   - :[^:]+         -> Matcht das Passwort-Feld (meistens 'x')
#   - :[1-9][0-9]{3,}: -> Matcht den Doppelpunkt, die UID >= 1000 und den darauffolgenden Doppelpunkt
# ------------------------------------------------------------------------------

echo -e "\nTreffer (Format: Username (UID)):"
echo -e "----------------------------------"

# Filterung der Zeilen mit dem Regex und schöne Formatierung
grep -E '^[^:]+:[^:]+:[1-9][0-9]{3,}:' "$PASSWD_FILE" | while read -r line; do
    username=$(echo "$line" | cut -d: -f1)
    uid=$(echo "$line" | cut -d: -f3)
    echo -e "${GREEN}- $username (UID: $uid)${NC}"
done

# Zeige Gesamtanzahl der Benutzer
total=$(grep -E -c '^[^:]+:[^:]+:[1-9][0-9]{3,}:' "$PASSWD_FILE")
echo -e "\n${CYAN}Gesamtanzahl gefundener User: $total${NC}"
