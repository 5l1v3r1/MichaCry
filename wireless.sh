#!/bin/bash
user=`id | cut -d" " -f1 | cut -d"(" -f2 | cut -d")" -f1`

##set the prompt to show you are in pentmenu and not standard shell
PS3="Wireless Attack>"


###Web Application
##Sub1 Menu
submenu(){
echo ""
figlet -c Wireless Attack
echo "===================================== Wireless Attack =====================================" 
submenu=("Phishing Attack" "Back" "Quit")
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
	elif [ "$opt" = "Phishing Attack" ]
	then
		phinish
	fi
done
}

##Phishing Attack
phinish(){
clear
figlet -c Service Scanning
echo "===================================== Phishing with Fluxion ====================================="
cd wireless/fluxion/
bash fluxion
cd -
clear
submenu
}


##Deploy Script
submenu


