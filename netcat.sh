#!/bin/sh

exec="$0"

usage()
{
# The message block.
cat<<EOF

USAGE: 
	$exec <interface> <IP> <port> [filter ...]
	
DESCRIPTION:
	The script conveys the packets which captured from the device to
	the server side.

EXAMPLE:
	The client side:
		$exec eth0 192.168.0.1 8888
	The server side:
		nc -l 8888 | wireshark -k -i -

OPTIONS:
	interface      -  the names of the active network interfaces
	IP             -  the ip address of the destination
	port           -  the port number
	filter         -  the filter conditions for the packet
	                  (eg: not arp and ...)
	                  
EOF
}

# Show usage
if [ "$#" -lt 3 ]; then
	usage
	exit 1
fi

interface="$1"
ip="$2"
port="$3"
shift 3
filter="$*"

# tcpdump --> packet --> nc
echo "run command: tcpdump -s 0 -U -n -w - -i ${interface} ${filter} | nc ${ip} ${port}"
tcpdump -s 0 -U -n -w - -i "${interface}" "${filter}" | nc "${ip}" "${port}"
