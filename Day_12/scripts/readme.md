install dir home/scripts/historyscript.sh

```bash
chmod +x ~/historyscript.sh

crontab -e

30 15 * * 1-5 /home/scripts/historyscript.sh

```


Install für history-export.service

-# verzeichnisse und datei anlegen 
```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/history-export.service
```
-# Dienst enablen und starten
```bash
systemctl --user daemon-reload
systemctl --user enable history-export.service
systemctl --user start history-export.service
```
