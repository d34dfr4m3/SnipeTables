#!/bin/bash
echo "[*] Running on Tables/filter/OUTPUT"
echo "[-] Lets going OUTOUT" | tee -a log/powerup.log

echo "[+] SetUp Module State" | tee -a log/powerup.log
iptables -v -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 2>>logs/powerup.log
echo "[*] Setup Module State DONE" | tee -a log/powerup.log

#####-Regras personalizadas-############
iptables -v -t filter -A OUTPUT -d 127.0.0.1  -j ACCEPT  2>>logs/powerup.log
iptables -v -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT 2>>logs/powerup.log



##########-----END------###############
