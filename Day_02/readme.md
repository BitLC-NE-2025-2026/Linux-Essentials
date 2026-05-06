

# Oh My Zsh Installation & Konfiguration

Diese Anleitung beschreibt die Einrichtung von Oh My Zsh mit dem Agnoster-Theme, Noto Mono Powerline Fonts und essentiellen Plugins.

## 1. Installation von Oh My Zsh
Führen Sie den folgenden Befehl aus, um das Framework über das offizielle Repository zu installieren:

```bash
# Ruft das Installationsskript via wget ab und fuehrt es direkt in der Shell aus
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 2. Powerline Fonts & Glyphen
Das Agnoster-Theme benötigt spezielle Schriftarten für die Darstellung der Pfeilsymbole.

```bash
# Installation der Noto Fonts und der Powerline-Erweiterungen unter Debian/Ubuntu basierten Systemen
sudo apt update && sudo apt install fonts-noto fonts-powerline -y
```

> [!IMPORTANT]
> Stellen Sie in Ihren Terminal-Einstellungen (z. B. VS Code, iTerm2 oder GNOME Terminal) die Schriftart explizit auf **"Noto Mono Powerline"** um.

## 3. Plugins installieren
Zusätzliche Funktionalitäten wie automatische Vorschläge und Syntax-Hervorhebung werden in das Custom-Verzeichnis geklont.

```bash
# Klonen des Plugins fuer automatische Befehlsvorschlaege basierend auf der Historie
git clone https://github.com/zsh-users/zsh-autosuggestionshttps://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Klonen des Plugins zur farblichen Validierung von Shell-Befehlen waehrend der Eingabe
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

## 4. Konfiguration der .zshrc
Öffnen Sie die Konfigurationsdatei mit einem Editor Ihrer Wahl (z. B. `nano ~/.zshrc`) und passen Sie die folgenden Zeilen an:

| Variable | Wert | Beschreibung |
| :--- | :--- | :--- |
| `ZSH_THEME` | `"agnoster"` | Aktiviert das Powerline-basierte Theme |
| `plugins` | `(git zsh-autosuggestions zsh-syntax-highlighting)` | Liste der zu ladenden Erweiterungen |

### Code-Beispiel Konfiguration
```bash
# Setzt das visuelle Erscheinungsbild der Shell auf das Agnoster-Design
ZSH_THEME="agnoster"

# Definiert ein Array der Plugins die beim Starten der Shell-Sitzung geladen werden sollen
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
```

## 5. Änderungen anwenden
Damit die Konfiguration ohne Neustart des Terminals aktiv wird:

```bash
# Liest die .zshrc Datei neu ein und uebernimmt alle geaenderten Parameter in die aktuelle Sitzung
source ~/.zshrc
```

**Mögliche nächste Schritte oder verwandte Themen:**
* Installation von "lsd" oder "exa" für Icons in der Dateiliste
* Einrichtung von "Zsh-Completions" für verbesserte Tab-Vervollständigung
* Anpassung der Prompt-Elemente (Username/Hostname ausblenden)
