#!/bin/bash
# ==============================================================================
# Skript: WartungsAlarm.sh
# Author: Tobias Boyke
# Beschreibung: Zeigt aktive Sessions an und sendet eine Nachricht an alle.
# ==============================================================================

MESSAGE="ACHTUNG: Systemwartung startet in Kürze!"

echo "-----------------------------------"
echo "Aktive Benutzer | Terminal-ID"
echo "-----------------------------------"

# Parsing:
# grep 'pts/' filtert sicher auf Netzwerk-Terminals.
who | grep 'pts/' | awk '{printf "%-15s | %-10s\n", $1, $2}'

echo "-----------------------------------"

# Extraktion al Arry:
mapfile -t TERMINALS < <(who | grep -oP 'pts/\K[0-9]+')

# Iteration:
for TTY_ID in "${TERMINALS[@]}"; do
    # Vor dem Schreiben prüfen, ob das Gerät existiert und schreibbar ist
    if [ -w "/dev/pts/$TTY_ID" ]; then
        echo -e "\n\n$MESSAGE\n\n" > "/dev/pts/$TTY_ID"
    fi
done

echo "Nachricht an ${#TERMINALS[@]} Terminal(s) gesendet."
