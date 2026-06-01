import os
import sys
import argparse
import re
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

# Base background canvas color
DARK_BG = (9, 11, 20)          # Rich tech black-blue

# Categories and their color coding and names
CATEGORIES = {
    "BASICS": {
        "name": "GRUNDLAGEN & FHS",
        "tag": "BASIC ARCHITECTURE",
        "start_color": (16, 185, 129),  # Emerald
        "end_color": (4, 120, 87),      # Dark Emerald
        "accent": (52, 211, 153),       # Mint Accent
    },
    "TEXT": {
        "name": "TEXTMANIPULATION & EDITOREN",
        "tag": "TEXT & REGEX FILTERING",
        "start_color": (244, 63, 94),   # Rose
        "end_color": (159, 18, 57),     # Deep Red Rose
        "accent": (251, 113, 133),      # Pink Accent
    },
    "SECURITY": {
        "name": "BERECHTIGUNGEN & HARDENING",
        "tag": "SYSTEM SECURITY",
        "start_color": (245, 158, 11),  # Amber
        "end_color": (180, 83, 9),      # Deep Orange
        "accent": (253, 186, 116),      # Amber Accent
    },
    "SCRIPTING": {
        "name": "SHELL-SCRIPTING & TUIS",
        "tag": "AUTOMATION & BASH",
        "start_color": (99, 102, 241),  # Indigo
        "end_color": (67, 56, 202),     # Dark Indigo
        "accent": (165, 180, 252),      # Lavender Accent
    },
    "SYSADMIN": {
        "name": "SYSTEMADMINISTRATION",
        "tag": "ADMIN & SERVICES",
        "start_color": (168, 85, 247),  # Purple
        "end_color": (109, 40, 217),    # Deep Violet
        "accent": (216, 180, 254),      # Orchid Accent
    },
    "NETWORK": {
        "name": "NETZWERK & INFASTRUKTUR",
        "tag": "ROUTING & FIREWALL",
        "start_color": (6, 182, 212),   # Cyan
        "end_color": (13, 148, 136),    # Teal
        "accent": (103, 232, 249),      # Light Cyan Accent
    },
    "GENERIC": {
        "name": "LINUX ADVANCED",
        "tag": "ADVANCED ADMINISTRATION",
        "start_color": (59, 130, 246),  # Blue
        "end_color": (29, 78, 216),     # Dark Blue
        "accent": (147, 197, 253),      # Light Blue Accent
    }
}

DAY_THEMES = {
    1: ("Einführung & Installation", "Linux-Grundlagen, Bootprozess & erste Schritte", "BASICS"),
    2: ("Die Linux-Philosophie & FHS", "Dateisystem-Hierarchie-Standard & Shell-Grundlagen", "BASICS"),
    3: ("Navigation & Dateiverwaltung", "Verzeichnisse, Verknüpfungen & Dateioperationen", "BASICS"),
    4: ("Textmanipulation & Filter", "grep, sed, awk, Pipes & Redirects", "TEXT"),
    5: ("Berechtigungen & Eigentümer", "chmod, chown, umask & erweiterte Attribute", "SECURITY"),
    6: ("Prozessmanagement & Spezialrechte", "ps, top, Job Control, SUID, SGID & Sticky Bit", "SECURITY"),
    7: ("Archivierung & Software-Builds", "tar, gzip, bzip2, xz, Make & Shared Libraries", "SYSADMIN"),
    8: ("Shell Scripting & Automatisierung", "Bash-Variablen, Kontrollstrukturen & Parameter", "SCRIPTING"),
    9: ("Reguläre Ausdrücke (Regex)", "Suchen und Filtern mit grep, sed & awk", "TEXT"),
    10: ("System-Monitoring & Logs", "Echtzeitanalyse, Systemd-Journal & Log-Dateien", "SYSADMIN"),
    11: ("Der Texteditor vi/vim", "Modi, Navigation, Suchen & Konfiguration", "TEXT"),
    12: ("Fortgeschrittene Paketverwaltung", "dnf, apt, rpm, dpkg & Repositories", "SYSADMIN"),
    13: ("Benutzerverwaltung & TUI-Erstellung", "useradd, chpasswd, whiptail & Druckersteuerung", "SCRIPTING"),
    14: ("Netzwerk-Grundlagen & Schnittstellen", "IPv4, Subnetze, MAC-Adressen & nmcli", "NETWORK"),
    15: ("VLAN-Konfiguration & Automatisierung", "VLAN Tagging, IP-Bereiche & nmcli-Skripte", "NETWORK"),
    16: ("Netzwerk-Routing & Forwarding", "NAT-Masquerading, IP-Forwarding & nftables", "NETWORK"),
    17: ("Firewall & Netzwerksicherheit", "nftables-Regeln, Port-Sperrung & Härtung", "SECURITY"),
}

