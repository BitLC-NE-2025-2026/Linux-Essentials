#!/usr/bin/env bash
# ==============================================================================
# Projektname: MiniNetzAutoBuilder Plus
# Autor: Tobias Boyke
# Datum: 2026-05-29
# Zweck: Universelles System und Netzwerk Setup
# Beschreibung: Konfiguriert Netzwerk, SSH, Nftables, ZSH und Fastfetch.
# Nutzt das SFC Muster zur modularen und sicheren Ausführung.
#
# Bekannte Hosts in der Topologie:
# gw-router: Externes Gateway
# rocky-host: Physikalischer Host
# srv-rocky: Zentraler Router
# srv-deb-01: Client Debian Netz A
# ws-cachy: Client CachyOS Netz A
# srv-deb-02: Client Debian Netz B
# ws-manjaro: Client Manjaro Netz B
# ==============================================================================

set -euo pipefail

CURRENT_HOST=$(hostname -s)
DNS_SERVER="1.1.1.1"
ROUTER_HOST="srv-rocky"
TARGET_USER=${SUDO_USER:-root}
USER_HOME=$(eval echo "~$TARGET_USER")

# ==============================================================================
# Funktion: log_info, log_success, log_err
# Zweck: Formatierte Konsolenausgabe
# Parameter: Textnachricht
# Rückgabewert: Konsolenausgabe, bei log_err Skriptabbruch
# ==============================================================================
log_info() { echo "[INFO] $1"; }
log_success() { echo "[ERFOLG] $1"; }
log_err() { echo "[FEHLER] $1"; exit 1; }

if [[ $EUID -ne 0 ]]; then
    log_err "Dieses Skript erfordert Root Rechte"
fi

# ==============================================================================
# Funktion: detect_and_install_packages
# Zweck: Identifiziert den Paketmanager und installiert Basissoftware
# Parameter: Keine
# Rückgabewert: Statuscode der Installation
# ==============================================================================
detect_and_install_packages() {
    log_info "Starte Paketinstallation"
    local deb_pkgs="zsh git curl wget fastfetch nftables openssh-server fonts-noto-mono fonts-powerline"
    local rpm_pkgs="zsh git curl wget fastfetch nftables openssh-server powerline-fonts"
    local pac_pkgs="zsh git curl wget fastfetch nftables openssh powerline-fonts noto-fonts"

    if command -v apt-get >/dev/null 2>&1; then
        apt-get update -y
        apt-get install -y $deb_pkgs
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y epel-release || true
        dnf install -y $rpm_pkgs
    elif command -v pacman >/dev/null 2>&1; then
        pacman -Sy --noconfirm $pac_pkgs
    else
        log_err "Paketmanager unauffindbar"
    fi
    log_success "Pakete erfolgreich installiert"
}

# ==============================================================================
# Funktion: configure_ssh
# Zweck: Aktiviert und startet den SSH Dienst
# Parameter: Keine
# Rückgabewert: Statuscode des Systemctl Befehls
# ==============================================================================
configure_ssh() {
    log_info "Konfiguriere SSH"
    systemctl enable sshd --now || systemctl enable ssh --now
    log_success "SSH Dienst aktiv"
}

# ==============================================================================
# Funktion: configure_nftables
# Zweck: Erstellt ein grundlegendes Firewall Regelwerk
# Parameter: Keine
# Rückgabewert: Statuscode des Systemctl Befehls
# ==============================================================================
configure_nftables() {
    log_info "Konfiguriere Nftables"
    systemctl stop firewalld >/dev/null 2>&1 || true
    systemctl disable firewalld >/dev/null 2>&1 || true

    cat << 'EOF' > /etc/nftables.conf
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
EOF

    if [[ "$CURRENT_HOST" == "$ROUTER_HOST" ]]; then
        cat << 'EOF' >> /etc/nftables.conf
        ct state established,related accept
        iifname "ens161" accept
        iifname "ens256" accept
    }
}
table ip nat {
    chain postrouting {
        type nat hook postrouting priority 100; policy accept;
        oifname "ens160" masquerade
    }
}
EOF
    else
        cat << 'EOF' >> /etc/nftables.conf
    }
}
EOF
    fi

    systemctl enable nftables --now
    log_success "Nftables Regelwerk angewendet"
}

