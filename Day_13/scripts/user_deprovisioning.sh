#!/bin/bash

# ==============================================================================
# Skriptname:       user_deprovisioning.sh
# Version:          1.0
# Zweck:            Interaktives Loeschen von Benutzern basierend auf Logdatei
# Parameter:        Keine
# Rueckgabewert:    0 bei fehlerfreier Ausfuehrung, 1 bei Abbruechen
# Voraussetzungen:  Administrative Rechte
# Architektur:      Separation of Concerns, Modularisierung
# Author:           Tobias B
# ==============================================================================

set -euo pipefail

LOG_FILE="userlog.md"

# ==============================================================================
# Funktion: check_root
# Zweck:    Prueft Berechtigungen zur Ausfuehrung kritischer Systembefehle
# ==============================================================================
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Kritischer Fehler: Das Skript erfordert administrative Rechte."
        exit 1
    fi
}

# ==============================================================================
# Funktion: get_users_from_log
# Zweck:    Extrahiert alle erfolgreich angelegten Benutzernamen aus der Logdatei
# ==============================================================================
get_users_from_log() {
    if [[ ! -f "$LOG_FILE" ]]; then
        echo "Kritischer Fehler: Logdatei nicht gefunden."
        exit 1
    fi
    
    grep "Konto erfolgreich angelegt" "$LOG_FILE" | sed -n 's/.*Account \([^:]*\):.*/\1/p' | sort -u
}

# ==============================================================================
# Funktion: delete_user
# Zweck:    Loescht einen spezifischen Benutzer samt Heimatverzeichnis
# Parameter 1: Benutzername
# ==============================================================================
delete_user() {
    local username="$1"
    if id "$username" &>/dev/null; then
        userdel -r "$username"
        echo "Erfolg: Benutzer $username vollstaendig entfernt."
    else
        echo "Hinweis: Benutzer $username existiert nicht im System."
    fi
}

# ==============================================================================
# Funktion: interactive_deletion
# Zweck:    Steuert die Benutzereingabe und iteriert durch die Accountliste
# ==============================================================================
interactive_deletion() {
    local users
    mapfile -t users < <(get_users_from_log)

    if [[ ${#users[@]} -eq 0 ]]; then
        echo "Hinweis: Keine angelegten Benutzer in der Logdatei gefunden."
        exit 0
    fi

    echo "Modusauswahl fuer Deprovisionierung:"
    echo "1 Alle bekannten Benutzer aus Logdatei loeschen"
    echo "2 Selektives Loeschen je Benutzerkonto"
    echo "3 Skript abbrechen"
    
    read -r -p "Eingabe: " option

    case "$option" in
        1)
            for user in "${users[@]}"; do
                delete_user "$user"
            done
            ;;
        2)
            for user in "${users[@]}"; do
                read -r -p "Benutzer $user loeschen j/n: " choice
                if [[ "$choice" == "j" || "$choice" == "J" ]]; then
                    delete_user "$user"
                else
                    echo "Uebersprungen: $user"
                fi
            done
            ;;
        3)
            echo "Vorgang durch Benutzer abgebrochen."
            exit 0
            ;;
        *)
            echo "Fehler: Ungueltige Auswahl."
            exit 1
            ;;
    esac
}

# ==============================================================================
# Hauptprogramm
# ==============================================================================
main() {
    check_root
    interactive_deletion
}

main
