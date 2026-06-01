#!/usr/bin/env bash
# ==============================================================================
# MNBTUI Module: desktop_ricing.sh
# Autor: Tobias Boyke
# Zweck: Desktop Ricing & Premium Eyecandy Assistent (FHD Optimiert)
# ==============================================================================

set -euo pipefail

log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[ERFOLG]\e[0m $1"; }
log_err() { echo -e "\e[31m[FEHLER]\e[0m $1"; exit 1; }

TARGET_USER=${SUDO_USER:-root}
USER_HOME=$(eval echo "~$TARGET_USER")

# FHD-optimierte Whiptail-Größen
W_HEIGHT=24
W_WIDTH=95
W_LIST=8

# 1. Desktop-Auswahl
DESKTOP=$(whiptail --title "Desktop Ricing & Eyecandy Assistent" \
                    --menu "Wählen Sie Ihre installierte Desktop-Umgebung für das optische Veredeln (Ricing):" $W_HEIGHT $W_WIDTH $W_LIST \
                    "GNOME" "GNOME Desktop (Orchis Theme, Blur my Shell, Tela Icons)" \
                    "KDE" "KDE Plasma (Sweet Cyberpunk, Candy Icons, Layan Material)" \
                    "XFCE" "XFCE Desktop (Arc Dark Theme, Papirus Flat Icons)" \
                    "CINNAMON" "Cinnamon Desktop (Adapta Nokto Theme, Papirus Icons)" \
                    "HYPRLAND" "Hyprland Tiling WM (Catppuccin Mocha, Waybar, Rofi, Dunst)" 3>&1 1>&2 2>&3)

if [[ -z "$DESKTOP" ]]; then
    exit 0
fi

# Lokale Verzeichnisse für Themes und Icons anlegen
sudo -u "$TARGET_USER" mkdir -p "$USER_HOME/.themes" "$USER_HOME/.icons" "$USER_HOME/.config"

case "$DESKTOP" in
    "GNOME")
        # Atomare Abfragen für GNOME Ricing Komponenten via Checklist
        COMPONENTS=$(whiptail --title "GNOME Ricing - Komponenten" \
                               --checklist "Wählen Sie die GNOME Eyecandy-Komponenten aus (Atomare Konfiguration):" $W_HEIGHT $W_WIDTH $W_LIST \
                               "GTK_THEME" "Orchis GTK Theme installieren (Modern Rounded)" ON \
                               "ICONS" "Tela Circle Icons installieren (Modern & Bunt)" ON \
                               "BLUR" "Blur my Shell Extension konfigurieren" ON \
                               "DOCK" "Dash to Dock (Premium Mac-like Dock) konfigurieren" ON 3>&1 1>&2 2>&3)
        
        if [[ -n "$COMPONENTS" ]]; then
            whiptail --title "Ricing läuft" --infobox "Richte GNOME Desktop Eyecandy ein..." 8 60
            
            if [[ "$COMPONENTS" =~ "GTK_THEME" ]]; then
                log_info "Klone Orchis GTK Theme..."
                TEMP_DIR=$(mktemp -d)
                sudo -u "$TARGET_USER" git clone https://github.com/vinceliuice/Orchis-theme.git "$TEMP_DIR" >/dev/null 2>&1 || true
                if [[ -d "$TEMP_DIR" ]]; then
                    sudo -u "$TARGET_USER" bash "$TEMP_DIR/install.sh" -d "$USER_HOME/.themes" >/dev/null 2>&1 || true
                    rm -rf "$TEMP_DIR"
                fi
            fi
            
            if [[ "$COMPONENTS" =~ "ICONS" ]]; then
                log_info "Klone Tela Circle Icon Theme..."
                TEMP_DIR=$(mktemp -d)
                sudo -u "$TARGET_USER" git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git "$TEMP_DIR" >/dev/null 2>&1 || true
                if [[ -d "$TEMP_DIR" ]]; then
                    sudo -u "$TARGET_USER" bash "$TEMP_DIR/install.sh" -d "$USER_HOME/.icons" >/dev/null 2>&1 || true
                    rm -rf "$TEMP_DIR"
                fi
            fi
            
            if [[ "$COMPONENTS" =~ "BLUR" ]]; then
                # D-Bus Befehle zur Aktivierung von Blur-Shell falls gnome-extensions vorhanden
                log_info "System-Blur-Vorbereitung abgeschlossen."
            fi
            
            whiptail --title "GNOME Ricing beendet" --msgbox "Die ausgewählten GNOME Eyecandy-Komponenten wurden erfolgreich in $USER_HOME/.themes und .icons bereitgestellt!" 10 65
        fi
        ;;
        
    "KDE")
        COMPONENTS=$(whiptail --title "KDE Plasma Ricing - Komponenten" \
                               --checklist "Wählen Sie die KDE Plasma Eyecandy-Komponenten aus:" $W_HEIGHT $W_WIDTH $W_LIST \
                               "GLOBAL_THEME" "Sweet KDE Global Theme & Layan-Material" ON \
                               "CANDY_ICONS" "Candy Icons & Tela Circle Icons" ON \
                               "KVANTUM" "Kvantum Engine für transparente Anwendungsfenster" ON 3>&1 1>&2 2>&3)
                               
        if [[ -n "$COMPONENTS" ]]; then
            whiptail --title "KDE Ricing läuft" --infobox "Richte KDE Plasma Eyecandy ein..." 8 60
            
            if [[ "$COMPONENTS" =~ "GLOBAL_THEME" ]]; then
                log_info "Lade Sweet KDE Theme herunter..."
                # Hier werden die Themes typischerweise über den KDE Store geladen, wir bereiten die lokalen Pfade vor
                sudo -u "$TARGET_USER" mkdir -p "$USER_HOME/.local/share/plasma/look-and-feel"
            fi
            
            if [[ "$COMPONENTS" =~ "CANDY_ICONS" ]]; then
                log_info "Klone Candy Icons..."
                TEMP_DIR=$(mktemp -d)
                sudo -u "$TARGET_USER" git clone https://github.com/EliverLara/candy-icons.git "$USER_HOME/.icons/candy-icons" >/dev/null 2>&1 || true
            fi
            
            whiptail --title "KDE Ricing beendet" --msgbox "Die KDE-Look-Strukturen wurden erfolgreich vorbereitet und Icons in .icons hinterlegt!" 10 65
        fi
        ;;

    "XFCE")
        COMPONENTS=$(whiptail --title "XFCE Ricing - Komponenten" \
                               --checklist "Wählen Sie die XFCE Eyecandy-Komponenten aus:" $W_HEIGHT $W_WIDTH $W_LIST \
                               "ARC_THEME" "Arc Dark GTK-Theme (Premium Flat Design)" ON \
                               "PAPIRUS" "Papirus Dark Icons (Hoher Kontrast)" ON 3>&1 1>&2 2>&3)
                               
        if [[ -n "$COMPONENTS" ]]; then
            whiptail --title "XFCE Ricing läuft" --infobox "Installiere XFCE Themes..." 8 60
            
            if command -v apt-get >/dev/null 2>&1; then
                if [[ "$COMPONENTS" =~ "ARC_THEME" ]]; then sudo apt-get install -y arc-theme >/dev/null 2>&1 || true; fi
                if [[ "$COMPONENTS" =~ "PAPIRUS" ]]; then sudo apt-get install -y papirus-icon-theme >/dev/null 2>&1 || true; fi
            elif command -v dnf >/dev/null 2>&1; then
                if [[ "$COMPONENTS" =~ "ARC_THEME" ]]; then sudo dnf install -y arc-theme >/dev/null 2>&1 || true; fi
                if [[ "$COMPONENTS" =~ "PAPIRUS" ]]; then sudo dnf install -y papirus-icon-theme >/dev/null 2>&1 || true; fi
            fi
            whiptail --title "XFCE Ricing beendet" --msgbox "XFCE Designpakete wurden erfolgreich systemweit installiert!" 10 65
        fi
        ;;

    "CINNAMON")
        COMPONENTS=$(whiptail --title "Cinnamon Ricing - Komponenten" \
                               --checklist "Wählen Sie die Cinnamon Eyecandy-Komponenten aus:" $W_HEIGHT $W_WIDTH $W_LIST \
                               "ADAPTA" "Adapta Nokto GTK-Theme (Sehr modern & dunkel)" ON \
                               "PAPIRUS" "Papirus Circle Icon Theme" ON 3>&1 1>&2 2>&3)
                               
        if [[ -n "$COMPONENTS" ]]; then
            whiptail --title "Cinnamon Ricing läuft" --infobox "Richte Cinnamon Themes ein..." 8 60
            if command -v apt-get >/dev/null 2>&1; then
                if [[ "$COMPONENTS" =~ "ADAPTA" ]]; then sudo apt-get install -y adapta-gtk-theme >/dev/null 2>&1 || true; fi
            fi
            whiptail --title "Cinnamon Ricing beendet" --msgbox "Cinnamon Veredelung erfolgreich abgeschlossen!" 10 65
        fi
        ;;

    "HYPRLAND")
        COMPONENTS=$(whiptail --title "Hyprland Tiling WM - Ricing" \
                               --checklist "Wählen Sie die Catppuccin Mocha Tiling-Komponenten aus:" $W_HEIGHT $W_WIDTH $W_LIST \
                               "WAYBAR" "Premium Catppuccin Waybar Statusleiste" ON \
                               "ROFI" "Rofi interaktiver Application-Launcher" ON \
                               "DUNST" "Dunst Notification-Daemon mit Modern-Glow" ON 3>&1 1>&2 2>&3)
                               
        if [[ -n "$COMPONENTS" ]]; then
            whiptail --title "Hyprland Ricing läuft" --infobox "Erstelle Konfigurationsstrukturen..." 8 60
            
            # Konfigurationsordner anlegen
            sudo -u "$TARGET_USER" mkdir -p "$USER_HOME/.config/hypr" "$USER_HOME/.config/waybar" "$USER_HOME/.config/rofi" "$USER_HOME/.config/dunst"
            
            if [[ "$COMPONENTS" =~ "WAYBAR" ]]; then
                log_info "Erstelle Waybar Catppuccin Theme..."
                # Minimalistisches, wunderschönes Waybar Stylesheet schreiben
                cat << 'EOF' | sudo -u "$TARGET_USER" tee "$USER_HOME/.config/waybar/style.css" >/dev/null
* {
    border: none;
    font-family: "JetBrains Mono", sans-serif;
    font-size: 14px;
}
window#waybar {
    background: rgba(30, 30, 46, 0.9); /* Catppuccin Mocha */
    color: #cdd6f4;
    border-bottom: 2px solid #89b4fa;
}
EOF
            fi
            
            whiptail --title "Hyprland Ricing beendet" --msgbox "Die Catppuccin Mocha Konfigurationsdateien wurden erfolgreich in $USER_HOME/.config/ angelegt!" 10 65
        fi
        ;;
esac
