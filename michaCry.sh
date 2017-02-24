#!/bin/bash 
clear

##set the prompt to show you are in pentmenu and not standard shell
PS3="MiCha Cry>"


##User Validation
user=`id | cut -d" " -f1 | cut -d"(" -f2 | cut -d")" -f1`
if [ "$user" != "root" ] 
then
	echo -e "\e[1m\e[31mNOTE: You don't have admin privilegies, execute the script as root.\e[0m\e[0m"
	exit 0
fi


##MENU
mainmenu(){
#banner
echo -e """\e[1m\e[31m
      ======================================================================
     |          __  __ ___ ____ _   _    _       ____ ______   __	    |
     |         |  \/  |_ _/ ___| | | |  / \     / ___|  _ \ \ / /	    |
     |         | |\/| || | |   | |_| | / _ \   | |   | |_) \ V / 	    |
     |         | |  | || | |___|  _  |/ ___ \  | |___|  _ < | |  	    |
     |         |_|  |_|___\____|_| |_/_/   \_\  \____|_| \_\|_|  	    |
     |          							    |
     |	#Coded by Wreckit-Kenny | @wreckitkenny | https://wreckitkenny.net  |
      ======================================================================
\e[0m\e[0m"""
mainmenu=("Web Application" "Wireless Attack" "Personal Computer" "Sniffing & Spoofing" "Password Attack"  "Quit")
select opt in "${mainmenu[@]}"
do
	if [ "$opt" = "Quit" ]
	then
		clear
		figlet -c Thank You ! ! !
		exit 0
	elif [ "$opt" = "Web Application" ]
	then
		clear
		figlet -c Web Application
		bash webApp.sh
	elif [ "$opt" = "Wireless Attack" ]
	then
		clear
		bash wireless.sh
	elif [ "$opt" = "Personal Computer" ]
	then
		bash personalCom.sh
	elif [ "$opt" = "Sniffing & Spoofing" ]
	then
		echo "COMING SOON !!!"
	elif [ "$opt" = "Password Attack" ]
	then
		echo "COMING SOON !!!"
	fi
done
}

#Deploy Functions
if [ -d webApp ]
then
	mainmenu
else
	echo -e "\e[31m\e[1mNOTE: bash setup.sh with ROOT\e[0m\e[0m"
fi



