# Linux Distributions Richtungen
- Red Hat (Rocky, Red Hat Enterprise, )
- Debien (Debien, Ubuntu, Kali-Linux, Mint(Ubuntu Based), )
- Arch-Linux (Manjaro, Garuda, )
- Suse
- LFS

### NoteNotes
- Enterprise für den Unternehmensbereich (Bis zu 10 Jahre support)
- 99% aller IT-Systeme laufen unter Linux

# System Arten
- LTS = Long Term Support (Hängt von den Kernel ab) (Neue Version alle 2 Jahre, Nach 4-5 keine Sicherheits Updates mehr)
- RR = Rolling Release (Ständige Updates (Sicherheit, System), keine neuinstallationen nötig)
- Hyper visor 1 = Virtualisierung (Bare Metall)
- Hyper Visor 2 = Virtualisierung (VM-Ware, Oracle Virtual Box)
- Container Management (Docker, Podman)

### NoteNotes
- Linux besides Enterprise abgesehen von Enterprise Versionen meist Kostenlos
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
  
# Linux Command Consol Prompts
```list/ls -al``` *Shows all Commands for the current state*  
```man/manual "command z.B. ls" ``` *shows what the command does*  
```cd "folder"``` *goes into a folder and be used multiple times to go into deeper folders*   
```q``` *goes back one folder or menu*  
```clear``` *clears the command console*  
```echo``` "Text oder $0" *gibt den Text 'text' aus oder bei $0 bash erste stelle*  
```exit``` *goes back one folder/menu or closes the consol if in no menu*  
```id```  
```su -``` *= switch user*  
```usermod -aG wheel "username"``` *adds user to certain group wheel*  
```sudo dnf update``` *gives full access current to user*  
```cd ..``` *goes one "level" back*  
```ls boot```  
```cd ~``` *homeverzeichniss des Benutzer*  
```cd "user"``` *direkte Benutzer angabe*  
```pwd``` *= print working directory, shows where your at*  

### Überprüfungs Befehl/Check Command
```Sha256sum -c "Datei"``` *= Secure Hash Algorithm, ```256sum``` = Prüfsumme  
```-c/--check``` Überprüft mit der Prüfsumme aus ```256sum``` die Datei in ```"Datei"``` z.B. Rocky-9.7-x86_64-boot.ISO*  
  
### Verzeichnisse
```home``` homeverzeichniss  
```~``` homeverzeichniss des Benutzers  
```/``` Wurzelverzeichniss  

