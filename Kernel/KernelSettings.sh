#!/bin/bash
# C function to print messages /loglevels/LogBuffer/
sysctl -w kernel.printk=4 4 1 7
# When Kernel Panic's, reboots after 10 second delay
sysctl -w kernel.panic=10
# Disable the Sysrq Key, the SysRq is a key sequence that allows some basic commands to be passed direclty to the kernel
sysctl -w kernel.sysrq=0

#DOCS: http://nervinformatica.com.br/blog/index.php/2012/12/12/configuracao-de-shmmax-shmmni-shmall-e-shmall/
# MAKE THIS SHIT DINAMIC ASSHOLE ***************

#Shared Memory Max: Numero máxido de segmentos de shared memory
sysctl -w kernel.shmmax=4294967296
#Shared Memory: Número de págins alocaveis na shared memory
sysctl -w kernel.shmall=4194304
#The core dump becomes core. Appends the coring processes PID to the core file name
sysctl -w kernel.core_uses_pid=1
# Controls the maximum size of a message in bytes.
sysctl -w kernel.msgmnb=65536
# Controls the default maxmimum size of a mesage queue
sysctl -w kernel.msgmax=65536 
#How much of memory goes to swapp. 20% to swap;
sysctl -w vm.swappiness=20
# Percentage of system memory which when dirty, the process doing writes would block and write out dirty pages to the disks.
sysctl -w vm.dirty_ratio=80
#The percentage of system memory that can be filled with "dirty" pages - memory pages that still need to be written to disk - 5%
sysctl -w vm.dirty_background_ratio=5
#Open Files Limit
sysctl -w fs.file-max=2097152
# Increase number of incoming connections backlog queue Sets the maximum number of packets, queued on the INPUT  side, when the interface receives packets faster than  kernel can process them. 
sysctl -w net.core.netdev_max_backlog=262144
### Set the max OS send buffer size (wmem) and receive buffer
# size (rmem) to 12 MB for queues on all protocols. In other 
# words set the amount of memory that is allocated for each
# TCP socket when it is opened or created while transferring files
# Default Socket Receive Buffer 
sysctl -w net.core.rmem_default=31457280
# Maximum Socket Receive Buffer 
sysctl -w net.core.rmem_max=67108864

# Default Socket Send Buffer 
sysctl -w net.core.wmem_default=31457280
# Maximum Socket Send Buffer 
sysctl -w net.core.wmem_max=67108864
# Increase number of incoming connections somaxconn defines the number of request_sock structures allocated per each listen call. The  queue is persistent through the life of the listen socket.
sysctl -w net.core.somaxconn=65535
# Increase the maximum amount of option memory buffers
sysctl -w net.core.optmem_max=25165824
#Arp table stuff : DOCS https://www.vivaolinux.com.br/dica/Eliminando-o-Neighbour-table-overflow
sysctl -w net.ipv4.neigh.default.gc_thresh1=4096
#arp table stuff
sysctl -w net.ipv4.neigh.default.gc_thresh2=8192
#arp table stuff
sysctl -w net.ipv4.neigh.default.gc_thresh3=16384
#arp table stuff
sysctl -w net.ipv4.neigh.default.gc_interval=5

sysctl -w net.ipv4.neigh.default.gc_stale_time=120

sysctl -w net.netfilter.nf_conntrack_max=10000000

sysctl -w net.netfilter.nf_conntrack_tcp_loose=0

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=1800

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_close=10

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_close_wait=10

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_fin_wait=20

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_last_ack=20

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_syn_recv=20

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_syn_sent=20

sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=10

sysctl -w net.ipv4.tcp_slow_start_after_idle=0
# Allowed local port range 
sysctl -w net.ipv4.ip_local_port_range=1024 65000

sysctl -w net.ipv4.ip_no_pmtu_disc=1

sysctl -w net.ipv4.route.flush=1

sysctl -w net.ipv4.route.max_size=8048576

net.ipv4.icmp_echo_ignore_broadcasts=1

net.ipv4.icmp_ignore_bogus_error_responses=1
# recommended default congestion control is htcp 
sysctl -w net.ipv4.tcp_congestion_contro =htcp

# Increase the maximum total buffer-space allocatable This is measured in units of pages (4096Bytes)
sysctl -w net.ipv4.tcp_mem=512 #65536 131072 262144
sysctl -w net.ipv4.udp_mem=512 #65536 131072 262144

# Increase the read-buffer space allocatable (minimum size, 
# initial size, and maximum size in bytes) 
sysctl -w net.ipv4.tcp_rmem=512 # 4096 87380 33554432
sysctl -w net.ipv4.udp_rmem_min=16384

# Increase the write-buffer-space allocatable 
net.ipv4.tcp_wmem=512 #4096 87380 33554432
net.ipv4.udp_wmem_min=1024 #16384
# Increase the tcp-time-wait buckets pool size to prevent simple DOS attacks 
net.ipv4.tcp_max_tw_buckets=1440000
# net.ipv4.tcp_tw_recycle=1 
net.ipv4.tcp_tw_recycle=0

net.ipv4.tcp_tw_reuse=1
# tells the kernel how many TCP sockets that are not attached to any user file handle to maintain. In case this number is exceeded, orphaned connections are immediately reset and a warning is printed.
net.ipv4.tcp_max_orphans=400000
# Turn on window scaling which can enlarge the transfer window:
sysctl -w net.ipv4.tcp_window_scaling=1
# Protect Against TCP Time-Wait 
sysctl -w net.ipv4.tcp_rfc1337=1

sysctl -w net.ipv4.tcp_syncookies=1
# Number of times SYNACKs for passive TCP connection. 
sysctl -w net.ipv4.tcp_synack_retries=1

sysctl -w net.ipv4.tcp_syn_retries=2
# Maximum number of remembered connection requests, which did not yet  receive an acknowledgment from connecting client.
sysctl -w net.ipv4.tcp_max_syn_backlog=16384
# Enable timestamps as defined in RFC1323:
sysctl -w net.ipv4.tcp_timestamps=1
# Enable select acknowledgments: 
sysctl -w net.ipv4.tcp_sack=1

sysctl -w net.ipv4.tcp_fack=1

sysctl -w net.ipv4.tcp_ecn=2
# Decrease the time default value for tcp_fin_timeout connection 
sysctl -w net.ipv4.tcp_fin_timeout=10

sysctl -w net.ipv4.tcp_keepalive_time=600

sysctl -w net.ipv4.tcp_keepalive_intvl=60

sysctl -w net.ipv4.tcp_keepalive_probes=10
# Do not cache metrics on closing connections 
sysctl -w net.ipv4.tcp_no_metrics_save=1

sysctl -w net.ipv4.ip_forward=0

sysctl -w net.ipv4.conf.all.accept_redirects=0

sysctl -w net.ipv4.conf.all.send_redirects=0

sysctl -w net.ipv4.conf.all.accept_source_route=0

sysctl -w net.ipv4.conf.all.rp_filter=1

sysctl -p