def determine_category(day_num, title):
    """Determine category based on Day number or Title keywords."""
    # Check if Day has predefined category
    if day_num in DAY_THEMES:
        return DAY_THEMES[day_num][2]
        
    t = title.lower()
    if any(k in t for k in ["netzwerk", "network", "route", "vlan", "ip", "dns", "gateway", "dhcp"]):
        return "NETWORK"
    if any(k in t for k in ["sicherheit", "security", "firewall", "nftables", "rechte", "chmod", "crypt", "ssh", "härtung"]):
        return "SECURITY"
    if any(k in t for k in ["script", "skript", "bash", "automatisierung", "whiptail", "tui", "python"]):
        return "SCRIPTING"
    if any(k in t for k in ["grep", "sed", "awk", "regex", "vi", "vim", "text", "filter"]):
        return "TEXT"
    if any(k in t for k in ["paket", "install", "dnf", "apt", "pacman", "service", "systemd", "log", "prozess", "process", "tar", "backup"]):
        return "SYSADMIN"
    if any(k in t for k in ["einführung", "fhs", "filesystem", "philosophie", "basis", "navigation", "ls"]):
        return "BASICS"
        
    # Fallback by Day ranges
    if day_num <= 3:
        return "BASICS"
    elif day_num in [4, 9, 11]:
        return "TEXT"
    elif day_num in [5, 6, 17]:
        return "SECURITY"
    elif day_num in [8, 13]:
        return "SCRIPTING"
    elif day_num in [7, 10, 12]:
        return "SYSADMIN"
    elif day_num in [14, 15, 16]:
        return "NETWORK"
    return "GENERIC"

def get_font(font_name, size):
    """Try to load system fonts, fallback to default."""
    font_paths = []
    if sys.platform.startswith("win"):
        win_fonts = "C:\\Windows\\Fonts"
        font_paths = [
            os.path.join(win_fonts, f"{font_name}.ttf"),
            os.path.join(win_fonts, f"{font_name.lower()}.ttf"),
            os.path.join(win_fonts, "arial.ttf")
        ]
    for path in font_paths:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                continue
    return ImageFont.load_default()

def draw_cyber_grid(draw, width, height, spacing=60):
    """Draw high-tech grid with nodes."""
    grid_color = (255, 255, 255, 6) # Low opacity grid
    for x in range(0, width, spacing):
        draw.line([(x, 0), (x, height)], fill=grid_color, width=1)
    for y in range(0, height, spacing):
        draw.line([(0, y), (width, y)], fill=grid_color, width=1)
        
    # Draw mini dots at intersections
    for x in range(spacing, width, spacing * 2):
        for y in range(spacing, height, spacing * 2):
            draw.ellipse((x-1, y-1, x+1, y+1), fill=(255, 255, 255, 15))

