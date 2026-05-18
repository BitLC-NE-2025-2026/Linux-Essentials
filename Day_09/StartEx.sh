#!/bin/bash
# ==============================================================================
# Script:      StartEx.sh
# Beschreibung: Zentrales TUI-Script zur Steuerung und Ausführung der einzelnen
#              Regex-Aufgaben (Day 09). Bietet ein interaktives, farbiges Menü.
# Author:      Tobia
# Datum:       18.05.2026
# ==============================================================================

# Farben für ansprechende Konsolenausgaben (Terminal-Styling)
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
RED='\e[1;31m'
MAGENTA='\e[1;35m'
BLUE='\e[1;34m'
NC='\e[0m' # No Color (Standard-Textfarbe)

# Ermittle den absoluten Pfad des Skripts, um relative Pfad-Probleme zu vermeiden
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_DIR="$BASE_DIR/scripts"

# Stelle sicher, dass das Script-Verzeichnis existiert
if [ ! -d "$SCRIPT_DIR" ]; then
    echo -e "${RED}[Fehler: Verzeichnis '$SCRIPT_DIR' existiert nicht!]${NC}"
    exit 1
fi

# Berechtigungen für alle Sub-Skripte sicherstellen
chmod +x "$SCRIPT_DIR"/*.sh 2>/dev/null

# Funktion zum Zeichnen einer Trennlinie
draw_line() {
    echo -e "${BLUE}─────────────────────────────────────────────────────────────────────────────${NC}"
}

# TUI-Hauptschleife
while true; do
    clear
    echo -e "${BLUE}┌───────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC}              ${MAGENTA}🛠️  LINUX REGEX TASK MANAGER (Day 09) 🛠️${NC}                     ${BLUE}│${NC}"
    echo -e "${BLUE}│${NC}  ${CYAN}Author: Tobia${NC}   │   ${CYAN}Datum: 18.05.2026${NC}   │   ${CYAN}Thema: Reguläre Ausdrücke${NC}  ${BLUE}│${NC}"
    echo -e "${BLUE}└───────────────────────────────────────────────────────────────────────────┘${NC}"
    
    echo -e " Wählen Sie eine Aufgabe aus, die Sie ausführen möchten:\n"
    
    echo -e "  ${GREEN}[1]${NC}  Aufgabe 1:   IPv4-Adressen aus Netzwerk-Outputs extrahieren"
    echo -e "  ${GREEN}[1b]${NC} Aufgabe 1.b: IPv6-Adressen aus Netzwerk-Outputs extrahieren"
    echo -e "  ${GREEN}[2]${NC}  Aufgabe 2:   Netzwerkschnittstellen extrahieren"
    echo -e "  ${GREEN}[3]${NC}  Aufgabe 3:   Usernamen mit UID >= 1000 aus /etc/passwd"
    echo -e "  ${GREEN}[4]${NC}  Aufgabe 4:   Gruppennamen mit GID >= 1000 aus /etc/group"
    echo -e "  ${GREEN}[5]${NC}  Aufgabe 5:   2. Spalte aus /etc/services in neue Datei extrahieren"
    echo -e "  ${GREEN}[6]${NC}  Aufgabe 6:   3-stellige TCP-Ports aus extrahierter Datei filtern & zählen"
    echo -e "  ${GREEN}[7]${NC}  Aufgabe 7:   2- und 5-stellige TCP-Ports filtern & zählen"
    echo -e "  ${GREEN}[8]${NC}  Aufgabe 8:   Einzigartige Transportprotokolle aus Datei 5 zählen"
    echo -e "  ${GREEN}[9]${NC}  Aufgabe 9:   3-stellige / 2- & 5-stellige UDP-Ports filtern & zählen"
    
    draw_line
    echo -e "  ${RED}[x]${NC}  Beenden"
    draw_line
    
    echo -ne " ${YELLOW}Ihre Wahl (1-9, 1b, x): ${NC}"
    read -r choice
    
    case "$choice" in
        1)
            clear
            bash "$SCRIPT_DIR/task_1_ipv4.sh"
            ;;
        1b|1B)
            clear
            bash "$SCRIPT_DIR/task_1b_ipv6.sh"
            ;;
        2)
            clear
            bash "$SCRIPT_DIR/task_2_interfaces.sh"
            ;;
        3)
            clear
            bash "$SCRIPT_DIR/task_3_passwd_users.sh"
            ;;
        4)
            clear
            bash "$SCRIPT_DIR/task_4_group_names.sh"
            ;;
        5)
            clear
            bash "$SCRIPT_DIR/task_5_extract_services.sh"
            ;;
        6)
            clear
            bash "$SCRIPT_DIR/task_6_count_3digit_tcp.sh"
            ;;
        7)
            clear
            bash "$SCRIPT_DIR/task_7_count_2_5digit_tcp.sh"
            ;;
        8)
            clear
            bash "$SCRIPT_DIR/task_8_unique_protocols.sh"
            ;;
        9)
            clear
            bash "$SCRIPT_DIR/task_9_count_udp.sh"
            ;;
        x|X|q|Q)
            echo -e "\n${GREEN}Vielen Dank fürs Nutzen des Regex Task Managers. Bis zum nächsten Mal!${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}[Ungültige Auswahl! Bitte eine Nummer von 1 bis 9, 1b oder 'x' eingeben.]${NC}"
            ;;
    esac
    
    echo -ne "\n${YELLOW}Drücken Sie [ENTER], um zum Menü zurückzukehren...${NC}"
    read -r
done
