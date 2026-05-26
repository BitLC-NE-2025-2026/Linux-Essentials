#!/bin/bash

# ==============================================================================
# Skriptname:       whiptail_manager.sh
# Version:          1.3
# Zweck:            Erweiterte grafische TUI zur Steuerung der Benutzerverwaltung
# Parameter:        Keine
# Rueckgabewert:    0 bei fehlerfreier Ausfuehrung, 1 bei Abbruechen
# Voraussetzungen:  Administrative Rechte, whiptail, ausfuehrbare Unterskripte
# Architektur:      Modulares Design, grafische Dialoge, Endlosschleife
# Author:           Tobias B
# ==============================================================================

set -euo pipefail

PROVISION_SCRIPT="./user_provisioning.sh"
DEPROVISION_SCRIPT="./user_deprovisioning.sh"
LOG_FILE="./userlog.md"

# ==============================================================================
# Funktion: check_requirements
# Zweck:    Prueft administrative Rechte und alle notwendigen Systemkomponenten
# ==============================================================================
check_requirements() {
    if [[ $EUID -ne 0 ]]; then
        echo "Kritischer Fehler: Das Skript erfordert administrative Rechte."
        exit 1
    fi

    if ! command -v whiptail &> /dev/null; then
        echo "Kritischer Fehler: Das Paket whiptail ist nicht installiert."
        exit 1
    fi

    if [[ ! -x "$PROVISION_SCRIPT" ]]; then
        echo "Kritischer Fehler: $PROVISION_SCRIPT fehlt oder ist nicht ausfuehrbar."
        exit 1
    fi

    if [[ ! -x "$DEPROVISION_SCRIPT" ]]; then
        echo "Kritischer Fehler: $DEPROVISION_SCRIPT fehlt oder ist nicht ausfuehrbar."
        exit 1
    fi
}

# ==============================================================================
# Funktion: show_log
# Zweck:    Liest die Protokolldatei ein und stellt sie in einer Textbox dar
# ==============================================================================
show_log() {
    if [[ -f "$LOG_FILE" ]]; then
        whiptail --title "Verarbeitungsprotokoll" --textbox "$LOG_FILE" 22 80
    else
        whiptail --title "Dateifehler" --msgbox "Die Protokolldatei existiert noch nicht im System." 8 50
    fi
}

# ==============================================================================
# Funktion: main_menu
# Zweck:    Stellt das interaktive Hauptmenue via whiptail dar und steuert Logik
# ==============================================================================
main_menu() {
    local choice

    while true; do
        # whiptail sendet die Menueauswahl an den Standardfehlerkanal
        # Dateideskriptoren werden getauscht um den Rueckgabewert zu laden
        choice=$(whiptail --title "Benutzerverwaltung Manager" \
                          --menu "Bitte waehlen Sie eine Systemaktion:" 16 65 5 \
                          "1" "Benutzer automatisiert anlegen" \
                          "2" "Benutzer interaktiv loeschen" \
                          "3" "Protokolldatei anzeigen" \
                          "4" "Programm beenden" 3>&1 1>&2 2>&3)

        # Abfangen der Abbruchtasten zur sauberen Systembeendigung
        if [[ $? -ne 0 ]]; then
            break
        fi

        case "$choice" in
            1)
                whiptail --title "Systemstatus" --msgbox "Starte Provisionierung" 8 45
                clear
                "$PROVISION_SCRIPT"
                echo ""
                read -r -p "ENTER druecken fuer Rueckkehr zum Menue" _
                ;;
            2)
                whiptail --title "Systemstatus" --msgbox "Starte Deprovisionierung" 8 45
                clear
                "$DEPROVISION_SCRIPT"
                echo ""
                read -r -p "ENTER druecken fuer Rueckkehr zum Menue" _
                ;;
            3)
                show_log
                ;;
            4)
                break
                ;;
        esac
    done

    clear
    echo "Programm erfolgreich beendet."
}

# ==============================================================================
# Hauptprogramm
# ==============================================================================
main() {
    check_requirements
    main_menu
}

main
