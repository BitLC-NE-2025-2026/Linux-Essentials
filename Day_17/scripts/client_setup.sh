#!/usr/bin/env bash
# ==============================================================================
# MNBTUI Module: client_setup.sh
# Autor: Tobias Boyke
# Zweck: Dynamische Client Netzwerk-Konfiguration statischer IPs, Gateways & DNS
# ==============================================================================

set -euo pipefail

# Pfade zu Konfigurationsdaten
CONFIG_PATH="$(dirname "$0")/../config.yaml"
PARSER="$(dirname "$0")/parse_config.py"

CURRENT_HOST=$(hostname -s)
ROUTER_HOST=$(python3 "$PARSER" "$CONFIG_PATH" "router:hostname")

if [[ "$CURRENT_HOST" == "$ROUTER_HOST" ]]; then
    whiptail --title "Fehler: Host-Rolle" --msgbox "Dieses Skript ist nur für Client-VMs vorgesehen.\nDieser Host ist als Router konfiguriert!" 10 55
    exit 1
fi

whiptail --title "Client-Konfiguration" --infobox "Lese Netzwerkeinstellungen für $CURRENT_HOST aus..." 8 50

# Statische Werte aus YAML parsen
CLIENT_IP=$(python3 "$PARSER" "$CONFIG_PATH" "client:$CURRENT_HOST:ip")
CLIENT_GW=$(python3 "$PARSER" "$CONFIG_PATH" "client:$CURRENT_HOST:gateway")
DNS_SERVER=$(python3 "$PARSER" "$CONFIG_PATH" "global:dns_fallback")

# Fallback falls temporär DNS ausgewählt wurde
if [[ -f /tmp/selected_dns.txt ]]; then
    DNS_SERVER=$(cat /tmp/selected_dns.txt)
fi

if [[ -z "$CLIENT_IP" || -z "$CLIENT_GW" ]]; then
    whiptail --title "Fehler: Konfiguration fehlt" --msgbox "Für den Hostname '$CURRENT_HOST' wurden keine Netzwerkeinstellungen in config.yaml gefunden!" 10 55
    exit 1
fi

# Erste aktive physische Schnittstelle ermitteln (außer lo)
INTERFACE=$(ip -br link | grep -v 'lo' | awk '{print $1}' | head -n 1)

if [[ -z "$INTERFACE" ]]; then
    whiptail --title "Fehler: Hardware" --msgbox "Es wurde keine aktive Netzwerkschnittstelle im System gefunden!" 10 55
    exit 1
fi

whiptail --title "Netzwerk wird eingerichtet" --infobox "Konfiguriere Interface $INTERFACE mit IP $CLIENT_IP..." 8 55

# Schnittstelle mit nmcli konfigurieren
nmcli con modify "$INTERFACE" ipv4.addresses "$CLIENT_IP" ipv4.gateway "$CLIENT_GW" ipv4.dns "$DNS_SERVER" ipv4.method manual || \
nmcli con add type ethernet con-name "$INTERFACE" ifname "$INTERFACE" ipv4.addresses "$CLIENT_IP" ipv4.gateway "$CLIENT_GW" ipv4.dns "$DNS_SERVER" ipv4.method manual

# Schnittstelle neu starten
nmcli con down "$INTERFACE" || true
nmcli con up "$INTERFACE"

# 2. nftables für Client schreiben (einfache Firewall)
sudo systemctl stop firewalld >/dev/null 2>&1 || true
sudo systemctl disable firewalld >/dev/null 2>&1 || true

cat << EOF | sudo tee /etc/nftables.conf >/dev/null
flush ruleset
table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        iif "lo" accept
        ct state established,related accept
        tcp dport 22 accept
        ip protocol icmp accept
    }
    chain forward {
        type filter hook forward priority 0; policy drop;
    }
}
EOF

sudo systemctl enable nftables --now >/dev/null 2>&1 || true

whiptail --title "Client-Erfolg" --msgbox "Der Client $CURRENT_HOST wurde erfolgreich eingerichtet!\n\n- Interface: $INTERFACE\n- IP-Adresse: $CLIENT_IP\n- Standard-Gateway: $CLIENT_GW\n- DNS-Server: $DNS_SERVER\n- nftables-Schutz aktiv" 14 55
