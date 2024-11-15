#!/bin/bash 

# backup most of the data
rsync -avzh /home/pickle/Documents /var/backups/ --exclude "*/target/*" --exclude "*/node_modules/*" --exclude "*.git*" --max-size=10M
rsync -avzh /home/pickle/Downloads /var/backups/ --exclude "Telegram" --max-size=10M
rsync -avzh /home/pickle/Videos /var/backups/ --max-size=10M
rsync -avzh /home/pickle/Pictures /var/backups/ --max-size=10M

