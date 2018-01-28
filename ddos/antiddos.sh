#!/bin/bash
#This is not a mode

#I need to tell you something, its about how iptables fucking works.
#The rules must be put in the highest chain, and the top ins't the input, is the prerouting, i will use mangle if you use input, you will lose in speed, because the packet will pass to another twoo chains first, if this packet come to the input chain, so, again i will tell you, i will make the murder stuff in prerouting of mangle.
echo "[-}Set up the tcp_syncookies"
echo 1 > /proc/sys/net/ipv4/tcp_syncookies 2>>logs/powerup.log
echo "[+]Set up the tcp_syncookies - DONE"

echo "[-] Limit icmp"
iptables -v -t filter INPUT --icmp-type echo-request -m limit --limit 1/s -j ACCEPT 2>>logs/powerup.log
echo "[+] Limit Icmp- DONE" 

#killing invalid Packets 
iptables -v -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP

#killing new packets that are not syn
iptables -v -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
#Killing Uncommon MSS VAlues
#iptables -v -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! -mss 536:65535 -j DROP
#Killing Packets with bogus tcp flags 
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -v -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

#Killing Packets from private subnets(spoofing) **** EASY HERE DUDE, REMOVE YOUR OWN SUBNET. 
iptables -v -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
iptables -v -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
iptables -v -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
iptables -v -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
iptables -v -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
iptables -v -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
iptables -v -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
iptables -v -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
#iptables -t mangle -A PREROUTING -s 192.168.0.0/24 -j DROP 
iptables -v -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP

#Additional Rules 
iptables -v -t mangle -A PREROUTING -p icmp -j DROP
#Rejects connections from hosts that have more than 80 establishied connections
iptables -v -A INPUT -p tcp -m connlimit --connlimit-above 80 -j REJECT --reject-with tcp-reset

#This can be useful against connection attacks but not so much against syn flood
iptables -v -t mangle -A PREROUTING -f -j DROP

#KIllig framgnets 
iptables -v -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT
iptables -v -A INPUT -p tcp --tcp-flags RST RST -j DROP

### Synproxy rules
iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack
iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP


### SSH brute-force protection ###
/sbin/iptables -v -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
/sbin/iptables -v -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

### Protection against port scanning ###
/sbin/iptables -v  -N port-scanning
/sbin/iptables -v -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
/sbin/iptables -v  -A port-scanning -j DROP

echo "[+] AntiDDos, now we got a psico packet killer"