def draw_category_graphics(draw, category, x_base, y_base):
    """Draw premium category-specific vector artwork in the right corner."""
    draw_color = (255, 255, 255, 25) # Soft white vector color
    
    if category == "NETWORK":
        # Draw Network Node Topology
        nodes = [(x_base + 80, y_base + 30), (x_base + 30, y_base + 90), (x_base + 130, y_base + 90), 
                 (x_base + 30, y_base + 160), (x_base + 80, y_base + 160), (x_base + 130, y_base + 160)]
        # Connections
        draw.line([nodes[0], nodes[1]], fill=draw_color, width=2)
        draw.line([nodes[0], nodes[2]], fill=draw_color, width=2)
        draw.line([nodes[1], nodes[3]], fill=draw_color, width=2)
        draw.line([nodes[1], nodes[4]], fill=draw_color, width=2)
        draw.line([nodes[2], nodes[5]], fill=draw_color, width=2)
        
        # Nodes circles
        for n in nodes:
            draw.ellipse((n[0]-10, n[1]-10, n[0]+10, n[1]+10), fill=(9, 11, 20), outline=draw_color, width=2)
        draw.ellipse((nodes[0][0]-5, nodes[0][1]-5, nodes[0][0]+5, nodes[0][1]+5), fill=(6, 182, 212, 100))
        
    elif category == "SECURITY":
        # Draw Padlock/Shield outline
        draw.rectangle((x_base + 40, y_base + 80, x_base + 120, y_base + 150), fill=None, outline=draw_color, width=3)
        draw.arc((x_base + 55, y_base + 40, x_base + 105, y_base + 90), start=180, end=0, fill=draw_color, width=3)
        draw.ellipse((x_base + 75, y_base + 105, x_base + 85, y_base + 115), fill=draw_color)
        draw.line([(x_base + 80, y_base + 115), (x_base + 80, y_base + 130)], fill=draw_color, width=3)
        
    elif category == "SCRIPTING":
        # Draw Terminal Window
        draw.rounded_rectangle([(x_base + 20, y_base + 40), (x_base + 140, y_base + 140)], radius=8, fill=None, outline=draw_color, width=2)
        draw.line([(x_base + 20, y_base + 65), (x_base + 140, y_base + 65)], fill=draw_color, width=2)
        # Terminal Prompts
        draw.line([(x_base + 35, y_base + 85), (x_base + 45, y_base + 95)], fill=draw_color, width=2)
        draw.line([(x_base + 45, y_base + 95), (x_base + 35, y_base + 105)], fill=draw_color, width=2)
        draw.line([(x_base + 55, y_base + 103), (x_base + 75, y_base + 103)], fill=draw_color, width=2)
        # Windows dots
        draw.ellipse((x_base + 35, y_base + 50, x_base + 41, y_base + 56), fill=draw_color)
        draw.ellipse((x_base + 47, y_base + 50, x_base + 53, y_base + 56), fill=draw_color)
        draw.ellipse((x_base + 59, y_base + 50, x_base + 65, y_base + 56), fill=draw_color)
        
    elif category == "TEXT":
        # Draw Text / Edit document lines
        draw.rounded_rectangle([(x_base + 30, y_base + 30), (x_base + 130, y_base + 150)], radius=4, fill=None, outline=draw_color, width=2)
        # Lines in document
        draw.line([(x_base + 45, y_base + 55), (x_base + 115, y_base + 55)], fill=draw_color, width=2)
        draw.line([(x_base + 45, y_base + 75), (x_base + 115, y_base + 75)], fill=draw_color, width=2)
        draw.line([(x_base + 45, y_base + 95), (x_base + 95, y_base + 95)], fill=draw_color, width=2)
        draw.line([(x_base + 45, y_base + 115), (x_base + 105, y_base + 115)], fill=draw_color, width=2)
        
    elif category == "SYSADMIN":
        # Draw stack servers
        for offset in [40, 80, 120]:
            draw.rounded_rectangle([(x_base + 20, y_base + offset), (x_base + 140, y_base + offset + 25)], radius=3, fill=None, outline=draw_color, width=2)
            # Status dots
            draw.ellipse((x_base + 30, y_base + offset + 10, x_base + 36, y_base + offset + 16), fill=(16, 185, 129, 200))
            draw.ellipse((x_base + 42, y_base + offset + 10, x_base + 48, y_base + offset + 16), fill=draw_color)
            
    else: # BASICS or GENERIC
        # Draw Gear/Engine
        cx, cy = x_base + 80, y_base + 90
        draw.ellipse((cx-30, cy-30, cx+30, cy+30), fill=None, outline=draw_color, width=3)
        draw.ellipse((cx-10, cy-10, cx+10, cy+10), fill=None, outline=draw_color, width=2)
        for angle in range(0, 360, 45):
            rad = math.radians(angle)
            x1 = cx + 25 * math.cos(rad)
            y1 = cy + 25 * math.sin(rad)
            x2 = cx + 42 * math.cos(rad)
            y2 = cy + 42 * math.sin(rad)
            draw.line([(x1, y1), (x2, y2)], fill=draw_color, width=4)

