# 🐧 Linux Essentials - Day_15

Status: ⏳ In Planung


# Netzwerk-Konfiguration: VLAN-Automatisierung

Diese Tabelle dient als zentrale Datenquelle für das geplante Automatisierungsskript zur Netzwerkkonfiguration.

| Hostname | OS | IP-Adresse | Subnetzmaske | Gateway | DNS-Server | MAC-Adresse | VLAN ID |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `gw-router` | Gateway | 172.21.0.9 | 255.255.255.0 | - | 1.1.1.1 | 00:00:5E:00:01:01 |  |
| `rocky-host`| HOST | 172.21.1.13 | 255.255.0.0 | 172.21.0.9 |  | 24:4B:FE:5B:11:96 |  |
| `srv-rocky` | Rocky Linux | 192.168.10.10 | 255.255.255.0 | 192.168.10.1 | 192.168.10.1 | 52:54:00:A1:B2:C1 | 10 |
| `srv-deb-01` | Debian 13.5 | 192.168.10.11 | 255.255.255.0 | 192.168.10.1 | 192.168.10.1 | 52:54:00:A1:B2:C2 | 10 |
| `srv-deb-02` | Debian 13.5 | 192.168.10.12 | 255.255.255.0 | 192.168.10.1 | 192.168.10.1 | 52:54:00:A1:B2:C3 | 10 |
| `ws-cachy` | CachyOS | 192.168.10.20 | 255.255.255.0 | 192.168.10.1 | 192.168.10.1 | 52:54:00:A1:B2:C4 | 10 |
| `ws-manjaro` | Manjaro | 192.168.10.21 | 255.255.255.0 | 192.168.10.1 | 192.168.10.1 | 52:54:00:A1:B2:C5 | 10 |

## Hinweise zur Implementierung
* **VLAN Tagging**: Die VLAN ID 10 muss auf dem Switch-Port sowie in der jeweiligen Netzwerkkonfiguration der VM (z. B. via `netplan`, `nmcli` oder `systemd-networkd`) definiert werden.
* **IP-Bereich**: Der Bereich `192.168.10.0/24` wurde für das VLAN 10 reserviert.
* **MAC-Adressen**: Die aufgeführten MAC-Adressen sind Beispiele (im Bereich `52:54:00` für KVM/QEMU). Diese sollten für die statische DHCP-Zuweisung im Router reserviert werden.

cat /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1
nmcli
nmtui
ip a
ip route
