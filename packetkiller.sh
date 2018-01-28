#!/bin/bash
#set -x
#READ THAT SHIT HERE, PLEASE:

#DID YOU AGREE TO ME WRITE IN THE /etc/sysctl.conf?[y/n]
#sysctl="y"

#DID YOU WANT TO SHARE THE INTERNET WITH LAN?[y/n]
sharenet="y"

#PLEASE, PUT YOUR WEBSEVERS ABOVE. USE SPACE. Now i figure it out, i has just one port 80 and one 443, so, you can add only one webserver.
WEBSERVERS=""

#SSH EXTERNAL CLIENTS TO INPUT BRO 
ssh_clients="189.53.6.118"
ssh_port="4443"

#SSHDAEMONS HOLDERS hue.jpeg INTERNAL SERVERS BRO
sshd_servers=""

#MICROSHIT STUFF, ops, i mean MICROSOFT. TS STUFF INTERNAL BRO NAT STUFF
TS="192.168.0.1 192.168.0.2"
EXTERNALPORTS="9001"

#Basic Protocols 
proto="domain smtp https http pop3 imap ftp"

##VNC 
vnc_server="192.168.0.20 192.168.0.22 192.168.0.45 192.168.0.34 192.168.0.76"
initialport="6000" #PAY ANTENTION TO NOT FUCK WITH THE PORTS 
#
#Do not touch in the code above, but with you know what you are doing, feels free.
#####-FUNCTIONS-########
######-CONSTANTS-#######
constants(){
	echo 1 > /proc/sys/net/ipv4/ip_forward
}
function police(){ #YES, THE COPS, and the cops will not change to accept policy.
######- Default Policys
#Table Filter
	iptables -v -t filter -P INPUT DROP 2>>logs/powerup.log
	iptables -v  -t filter -P OUTPUT DROP 2>>logs/powerup.log
	iptables -v -t filter -P FORWARD DROP 2>>logs/powerup.log
#Table Nat
	iptables -v -t nat -P PREROUTING DROP  2>>logs/powerup.log
	iptables -v -t nat -P POSTROUTING DROP 2>>logs/powerup.log
	iptables -v -t nat -P OUTPUT DROP      2>>logs/powerup.log
######-End Default Policys
} 
function clean(){
	echo "[-]- Cleaner Routine" | tee -a logs/powerup.log 
	echo "Firewall Start at: `date`" > logs/powerup.log
	iptables -v -t filter -F 2>>logs/powerup.log  
	echo "[+] Filter - DONE" 
	iptables -v -t nat -F    2>>logs/powerup.log
	echo "[+] Nat    - DONE" 
	iptables -v -t mangle -F 2>>logs/powerup.log
	echo "[+] Mangle - DONE"
	iptables -X
	echo "[+] Users table - DONE"
 	echo "[+]- Cleaner Routine: DONE"
}
function callfilter(){
	echo "[-]- Loading filter table rules" | tee -a logs/powerup.log
	./Tables/filter/*.sh
	echo "[+]- Loading filter table rules:  DONE" | tee -a logs/powerup.log
}
function callnat(){
	echo "[-]- Loading  nat table rules" | tee -a logs/powerup.log
	./Tables/nat/*.sh
	echo "[+]- loading nat table rules: DONE" | tee -a logs/powerup.log
}
function callmangle(){
	echo "[-]- Loading mangle table rules" | tee -a logs/powerup.log
	./Tables/MANGLE/*.sh
	echo "[+]- Loagind mangle talbe rules: DONE" | tee -a logs/powerup.log
} 
function kernel4win(){
	echo "[-]-Loading Kernel Stuff" | tee -a logs/powerup.log
	if [ $sysctl = 'y' ];then 
        	./Kernel/KernelSettings.sh 
		echo "[+]-Loading Kernel Stuff: DONE" | tee -a logs/powerup.log
	else
		echo "[*]- Loading Kernel Stuff: Aborted" | tee -a logs/powerup.log
	fi
}
#####-Accepting Services.
function blackmustache(){
#WEBSERVERS STUFF
	if [ -z "$webservers" ];then
		echo "No WebServers setup" | tee -a logs/powerup.log
	else
		for i in $webservers 
		do
			iptables -v -t filter -A FORWARD -d$i -p tcp --dport 80 -j ACCEPT 2>>logs/powerup.log
			iptables -v -t filter -A FORWARD -d$i -p tcp --dport 443 -j ACCEPT2>>logs/powerup.log
		done
	fi
#SSH STUFF
	if [ -z "$ssh_clients" ]; then
		echo "No ssh clients setup" | tee -a logs/powerup.log

	else 
		echo "--------SSH----------">>Docs/Report
		for i in $ssh_clients 
		do	
			iptables -t filter -A FORWARD -d$i -p tcp --dport $ssh_port -j ACCEPT 2>>logs/powerup.log
			echo "SSH to Server| Client: $i in port: $ssh_port" >>Docs/Report
			ssh_port=$((ssh_port+1))
		done
	fi
#TERMINAL SERVICE STUFF 
	if [ -z "$TS" ]; then 
		echo "No terminal servers setup" | tee -a logs/powerup.log
	else
		echo "----------TS-----------">> Docs/Report
		for i in $TS 
		do
			iptables -v -t nat  -A PREROUTING  -p tcp --dport $b -j DNAT --to $i 2>>logs/powerup.log
			echo "Terminal Server Connections Port: $EXTERNALPORTS Internal Server: $i " >> Docs/Report
			EXTERNALPORTS=$((EXTERNALPORTS+1))
		done
	fi
	if [ -z "$vnc_server" ];then
		echo "No Vnc servers setup" | tee -a logs/powerup.log
	else
		echo "----------VNC----------" >> Docs/Report
		for i in $vnc_server 
		do
			iptables -v -t nat -A PREROUTING --dport $initialport -j DNAT --to $i 2>>logs/powerup.log
			echo "VNC Connections Port $initialport InternalServer $i" >> Docs/Report
			initialport=$(( $initialport + 1)) 
		done

	fi
	if [ $sharenet = 'y' ];then
		echo "-----INFO------" >>Docs/Report
		iptables -v -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE 2>>logs/powerup.log
		echo "Acesso a internet liberado para a rede 192.168.0.0/24 para a interface que estiver ativa" >>Docs/Report
		echo "---------------" >> Docs/Report
	else 
		echo "[+] No internet today" | tee -a logs/powerup.log
	fi
	if [ -z "$proto" ];then
		echo "No Protocol enable in Forward" | tee -a logs/powerup.log
	else
		echo "-----SERVICES----" >>Docs/Report
		for i in $proto  
		do	
			port=$(getent services $i | tr -s  ' ' | cut -d ' ' -f 2 | cut -d '/' -f 1)
			protocol=$(getent services $i | tr -s  ' ' | cut -d ' ' -f 2 | cut -d '/' -f 2)
			read
			if [  $i == 'domain' ];then
				protocol="udp"
				iptables -v -t filter -A FORWARD -p $protocol --dport $port -j ACCEPT 2>>logs/powerup.log 
			else
				iptables -v -t filter -A FORWARD -p $protocol --dport $port -j ACCEPT 2>>logs/powerup.log 
			fi
			echo "Enable $i in port:$port and protocol:$protocol" >>Docs/Report
		done
			read
	fi
}
function dropthebase(){
echo "[-] Function: Drop the end"
#Table:Filter
	iptables -v -t filter -A INPUT -j LOG --log-prefix "FILTER-INPUT: "  2>>logs/powerup.log
	iptables -v -t filter -A INPUT -j DROP 2>>logs/powerup.log
	iptables -v -t filter -A FORWARD -j LOG --log-prefix "FILTER-FORWARD: "  2>>logs/powerup.log
	iptables -v -t filter -A INPUT -j DROP 2>>logs/powerup.log
	iptables -v -t filter -A OUTPUT -j LOG --log-prefix "FILTER-OUTPUT: " 2>>logs/powerup.log
#Table: nat
	iptables -v -t nat -A PREROUTING -j LOG --log-prefix "NAT-PREROUTING: " 2>>logs/powerup.log
	iptables -v -t nat -A PREROUTING -j DROP 2>>logs/powerup.log
	iptables -v -t nat -A POSTROUTING -j LOG --log-prefix "NAT-POSTROUTING: " 2>>logs/powerup.log
	iptables -v -t nat -A POSTROUTING -j DROP 2>>logs/powerup.log
	iptables -v -t nat -A OUTPUT -j LOG --log-prefix "NAT-OUTPUT: " 2>>logs/powerup.log
	iptables -v -t nat -A OUTPUT -j DROP 2>>logs/powerup.log
#Table Mangle, not necessary, i think. 
echo "[+] DONE: Function: Drop the end" 
}
########-MAIN-########
case $1 in
start)
if [ $(id -u) != 0 ];then 
	echo "Dummy, get root. " | tee -a  logs/powerup.log
	exit
else
	echo '' >Docs/Report
	police
	constants
	callfilter
	callnat	
	callmangle
	blackmustache
#Kernel Hardening 
#kernel4win Disable because the hardware changes, if you want to setup this, you will need to make the especific configs in the file

#DDOS  Mitigation, or, pseudo mitigation.
	echo "[-] Starting anti ddos routine" | tee -a logs/powerup.log
	./ddos/antiddos.sh 
	echo "[+] DONE: Starting anti ddos routine" | tee -a logs/powerup.log
	dropthebase
fi ;;
stop)
	clean
	echo "Firewall Stoped at `date`" | tee -a logs/powerup.log ;;
restart)
	 $0 stop
	 $0 start  ;;

*) 	echo "Usages packetkiller.sh (start|stop|restart)";;
esac 


