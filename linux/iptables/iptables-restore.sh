#! /bin/bash
iptables-restore < /etc/iptables/iptables.saved > /dev/null 2>&1 && today=$(date) ; echo $today iptables restored >> /var/log/iptables-restore.log
