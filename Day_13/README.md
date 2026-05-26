# ⏱️ Linux Essentials Tag 13

![Linux Essentials Day 13 Header](./header.png)

Am dreizehnten Tag der Linux Essentials behandeln wir fortgeschrittenes Shell Scripting. Wir fokussieren uns auf die Automatisierung der Benutzerverwaltung und den Aufbau interaktiver Menüs mit Standard Terminal Befehlen und Whiptail.

---

## 📑 Inhaltsverzeichnis

* [Lernziele LPIC-1 relevant](#-lernziele-lpic-1-relevant)
* [Automatisierte Benutzeranlage](#-1-automatisierte-benutzeranlage)
* [Textbasierte Benutzeroberflächen](#-2-textbasierte-benutzeroberflaechen)
* [Grafische Dialoge mit Whiptail](#-3-grafische-dialoge-mit-whiptail)
* [Druckersteuerung im Terminal](#-4-druckersteuerung-im-terminal)
* [Zurück zur Übersicht](#-zurueck-zur-uebersicht)

---

## 🎯 Lernziele LPIC-1 relevant

* Erstellung und Strukturierung komplexer Shell Skripte.
* Automatisierung der Benutzerverwaltung.
* Entwicklung interaktiver Menüs für administrative Aufgaben.
* Verwaltung von Druckaufträgen im Terminal.

---

## ⚙️ 1. Automatisierte Benutzeranlage

Skripte übernehmen das massenhafte Anlegen von Benutzerkonten effizient und fehlerfrei. Unser Skript liest Daten aus einer unformatierten CSV Datei ein und bereinigt diese im ersten Schritt. Das Werkzeug pwgen generiert sichere Initialpasswörter für jeden neuen Account. Die Systembefehle useradd und chpasswd erstellen das Konto und weisen das generierte Systempasswort zu. Alle Vorgänge dokumentiert das Skript in einer dedizierten Protokolldatei.

---

## ⌨️ 2. Textbasierte Benutzeroberflächen

Ein Menüskript steuert die Ausführung verschiedener Administrationsaufgaben. Eine while Schleife hält das Menü dauerhaft offen. Die case Verzweigung wertet die Benutzereingabe aus und startet die entsprechenden Unterskripte zur Provisionierung oder Deprovisionierung. 

```bash
# ==============================================================================
# Skript: Interaktives Konsolenmenü
# Beschreibung: Hält eine Eingabeaufforderung über eine Endlosschleife aufrecht.
# while true: Startet eine Schleife mit dauerhafter Gültigkeit
# read: Liest die Benutzereingabe in die Variable choice ein
# case: Prüft die Variable choice gegen definierte Muster
# ==============================================================================
while true; do
    echo "1 für Provisionierung, 2 für Ende"
    read -r choice
    case "$choice" in
        1) ./user_provisioning.sh ;;
        2) exit 0 ;;
    esac
done
```

---

## 🖼️ 3. Grafische Dialoge mit Whiptail

Das Werkzeug whiptail erzeugt grafische Fenster direkt im Terminal. Es bietet Funktionen für Messageboxen, Menüs und scrollbare Textboxen. Dies erhöht den Bedienkomfort für Administratoren erheblich. Das Skript fängt die Auswahl des Benutzers ab und leitet die Ausführung entsprechend weiter.

```bash
# ==============================================================================
# Skript: Whiptail Dialogausgabe
# Beschreibung: Erzeugt ein interaktives Auswahlmenü für den Benutzer.
# whiptail: Hauptbefehl zur Erzeugung der grafischen Oberfläche
# title: Setzt den Titel des Fensters
# menu: Definiert den Typ des Dialogs als Menüauswahl
# Parameter 15 60 6: Definieren Höhe Breite und Anzahl der sichtbaren Menüpunkte
# ==============================================================================
whiptail --title "Hauptmenü" --menu "Bitte wählen:" 15 60 6 "1" "Benutzer anlegen" "2" "Ende"
```

---

## 🖨️ 4. Druckersteuerung im Terminal

Protokolle lassen sich direkt aus dem Skript heraus auf physischen Druckern ausgeben. Der Befehl lpstat listet alle konfigurierten Drucker im System auf. Der Befehl lp sendet die gewünschte Textdatei an das gewählte Zielgerät. Im whiptail Skript integrieren wir diese Befehle für einen reibungslosen Workflow.

---

## 🔗 5. Zurück zur Übersicht
⬅ Zurück zur Übersicht

Erstellt am 22. Mai 2026 für den Linux Essentials Kurs.
