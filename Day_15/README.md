# 🐧 Linux Essentials - Day_15

Status: ⏳ In Planung


# Netzwerk-Konfiguration: VLAN-Automatisierung

Diese Tabelle dient als zentrale Datenquelle für das geplante Automatisierungsskript zur Netzwerkkonfiguration.

| Hostname | OS | Interface Name | IP-Adresse | Subnetzmaske | Gateway | DNS-Server | MAC-Adresse | VLAN ID | VMWare LAN Segments |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `gw-router` | Gateway | N/A | 172.21.0.9 | 255.255.255.0 | N/A | N/A | N/A | N/A | N/A |
| `rocky-host`| HOST |  | 172.21.1.13 | 255.255.0.0 | 172.21.0.9 |  | 24:4B:FE:5B:11:96 |  |  |
| `srv-rocky` | Rocky Linux |  |  |  |  |  |  |  |  |
| `srv-deb-01` | Debian 13.5 |  |  |  |  |  |  |  |  |
| `srv-deb-02` | Debian 13.5 |  |  |  |  |  |  |  |  |
| `ws-cachy` | CachyOS |  |  |  |  |  |  |  |  |
| `ws-manjaro` | Manjaro |  |  |  |  |  |  |  |  |

## Hinweise zur Implementierung
* **VLAN Tagging**: Die VLAN ID 10 muss auf dem Switch-Port sowie in der jeweiligen Netzwerkkonfiguration der VM (z. B. via `netplan`, `nmcli` oder `systemd-networkd`) definiert werden.
* **IP-Bereich**: Der Bereich `192.168.10.0/24` wurde für das VLAN 10 reserviert.
* **MAC-Adressen**: Die aufgeführten MAC-Adressen sind Beispiele (im Bereich `52:54:00` für KVM/QEMU). Diese sollten für die statische DHCP-Zuweisung im Router reserviert werden.

```Bash
cat /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1
nmcli
nmtui
ip a
ip route
nmcli connection down ens160
nmcli connection up ens160
```

## Netzwerk-Konfiguration srv-rocky

## Übersicht
Dieses Dokument beschreibt die Netzwerkkonfiguration für `srv-rocky`. Die VM fungiert als zentraler Knotenpunkt, wobei `ens160` als Gateway-Verbindung (Outbound) und `ens256` als Schnittstelle für das interne LAN-Segment (Inbound) dient.

### Netzwerk-Schnittstellen

| Hostname | Adapter-Name | Zweck | LAN Segment | IP-Adresse | IPv4-Methode | DNS |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `srv-rocky` | `ens160` | Outbound (WAN) | VMnet | DHCP/Statisch | - | 1.1.1.1 |
| `srv-rocky` | `ens256` | Inbound A (LAN) | `switch_net1` | 172.16.7.33/27 | Manual | 1.1.1.1 |
| `srv-rocky` | `ens224` | Inbound B (LAN) | `switch_net1` | 172.16.7.97/27 | Manual | 1.1.1.1 |

### Konfigurations-Schritte (CLI)

#### 1. Inbound-Interface (ens256) einrichten

```bash
# Verbindung für das LAN-Segment erstellen
sudo nmcli con add type ethernet con-name "ens256" ifname ens256 \
ipv4.addresses 172.16.7.33/27 ipv4.gateway 172.21.0.9 \
ipv4.dns "1.1.1.1" ipv4.method manual

# Verbindung aktivieren
sudo nmcli con up "ens256"
```

#### 2. IP-Forwarding aktivieren (Persistenz)
Damit srv-rocky Traffic zwischen ens256 und ens160 weiterleiten kann, muss IP-Forwarding dauerhaft aktiviert werden.

```bash
# Aktivierung für laufende Session
sudo sysctl -w net.ipv4.ip_forward=1

# Persistente Konfiguration schreiben
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-ip-forward.conf

# Konfiguration neu laden
sudo sysctl -p /etc/sysctl.d/99-ip-forward.conf
```

#### 3. Routing & Firewall (Voraussetzungen)
- Routing: Sicherstellen, dass die Ziel-VMs im `switch_net1` die IP `172.16.7.33` als Gateway verwenden.
- Firewall: `nftables` oder `firewalld` muss so konfiguriert werden, dass Masquerading (NAT) auf dem `ens160` Interface aktiviert ist, damit die internen VMs via `srv-rocky` nach außen kommunizieren können.

```bash
# Interface-Status prüfen
ip a show ens256

# Routing-Tabelle prüfen
ip route

# Forwarding-Status prüfen
cat /proc/sys/net/ipv4/ip_forward
``` 
#### 4. Einrichtung von Firewalld (Masquerading)
Da du Rocky Linux nutzt, ist `firewalld` der Standard-Service. Hier ist die notwendige Konfiguration:

```bash
/// <summary>
/// Konfiguriert Firewalld zur Aktivierung von Masquerading (NAT) auf dem WAN-Interface.
/// Dies erlaubt den internen VMs, über ens160 den Host zu verlassen.
/// </summary>
sudo firewall-cmd --permanent --zone=public --add-masquerade

/// <summary>
/// Fügt die internen Interfaces der trusted Zone hinzu, um Routing zuzulassen.
/// </summary>
sudo firewall-cmd --permanent --zone=trusted --add-interface=ens256
sudo firewall-cmd --permanent --zone=trusted --add-interface=ens224

/// <summary>
/// Lädt die Firewall-Konfiguration neu, um die Änderungen anzuwenden.
/// </summary>
sudo firewall-cmd --reload
```
