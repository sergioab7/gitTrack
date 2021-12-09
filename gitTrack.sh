#!/bin/bash


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


trap ctr_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Exiting...${endColour}"; sleep 1
	tput cnorm; exit 1
}


function banner(){
figlet gitTrack
echo -e "\t${purpleColour} xaxxjs | https://sergioab7.github.io ${endColour}"
}


function buscar_user(){
	tput civis
	banner
	echo -e "\n\n${greenColour}[+]${endColour}${yellowColour} Name${endColour}: $user [$(curl -s https://github.com/$user | html2text | grep -i 'overview' -A 1 | head -n 2 | tail -n 1 | awk '{print $1}' | tr -d '[]')]"
	for i in {1..40}; do echo -n "*";done
	echo -e "\n${greenColour}[+]${endColour}${yellowColour} Followers${endColour}: $(curl -s https://github.com/$user | html2text | grep -i 'Followers' | awk '{print $1}' | tr -d '_' | sed -s 's/followers/ /')"
	for i in {1..40}; do echo -n "*";done
	echo -e "\n${greenColour}[+]${endColour}${yellowColour} Following${endColour}: $(curl -s https://github.com/$user | html2text | grep -i 'Followers' | awk '{print $3}' | tr -d '_' | sed 's/following/ /')"
	for i in {1..40}; do echo -n "*";done
        echo -e "\n${greenColour}[+]${endColour}${yellowColour} From${endColour}: $(curl -s https://github.com/$user | html2text | grep -i 'followers' -A 1 | tail -n 1 | tr -d '*' | sed -s 's/^ *//')"
	for i in {1..40}; do echo -n "*";done
        echo -e "\n${greenColour}[+]${endColour}${yellowColour} URL${endColour}: $(curl -s https://github.com/$user | html2text | grep -i 'followers' -A 2 | tail -n 1 | tr -d '*' | sed 's/^ *//')"
	for i in {1..40}; do echo -n "*";done
	echo -e "\n${greenColour}[+]${endColour}${yellowColour} Repos${endColour}: "
	count=1
	#echo -e "\n"
	for i in $(curl -s https://github.com/$user?tab=repositories | html2text | grep -i 'Public' | tr -d '*' | sed 's/^ *//' | awk '{print $1}'); do
		echo -e -n "\t\t${blueColour}[$count]${endColour} $i\t" && echo -n -e "${purpleColour}[★]${endColour}$(curl -s https://github.com/$user/$i | html2text | grep -i -E 'Star|fork' | head -n 3 | tail -n 2 | awk '{print $3}' | head -n 1) ${purpleColour}[☇]${endColour}$(curl -s https://github.com/$user/$i | html2text | grep -i -E 'Star|fork' | head -n 3 | tail -n 2 | awk '{print $3}' | tail -n 1)\n"
		let count+=1 
	done


	tput cnorm
}

function helpPanel(){
	echo -e "\n\t${greenColour}[+]${endColour} ./gittrack.sh -u <user>"
	exit 1

}

declare -i parameter=0; while getopts ":u:h:" arg; do
	case $arg in
		u) user=$OPTARG; let parameter+=1;;
		h) helpPanel;; 
	esac
done

if [ $parameter -eq 0 ]; then
	echo -e "\n${redColour}[-]${endColour} You must put the parameter -u."
	helpPanel
else
	if [ $parameter -eq 1 ];then
		existe=$(curl -s -I "https://github.com/$user" | head -n 1 | awk '{print $2}')
		if [ $existe == 200 ]; then
			buscar_user $user
		else
			echo -e "\n${redColour}[-]${endColour} Username doesn't exist."
		fi
	fi
fi
