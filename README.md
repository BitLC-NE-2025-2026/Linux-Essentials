# Linux Distributions Richtungen
- Red Hat (Rocky, Red Hat Enterprise, )
- Debien (Debien, Ubuntu, Kali-Linux, Mint(Ubuntu Based), )
- Arch-Linux (Manjaro, Garuda, )
- Suse
- LFS

### NoteNotes
- Betriebssystem & Programmschicht = Softwareschicht = Betriebssystemkern
- Enterprise für den Unternehmensbereich (Bis zu 10 Jahre support)
- 99% aller IT-Systeme laufen unter Linux

# System Arten
- LTS = Long Term Support (Hängt von den Kernel ab) (Neue Version alle 2 Jahre, Nach 4-5 keine Sicherheits Updates mehr)
- RR = Rolling Release (Ständige Updates (Sicherheit, System), keine neuinstallationen nötig)
- Hyper visor 1 = Virtualisierung (Bare Metall)
- Hyper Visor 2 = Virtualisierung (VM-Ware, Oracle Virtual Box)
- Container Management (Docker, Podman)

### NoteNotes
- Linux abgesehen von Enterprise Versionen meist Kostenlos
- Treiber bei Linux = Module

### Hyper Visor 1
- Braucht kein Host Grundsystem
- Software hat Treiber für Hardware
- Ist dazu da um Schnelle Systeme zu bauen

### Hyper Visor 2
- Bedingung sind Grundsystem, ISO-Image der Linux Distribution
- Installierte Betriebssystem ist vom Host Betriebssystem gekapselt
- installiertes Betriebssystem nutzt Treiber und Hardware vom Betriebssystem
- Ist für Experimentelle Systeme entwickelt worden

### Container-Management
- Erzeugen von Instanzen um eine Hohe Datenlast von Anwendungen abzufangen (Wie Objekte in OOP) Container-Instanzen erzeugen, Löschen

