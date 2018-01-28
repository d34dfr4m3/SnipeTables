#!/bin/bash
echo "[*] Running on Tables/filter/FORWARD"
echo "[-] Starting FORWARDD" | tee -a logs/powerup.log 

echo "[*] Setup the state module" | tee -a logs/powerup.log
iptables -v -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT 2>>logs/powerup.log

#######-Regras Personalizadas-########
echo "[*] Regras personalizadas" | tee -a Docs/Report
#liberando a receitanet, sonegação é crime.
iptables -v -t filter -A FORWARD -s 192.168.0.0/24 -d 201.198.239.0/24 -p tcp -m multiport --dport 3443,3456 -j ACCEPT 2>>logs/powerup.log
echo "Acesso à Receitanet: PORTAS: 3443,3456 no Range: 201.198.239.0/24" >> Docs/Report
#Compra de Vale transporte, máfia
iptables -v -t filter -A FORWARD -s 192.168.0.0/24 -d 200.165.79.154 -p tcp --dport 8880 -j ACCEPT 2>>logs/powerup.log
echo "Acesso à Compra de vale transporte, porta 8880 no ip: 200.165.79.154" >> Docs/Report
#NTP
iptables -v -t filter -A FORWARD -s 192.168.0.0/24 -d 91.189.94.4 -p udp --dport 123 -j ACCEPT 2>>logs/powerup.log
echo "Network Time Protocol liberado para 91.189.94.4 na porta udp 123" >> Docs/Report
#banco Rural, 254 hosts???/
iptables -v -t filter -A FORWARD -s 192.168.0.0/24 -d 200.154.23.0/24 -p tcp --dport 8444 -j ACCEPT 2>>logs/powerup.log
echo "Acesso à Banco Rural liberado no ip 200.154.23.0 na porta 8444" >> Docs/Report
#SupraMail
iptables -v -t filter -A FORWARD -s 192.168.0.0/24 -d 204.11.238.119 -p tcp --dport 4040 -j ACCEPT 2>>logs/powerup.log
echo "Acesso à serviço de configuração do SupraMail no endereço 200.11.238.119 na porta 4040" >> Docs/Report

##############-END-###################

echo "[DONE] Forward" 



#https://www.vivaolinux.com.br/artigo/IPtables-Trabalhando-com-Modulos/
