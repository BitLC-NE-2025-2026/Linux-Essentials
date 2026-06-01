#!/usr/bin/env bash
# ==============================================================================
# MNBTUI Module: tools_installer.sh
# Zweck: Uniformer Tools-Installer, Custom ZSH, Fastfetch & Custom Aliases
# ==============================================================================

set -euo pipefail

log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[ERFOLG]\e[0m $1"; }
log_err() { echo -e "\e[31m[FEHLER]\e[0m $1"; exit 1; }

# Lade Konfiguration
CONFIG_PATH="$(dirname "$0")/../config.yaml"
PARSER="$(dirname "$0")/parse_config.py"

TARGET_USER=${SUDO_USER:-root}
USER_HOME=$(eval echo "~$TARGET_USER")

whiptail --title "Zusätzliche Tools & Uniformität" --infobox "Installiere nützliche Tools (btop, ncdu, micro, zsh, fastfetch)..." 8 60

# 1. Uniforme Paket-Installation
if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y >/dev/null
    sudo apt-get install -y zsh git curl wget fastfetch btop ncdu micro >/dev/null
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y epel-release >/dev/null || true
    sudo dnf install -y zsh git curl wget fastfetch btop ncdu micro >/dev/null
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm zsh git curl wget fastfetch btop ncdu micro >/dev/null
fi

log_success "Zusätzliche Tools installiert."

# 2. Oh My Zsh Konfiguration
whiptail --title "ZSH Konfiguration" --infobox "Richte ZSH & Oh My Zsh für Benutzer $TARGET_USER ein..." 8 60

# Default Shell auf ZSH ändern
zsh_path=$(command -v zsh)
sudo chsh -s "$zsh_path" "$TARGET_USER"

ohmyzsh_dir="$USER_HOME/.oh-my-zsh"
if [[ ! -d "$ohmyzsh_dir" ]]; then
    sudo -u "$TARGET_USER" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null || true
fi

# Plugins herunterladen
plugin_dir="${ohmyzsh_dir}/custom/plugins"
sudo -u "$TARGET_USER" mkdir -p "$plugin_dir"

if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
    sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions" >/dev/null 2>&1 || true
fi

if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
    sudo -u "$TARGET_USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir/zsh-syntax-highlighting" >/dev/null 2>&1 || true
fi

# .zshrc Konfiguration schreiben
zshrc_file="$USER_HOME/.zshrc"
if [[ -f "$zshrc_file" ]]; then
    sudo -u "$TARGET_USER" sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$zshrc_file"
    sudo -u "$TARGET_USER" sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$zshrc_file"
    
    # Custom Aliases anfügen falls nicht vorhanden
    if ! grep -q "### MNBTUI ADMIN ALIASES" "$zshrc_file"; then
        cat << 'EOF' | sudo -u "$TARGET_USER" tee -a "$zshrc_file" >/dev/null

### MNBTUI ADMIN ALIASES ###
alias ipbrief="ip -br -4 a"
alias fwlist="sudo nft list ruleset"
alias ports="sudo ss -tulpen"
alias dnsbench="bash $(dirname "$0")/dns_selector.sh"
# Fastfetch beim Login
fastfetch --logo os
EOF
    fi
fi

whiptail --title "Installation abgeschlossen" --msgbox "Die zusätzlichen Tools, ZSH und Custom Aliases wurden erfolgreich für den Benutzer $TARGET_USER eingerichtet!\n\nVerfügbare Aliases:\n- ipbrief\n- fwlist\n- ports\n- dnsbench" 14 60
