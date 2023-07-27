#!/bin/bash
# Script by Juan
set +o history && history -cw > /dev/null 2>&1

# Public-Installer1.sh key for reference only - delete below! 
# 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

# Ansi color code variables
red="\e[0;91m"
blue="\e[0;94m"
green="\e[0;92m"
white="\e[0;97m"
reset="\e[0m"

rm -rf *
echo -e ""
echo -e "${green}Freenet Cafe Public-Script${reset}"
echo -e "${blue}Made by: Juan ${reset}"
echo -e ""
if [[ -e /etc/debian_version ]]; then
	OS="debian"
	source /etc/os-release
	if [[ $ID == "debian" || $ID == "raspbian" ]]; then
        if [[ $VERSION_ID == 10 ]]; then
            echo -e "${green}You Are Running Debian 10${reset}"
            prompt1="${blue}Enter Access Code${reset}:"
            echo -e "$prompt1"
            read TOKEN
            apt update
            apt install curl -y
            curl -skLO -H "Authorization: token ${TOKEN}" -H "Accept: application/vnd.github.v3.raw" "https://raw.githubusercontent.com/Jrcbunola30/openvpn/main/Public-Installer1.sh"
            chmod +x *
            if  grep -w 404 Public-Installer1.sh ; then
                echo -e "${red}Wrong Access Code${reset}"
                rm -rf *
                exit
            else
            ./Public-Installer1.sh
            fi
        fi
        if [[ $VERSION_ID == 11 ]]; then
            prompt2="${blue}Do you want to proceed (yes/no)?${reset}"
            echo -e "${green}You Are Running Debian 11${reset}"
            echo -e "${green}which have an error with ssl + proxy${reset}" 
            echo -e ""
            echo -e "$prompt2"
            read yn
            case $yn in 
                yes ) echo -e "${blue}ok, we will proceede.${reset}"
                prompt3="${blue}Enter Access Code${reset}:"
                echo -e "$prompt3"
                read TOKEN
                curl -skLO -H "Authorization: token ${TOKEN}" -H "Accept: application/vnd.github.v3.raw" "https://raw.githubusercontent.com/Jrcbunola30/openvpn/main/Public-Installer1.sh"
                chmod +x *
                if  grep -w 404 Public-Installer1.sh ; then
                    echo -e "${red}Wrong Access Code${reset}"
                    rm -rf *
                    exit
                else
                    ./Public-Installer1.sh
                    rm -rf *
                    exit
                fi
                ;;
                no ) echo -e "${red}exiting...${reset}";
                    exit;;
                * ) echo -e "${red}invalid response${reset}";
                    exit 1;;
            esac
        fi
    elif [[ $ID == "ubuntu" ]]; then
        prompt4=$( source /etc/os-release ; echo $VERSION_ID ; )
        echo -e "${blue}You Are Running Ubuntu $prompt4 ${reset}"
        prompt5="${blue}Enter Access Code${reset}:"
        echo -e "$prompt5"
        read TOKEN
        curl -skLO -H "Authorization: token ${TOKEN}" -H "Accept: application/vnd.github.v3.raw" "https://raw.githubusercontent.com/Jrcbunola30/openvpn/main/Public-Installer1.sh"
        chmod +x *
        if  grep -w 404 Public-Installer1.sh ; then
                echo -e "${red}Wrong Access Code${reset}"
                rm -rf *
                exit
            else
            ./Public-Installer1.sh
        fi
    fi
fi
rm -rf *
echo "rm -rf /{var,run}/log/{journal/*,lastlog}; history -w -c; rm -f ~/.bash_history" > /etc/profile.d/starts.sh
