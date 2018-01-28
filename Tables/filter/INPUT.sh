#!/bin/bash
echo "[*] Running on Tables/filter/INPUT"
echo "[-] INPUT START" | tee -a log/powerup.log
echo "[*] Stabelish connections accept" | tee -a log/powerup.log
iptables -v -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 2>>logs/powerup.log
iptables -v -t filter -A INPUT -s 127.0.0.1 -j ACCEPT 2>>logs/powerup.log
echo "[+] INPUT FINITSH " | tee -a log/powerup.log

