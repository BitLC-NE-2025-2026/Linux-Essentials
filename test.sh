#!/usr/bin/env bash

# Zentrales Skript zum Neustarten oder Herunterfahren der definierten Hosts.


# Liste der Ziel-IPs (Wartbarkeit: IP-Adressen an einer zentralen Stelle)
hosts=("172.25.99.72" "172.25.99.105" "172.25.77.72" "172.25.77.105" "172.25.55.105")

# Prüfung, ob ein Parameter übergeben wurde
if [[ "$1" == "" ]]; then
    for host in "${hosts[@]}"; do
        ssh root@"$host" 'reboot' &
    done
elif [[ "$1" == "s" ]]; then
    for host in "${hosts[@]}"; do
        ssh root@"$host" 'shutdown -h now' &
    done
fi
