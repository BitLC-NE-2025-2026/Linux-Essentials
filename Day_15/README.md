# 🐧 Linux Essentials - Day_15

Status: ⏳ In Planung


# Netzwerk-Konfiguration: VLAN-Automatisierung

Diese Tabelle dient als zentrale Datenquelle für das geplante Automatisierungsskript zur Netzwerkkonfiguration.

| Hostname | OS | Interface Name | IP-Adresse | Subnetzmaske | Gateway | DNS-Server | MAC-Adresse | VLAN ID | VMWare LAN Segments |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `gw-router` | Gateway |  | 172.21.0.9 | 255.255.255.0 | - | 1.1.1.1 |  |  |  |
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

# Netzwerkadapter-Konfiguration: `srv-rocky`

Diese Konfiguration spezifiziert den neuen Adapter für die Einbindung in das definierte LAN-Segment.

| Hostname | Adapter-Name | LAN Segment | MAC-Adresse | IPv4-Methode | DNS-Server |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `srv-rocky` | `ens256` | `switch_net1` | 00:0C:29:XX:YY:ZZ | Static | 1.1.1.1 |

## Konfigurationsdetails für `srv-rocky` (ens256)

Um den neuen Adapter dauerhaft über die Kommandozeile zu konfigurieren, sind folgende Schritte erforderlich:

### 1. Verbindung definieren
```bash
# Erstellen der neuen Verbindung mit statischer IP
sudo nmcli con add type ethernet con-name "ens256" ifname ens256 ipv4.addresses 172.21.1.14/16 ipv4.gateway 172.21.0.9 ipv4.dns "1.1.1.1" ipv4.method manual
```