# ==============================================================================
# Funktion: configure_zsh_and_fastfetch
# Zweck: Richtet Oh My Zsh inklusive Plugins und Theme ein
# Parameter: Keine
# Rückgabewert: Fehlercode bei Fehlschlag der Klonvorgänge
# ==============================================================================
configure_zsh_and_fastfetch() {
    log_info "Konfiguriere ZSH fuer Benutzer $TARGET_USER"
    
    local zsh_path
    zsh_path=$(command -v zsh)
    chsh -s "$zsh_path" "$TARGET_USER"

    local ohmyzsh_dir="$USER_HOME/.oh-my-zsh"
    if [[ ! -d "$ohmyzsh_dir" ]]; then
        sudo -u "$TARGET_USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    local plugin_dir="${ohmyzsh_dir}/custom/plugins"
    sudo -u "$TARGET_USER" mkdir -p "$plugin_dir"

    if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
        sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
    fi

    if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
        sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir/zsh-syntax-highlighting"
    fi

    local zshrc_file="$USER_HOME/.zshrc"
    
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$zshrc_file"
    sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$zshrc_file"

    if ! grep -q "fastfetch" "$zshrc_file"; then
        echo -e "\n# Fastfetch beim Start ausfuehren\nfastfetch" >> "$zshrc_file"
    fi

    chown "$TARGET_USER:$TARGET_USER" "$zshrc_file"
    log_success "ZSH und Fastfetch konfiguriert"
}

# ==============================================================================
# Funktion: reset_network_connections
# Zweck: Loescht alle aktiven und gespeicherten NetworkManager Verbindungen
# Parameter: Keine
# Rueckgabewert: nmcli Befehlsstatus
# ==============================================================================
reset_network_connections() {
    log_info "Bereinige vorhandene Netzwerkverbindungen"
    for conn in $(nmcli -t -f UUID con show); do
        nmcli con delete uuid "$conn" >/dev/null 2>&1 || true
    done
    log_success "Alte Verbindungen entfernt"
}

# ==============================================================================
# Funktion: configure_router
# Zweck: Einrichtung Netzwerkschnittstellen und Forwarding mittels MAC Adressen
# Parameter: Keine
# Rueckgabewert: nmcli Befehlsstatus
# ==============================================================================
configure_router() {
    log_info "Starte Router Netzwerk Konfiguration"
    
    reset_network_connections
    
    nmcli con add type ethernet con-name ens160 ifname ens160 mac "00:0C:29:9E:B3:12" ipv4.method auto ipv4.dns "$DNS_SERVER"
    nmcli con add type ethernet con-name ens161 ifname ens161 mac "00:0C:29:9E:B3:26" ipv4.addresses 172.16.7.33/27 ipv4.method manual
    nmcli con add type ethernet con-name ens256 ifname ens256 mac "00:0C:29:9E:B3:1C" ipv4.addresses 172.16.7.97/27 ipv4.method manual

    nmcli con up ens160
    nmcli con up ens161
    nmcli con up ens256

    sysctl -w net.ipv4.ip_forward=1
    echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-ip-forward.conf
    log_success "Router Netzwerk aktiv"
}
# ==============================================================================
# Funktion: configure_client
# Zweck: Setzt statische IP Adressen anhand des Hostnamens
# Parameter: Keine
# Rückgabewert: nmcli Befehlsstatus
# ==============================================================================
configure_client() {
    local client_ip=""
    local client_gw=""
    
    case "$CURRENT_HOST" in
        "srv-deb-01") client_ip="172.16.7.42/27"; client_gw="172.16.7.33" ;;
        "ws-cachy")   client_ip="172.16.7.47/27"; client_gw="172.16.7.33" ;;
        "srv-deb-02") client_ip="172.16.7.111/27"; client_gw="172.16.7.97" ;;
        "ws-manjaro") client_ip="172.16.7.106/27"; client_gw="172.16.7.97" ;;
        *) log_err "Keine Konfiguration fuer Host $CURRENT_HOST" ;;
    esac

    local interface
    interface=$(ip -br link | grep -v 'lo' | awk '{print $1}' | head -n 1)
    
    nmcli con modify "$interface" ipv4.addresses "$client_ip" ipv4.gateway "$client_gw" ipv4.dns "$DNS_SERVER" ipv4.method manual || nmcli con add type ethernet con-name "$interface" ifname "$interface" ipv4.addresses "$client_ip" ipv4.gateway "$client_gw" ipv4.dns "$DNS_SERVER" ipv4.method manual
        
    nmcli con down "$interface" || true
    nmcli con up "$interface"
    log_success "Client Netzwerk aktiv auf $interface"
}

# ==============================================================================
# Hauptausfuehrung
# ==============================================================================
detect_and_install_packages
configure_ssh
configure_zsh_and_fastfetch

if [[ "$CURRENT_HOST" == "$ROUTER_HOST" ]]; then
    configure_router
else
    configure_client
fi

configure_nftables