def generate_header(day_num, title, subtitle, output_path):
    width, height = 1200, 500
    
    # Determine the category
    category_key = determine_category(day_num, title)
    cat = CATEGORIES[category_key]
    
    # Create RGBA Image Canvas
    image = Image.new("RGBA", (width, height), DARK_BG + (255,))
    
    # Organic Ambient glows matching category coding
    glow_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_layer)
    
    # Left organic glow (primary category color)
    glow_draw.ellipse((-150, -100, 450, 550), fill=cat["start_color"] + (40,))
    # Right organic glow (shifting purple or accent category color)
    glow_draw.ellipse((750, -50, 1350, 550), fill=cat["end_color"] + (40,))
    # Ambient fill
    glow_draw.ellipse((350, 250, 850, 650), fill=cat["start_color"] + (25,))
    
    # Apply deep blur to simulate premium aurora glow
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(130))
    image = Image.alpha_composite(image, glow_layer)
    
    # Draw technology grid
    grid_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    grid_draw = ImageDraw.Draw(grid_layer)
    draw_cyber_grid(grid_draw, width, height, spacing=60)
    image = Image.alpha_composite(image, grid_layer)
    
    # Draw Content
    draw = ImageDraw.Draw(image)
    
    # Left vertical colored border bar (Category Colored)
    accent_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    accent_draw = ImageDraw.Draw(accent_layer)
    accent_draw.rectangle((20, 40, 26, height - 40), fill=cat["start_color"] + (230,))
    accent_draw.ellipse((17, 30, 29, 42), fill=cat["accent"] + (255,))
    accent_draw.ellipse((17, height - 42, 29, height - 30), fill=cat["end_color"] + (255,))
    image = Image.alpha_composite(image, accent_layer)
    
    # Setup fonts
    title_font = get_font("segoeuib", 54)      # Bold
    subtitle_font = get_font("segoeui", 26)     # Regular
    badge_font = get_font("consolab", 20)       # Consolas Bold
    category_font = get_font("segoeuib", 18)    # Bold Category
    series_font = get_font("segoeui", 16)      # Regular Series
    
    # Category Tag Pill (Top)
    badge_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    badge_draw = ImageDraw.Draw(badge_layer)
    
    # Draw "DAY XX" glassmorphic pill
    day_text = f"DAY {day_num:02d}"
    badge_draw.rounded_rectangle(
        [(60, 80), (180, 120)],
        radius=6,
        fill=(15, 23, 42, 195),
        outline=cat["accent"] + (180,),
        width=2
    )
    badge_draw.text((82, 89), day_text, fill=cat["accent"], font=badge_font)
    
    # Draw Category Tag Pill (e.g. "NETZWERK & INFASTRUKTUR")
    cat_text = cat["name"]
    # Estimate width
    cat_w = len(cat_text) * 11 + 25
    badge_draw.rounded_rectangle(
        [(200, 80), (200 + cat_w, 120)],
        radius=6,
        fill=cat["start_color"] + (35,),
        outline=cat["start_color"] + (150,),
        width=1
    )
    badge_draw.text((212, 90), cat_text, fill=cat["accent"], font=category_font)
    
    # Draw Sub category focus
    draw.text((60, 140), f"LINUX ESSENTIALS MASTERCLASS  //  {cat['tag']}", fill=(130, 145, 165), font=series_font)
    
    image = Image.alpha_composite(image, badge_layer)
    
    # Draw Main Title (Topic of the day)
    # Split text intelligently to fit well
    words = title.split()
    lines = []
    current_line = []
    for word in words:
        current_line.append(word)
        test_line = " ".join(current_line)
        if len(test_line) * 26 > 850:
            current_line.pop()
            lines.append(" ".join(current_line))
            current_line = [word]
    if current_line:
        lines.append(" ".join(current_line))
        
    title_y = 195
    for line in lines[:2]:  # Maximum 2 lines of title
        # Subtle glowing drop shadow for titles
        draw.text((62, title_y + 2), line, fill=(9, 11, 20, 180), font=title_font)
        draw.text((60, title_y), line, fill=(255, 255, 255), font=title_font)
        title_y += 72
        
    # Draw Subtitle
    draw.text((60, 370), subtitle, fill=cat["accent"], font=subtitle_font)
    
    # Draw Technical Vector Artwork based on Category in right-bottom corner
    art_layer = Image.new("RGBA", (width, height), (0, 0, 0, 0))
    art_draw = ImageDraw.Draw(art_layer)
    draw_category_graphics(art_draw, category_key, 950, 240)
    
    # Top-right tiny hardware design
    art_draw.rounded_rectangle([(970, 70), (1140, 170)], radius=8, fill=(15, 23, 42, 110), outline=cat["accent"] + (40,), width=1)
    art_draw.text((985, 85), "SYSTEM STATUS", fill=(130, 145, 165, 200), font=series_font)
    # Drawing tiny graphical signal bars
    art_draw.rectangle((985, 125, 995, 145), fill=cat["start_color"] + (180,))
    art_draw.rectangle((1000, 115, 1010, 145), fill=cat["start_color"] + (180,))
    art_draw.rectangle((1015, 105, 1025, 145), fill=cat["accent"] + (180,))
    art_draw.rectangle((1030, 130, 1040, 145), fill=(255, 255, 255, 30))
    
    art_draw.text((1055, 118), f"CAT: {category_key[:6]}", fill=cat["accent"], font=badge_font)
    
    image = Image.alpha_composite(image, art_layer)
    
    # Convert RGBA to RGB for saving as high-quality PNG
    final_image = image.convert("RGB")
    final_image.save(output_path, "PNG")
    print(f"Generated beautifully coded header for Category {category_key} [Day {day_num:02d}]: {output_path}")

