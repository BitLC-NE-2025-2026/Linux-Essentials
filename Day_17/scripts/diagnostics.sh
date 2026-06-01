#!/usr/bin/env bash
# ==============================================================================
# OmniTUI Module: diagnostics.sh
# Autor: Tobias Boyke
# Zweck: Integrierte Netzwerk- & Konnektivitäts-Diagnose (FHD Optimiert)
# ==============================================================================

set -euo pipefail

# Pfade zu Konfigurationsdaten
CONFIG_PATH="$(dirname "$0")/../config.yaml"
PARSER="$(dirname "$0")/parse_config.py"

CURRENT_HOST=$(hostname -s)
DIAG_LOG="/tmp/omnitui_diagnostics.txt"
rm -f "$DIAG_LOG"

whiptail --title "Netzwerk-Diagnose läuft" --infobox "Führe automatisierte Latenz- & Routingtests im Subnetz durch..." 8 70

# Header für den Diagnosebericht schreiben
{
    echo "============================================================================="
    echo "            OmniTUI NETZWERK-DIAGNOSEBERICHT  --  $(date)"
    echo "============================================================================="
    echo "Lokaler Hostname: $CURRENT_HOST"
    echo ""
} >> "$DIAG_LOG"

# 1. Lokale Interfaces & IPs
{
    echo "--- [1] Lokale Netzwerkschnittstellen ---"
    ip -br -4 a || echo "Fehler beim Lesen der IP-Adressen"
    echo ""
} >> "$DIAG_LOG"

# 2. Lokale Routing-Tabelle
{
    echo "--- [2] Routing-Tabelle ---"
    ip route show || echo "Fehler beim Lesen der Routing-Tabelle"
    echo ""
} >> "$DIAG_LOG"

# 3. DNS-Auflösungs-Check
{
    echo "--- [3] DNS-Auflösung & Internet-Check ---"
    if curl -sI --connect-timeout 3 https://www.google.com >/dev/null; then
        echo "[OK] Internetverbindung steht (HTTPS-Test erfolgreich)."
    else
        echo "[WARNUNG] Keine direkte HTTPS-Verbindung ins Internet."
    fi
    
    # DNS-Prüfung
    if host_out=$(host google.com 2>/dev/null); then
        echo "[OK] DNS-Auflösung aktiv (google.com gelöst)."
    elif ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
        echo "[FEHLER] Ping an 1.1.1.1 erfolgreich, aber DNS-Auflösung fehlgeschlagen (Nameserver-Problem!)."
    else
        echo "[FEHLER] Keine Internetkonnektivität (Weder Ping noch DNS)."
    fi
    echo ""
} >> "$DIAG_LOG"

# 4. Topologie-Verbindungstests (Auslesen aus config.yaml)
{
    echo "--- [4] Topologie-Konnektivitätstests ---"
    
    # Gateway anpingen
    ROUTER_HOST=$(python3 "$PARSER" "$CONFIG_PATH" "router:hostname")
    
    if [[ "$CURRENT_HOST" == "$ROUTER_HOST" ]]; then
        # Wir sind der Router: Pinge alle konfigurierten Clients an
        echo "Rolle: Router. Pinge konfigurierte Clients an..."
        CLIENTS=$(python3 "$PARSER" "$CONFIG_PATH" "clients_list")
        for client in $CLIENTS; do
            client_ip=$(python3 "$PARSER" "$CONFIG_PATH" "client:$client:ip" | cut -d'/' -f1)
            if [[ -n "$client_ip" ]]; then
                if ping -c 2 -W 2 "$client_ip" >/dev/null 2>&1; then
                    echo "  ➜ Client $client ($client_ip): [ONLINE]"
                else
                    echo "  ➜ Client $client ($client_ip): [OFFLINE / UNREACHABLE]"
                fi
            fi
        done
    else
        # Wir sind ein Client: Pinge Router / Gateways an
        echo "Rolle: Client. Pinge Gateways an..."
        CLIENT_GW=$(python3 "$PARSER" "$CONFIG_PATH" "client:$CURRENT_HOST:gateway")
        if [[ -n "$CLIENT_GW" ]]; then
            if ping -c 2 -W 2 "$CLIENT_GW" >/dev/null 2>&1; then
                echo "  ➜ Standard-Gateway $CLIENT_GW: [ONLINE] (Verbindung zum Router steht)."
            else
                echo "  ➜ Standard-Gateway $CLIENT_GW: [OFFLINE] (Keine Verbindung zum Router!)."
            fi
        else
            echo "  [FEHLER] Kein Standard-Gateway in config.yaml für diesen Client deklariert."
        fi
    fi
    echo "============================================================================="
} >> "$DIAG_LOG"

# Ergebnis in scrollbarer TUI-Textbox ausgeben
whiptail --title "System- & Netzwerk-Diagnoseergebnisse" --scrolltext --textbox "$DIAG_LOG" 24 85
