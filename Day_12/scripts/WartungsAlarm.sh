#!/bin/bash

# Nachricht definieren
MESSAGE="ACHTUNG: Systemwartung startet in Kürze!"

# Alle aktiven pts-Terminals finden
# 'who' listet Sessions, 'grep' filtert nach 'pts/', 
# 'sed' oder 'awk' extrahiert die ID (die Zahl nach pts/)
# Regex-Logik: Wir suchen nach 'pts/' gefolgt von einer oder mehreren Ziffern
TERMINALS=$(who | grep -oP 'pts/\K[0-9]+')

# Iteration über alle gefundenen Terminals
for TTY_ID in $TERMINALS; do
    # Nachricht direkt in das entsprechende Gerät schreiben
    # Erfordert Root-Rechte
    echo "$MESSAGE" > "/dev/pts/$TTY_ID"
done