def parse_readme_title(day_dir):
    readme_path = os.path.join(day_dir, "README.md")
    if not os.path.exists(readme_path):
        return None
    
    try:
        with open(readme_path, "r", encoding="utf-8") as f:
            for _ in range(10): # Read first 10 lines
                line = f.readline()
                if not line:
                    break
                if line.startswith("#"):
                    clean = re.sub(r'^#\s*[\U00010000-\U0010ffff\u2600-\u27ff]\s*', '', line).strip()
                    clean = re.sub(r'^#\s*', '', clean).strip()
                    match = re.search(r'Linux Essentials\s*-\s*(Tag|Day)\s*(\d+)(.*)', clean, re.IGNORECASE)
                    if not match:
                        match = re.search(r'Linux Essentials\s*(Tag|Day)\s*(\d+)(.*)', clean, re.IGNORECASE)
                    
                    if match:
                        theme = match.group(3).strip()
                        if theme.startswith(":") or theme.startswith("-"):
                            theme = theme[1:].strip()
                        return theme
    except Exception as e:
        print(f"Error reading {readme_path}: {e}")
    return None

def main():
    parser = argparse.ArgumentParser(description="Futuristic Category-coded Header Banner Generator for Linux Essentials")
    parser.add_argument("--day", type=int, help="Day number")
    parser.add_argument("--title", type=str, help="Main title text")
    parser.add_argument("--subtitle", type=str, help="Subtitle text")
    parser.add_argument("--output", type=str, help="Output file path")
    parser.add_argument("--all", action="store_true", help="Generate all headers with category color coding")
    
    args = parser.parse_args()
    base_dir = os.path.dirname(os.path.abspath(__file__))
    
    if args.all:
        print("Starting unified category-coded beautiful headers build...")
        for item in sorted(os.listdir(base_dir)):
            match = re.match(r'^Day_(\d+)$', item)
            if match:
                day_num = int(match.group(1))
                day_dir = os.path.join(base_dir, item)
                
                parsed_title = parse_readme_title(day_dir)
                default_title, default_subtitle, _ = DAY_THEMES.get(day_num, (f"Tag {day_num:02d}", "Fortgeschrittene Linux-Themen", "GENERIC"))
                
                title = parsed_title if (parsed_title and len(parsed_title) > 2) else default_title
                if "Day_" in title or "Tag " in title:
                    title = default_title
                    
                subtitle = default_subtitle
                
                # Write inside the day folder
                day_header_path = os.path.join(day_dir, "header.png")
                generate_header(day_num, title, subtitle, day_header_path)
                
                # Write in the root directory
                root_header_path = os.path.join(base_dir, f"Day_{day_num:02d}_header.png")
                generate_header(day_num, title, subtitle, root_header_path)
        print("Unified category-coded beautiful headers generated successfully!")
    elif args.day and args.title and args.output:
        subtitle = args.subtitle if args.subtitle else "Linux Essentials Training"
        generate_header(args.day, args.title, subtitle, args.output)
    else:
        # Default Day 16 build
        day_num = 16
        theme = DAY_THEMES[day_num]
        
        day_dir = os.path.join(base_dir, f"Day_{day_num:02d}")
        if not os.path.exists(day_dir):
            os.makedirs(day_dir)
            
        generate_header(day_num, theme[0], theme[1], os.path.join(day_dir, "header.png"))
        generate_header(day_num, theme[0], theme[1], os.path.join(base_dir, f"Day_{day_num:02d}_header.png"))

if __name__ == "__main__":
    main()
