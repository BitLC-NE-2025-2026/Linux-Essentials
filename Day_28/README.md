# 🐧 Kryptographie & MTAs — Tag 28

![Linux Essentials Day 28 Header](./header.png)

> **Entwickler & Administrator:** Tobias Boyke  
> **Status:** 🚀 100% Dokumentiert & LPIC-1 Fokussiert  
> **Kompatibilität:** ![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-8%20%7C%209-blue) ![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red) ![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Latest-cyan)

---

## 📑 Inhaltsverzeichnis
- [📖 Themenübersicht](#-themenübersicht)
- [🧠 LPIC-1 Relevanz & Wissenstest](#-lpic-1-relevanz--wissenstest)
- [🔗 Zurück zur Übersicht](#-zurück-zur-übersicht)

---

## 📖 Themenübersicht

## 🔑 1. Asymmetrische Verschlüsselung mit GPG
GNU Privacy Guard (GPG) dient zur Verschlüsselung und Signierung von Daten.
* GPG-Schlüsselpaar generieren: `gpg --full-generate-key`
* Öffentlichen Schlüssel exportieren: `gpg -a --export "Name" > public.key`
* Datei verschlüsseln: `gpg -e -r "Empfänger" datei.txt`

## 🚇 2. SSH Tunneling & Port-Forwarding
SSH ermöglicht das Tunneln anderer Netzwerkprotokolle durch verschlüsselte Verbindungen.
* **Local Port Forwarding (`-L`):** Leitet einen lokalen Port an ein Ziel über den SSH-Host weiter.
  `ssh -L 8080:localhost:80 user@server`
* **Remote Port Forwarding (`-R`):** Leitet einen Port des SSH-Servers an den lokalen Client weiter.

## 📧 3. Mail-Infrastruktur & MTAs
Linux nutzt Mail Transfer Agents (MTA) zur E-Mail-Übertragung.
* **Postfix / Sendmail:** Standard-MTAs unter Linux.
* `/etc/aliases`: Leitet E-Mails an andere Benutzer weiter. Nach Änderungen muss `newaliases` ausgeführt werden.

---

## 🧠 LPIC-1 Relevanz & Wissenstest

<details>
<summary><b>Fragen zu Kryptographie & MTAs (Klicken zum Ausklappen)</b></summary>

1. **Welches Tool wird unter Linux zur asymmetrischen Verschlüsselung und Signierung von E-Mails/Dateien genutzt?**
   <details><summary>Antwort</summary>`gpg` (GNU Privacy Guard).</details>

2. **Wie exportiert man seinen öffentlichen GPG-Schlüssel?**
   <details><summary>Antwort</summary>Mit `gpg -a --export "Name" > public.key` (`-a` für ASCII-Armored Format).</details>

3. **Welche primäre Aufgabe hat ein Mail Transfer Agent (MTA) wie Postfix oder Sendmail?**
   <details><summary>Antwort</summary>Den Transport und die Zustellung von E-Mails zwischen Mail-Servern mittels SMTP.</details>

4. **Wie leitet man E-Mails für einen bestimmten lokalen Benutzer in eine andere Mailbox um?**
   <details><summary>Antwort</summary>Über systemweite Einträge in `/etc/aliases` (und anschließendes Ausführen von `newaliases`) oder benutzerspezifisch über die Datei `~/.forward`.</details>

5. **Wie baut man einen lokalen Port-Forwarding-Tunnel über SSH auf?**
   <details><summary>Antwort</summary>Mit der Option `-L`: `ssh -L [lokaler_port]:[ziel_host]:[ziel_port] [user]@[ssh_server]`.</details>

</details>

---

## 🔗 Zurück zur Übersicht

* **Tag 27 (SSH Härtung & Limits):** [⬅️ Tag 27](../Day_27/README.md)
* **Tag 29 (LPIC-1 Simulation 101):** [➡️ Tag 29](../Day_29/README.md)
* **Master-Repository:** [🌌 Zurück zum Master-Repository](../README.md)

---
*Erstellt & gepflegt von Tobias Boyke, Juni 2026.*
