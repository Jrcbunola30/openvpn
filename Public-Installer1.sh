#!/bin/bash
# Script by Juan
set +o history && history -cw > /dev/null 2>&1

function isRoot() {
	if [ "$EUID" -ne 0 ]; then
  echo "You are not root user"  | lolcat
		return 1
	fi
}

function tunAvailable() {
	if [ ! -e /dev/net/tun ]; then
  echo "TUN is not detected"  | lolcat
		return 1
	fi
}

read -p "Enter SSH Response: " SSH
read -p "Enter Websocket Response: " WS

export DEBIAN_FRONTEND=noninteractive
export RepoURL='Jrcbunola30/openvpn/main'

IPADDR="$(curl -4skL http://ipinfo.io/ip)"

function checkOS() {
apt-get update
apt install ruby -y
wget https://github.com/busyloop/lolcat/archive/master.zip
unzip master.zip
cd lolcat-master/bin
gem install lolcat
cd

if [[ $(curl -4skL http://ipinfo.io/org | grep 'AS') == *DigitalOcean* ]]; then
  echo "DIGITAL OCEAN IS YOUR PROVIDER" | lolcat
fi
if [[ $(curl -4skL http://ipinfo.io/org | grep 'AS') == *Akamai* ]]; then
  echo "LINODE IS YOUR PROVIDER" | lolcat
fi
if [[ $(curl -4skL http://ipinfo.io/org | grep 'AS') == *Amazon* ]]; then
  echo "AWS IS YOUR PROVIDER" | lolcat
fi
if [[ $(curl -4skL http://ipinfo.io/org | grep 'AS') == *Azure* ]]; then
  echo "AZURE IS YOUR PROVIDER" | lolcat
fi

if [[ -e /etc/debian_version ]]; then
		OS="debian"
		source /etc/os-release

	if [[ $ID == "debian" || $ID == "raspbian" ]]; then
        if [[ $VERSION_ID == 10 ]]; then
            echo "deb http://deb.debian.org/debian/ buster main
deb-src http://deb.debian.org/debian/ buster main
deb http://deb.debian.org/debian/ buster-updates main
deb-src http://deb.debian.org/debian/ buster-updates main
deb http://security.debian.org/debian-security buster/updates main
deb-src http://security.debian.org/debian-security buster/updates main
deb http://deb.debian.org/debian buster-backports main
deb-src http://deb.debian.org/debian buster-backports main" > /etc/apt/sources.list
        fi
        if [[ $VERSION_ID == 11 ]]; then
            echo "deb http://deb.debian.org/debian bullseye main
deb-src http://deb.debian.org/debian bullseye main
deb http://security.debian.org/debian-security bullseye-security main
deb-src http://security.debian.org/debian-security bullseye-security main
deb http://deb.debian.org/debian bullseye-updates main
deb-src http://deb.debian.org/debian bullseye-updates main
deb http://deb.debian.org/debian bullseye-backports main
deb-src http://deb.debian.org/debian bullseye-backports main" > /etc/apt/sources.list
        fi
		apt-get update
		apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
		apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
		echo 'clear
screenfetch -p -A Debian
set +o history && history -cw > /dev/null 2>&1' > /etc/profile.d/juans.sh && > /dev/null 2>&1
		chmod +x /etc/profile.d/*
	elif [[ $ID == "ubuntu" ]]; then
		apt update
      	apt upgrade -y
      	echo 'clear
screenfetch -p -A Ubuntu
set +o history && history -cw > /dev/null 2>&1' > /etc/profile.d/juans.sh && > /dev/null 2>&1
			chmod +x /etc/profile.d/*
	fi
else
	echo "Looks like you aren't running this installer on a Debian or Ubuntu Linux system"  | lolcat
	exit 1
fi

}

xUpdate(){
    echo -e "Upgrading repositories...." | lolcat
    apt-get install zip tar netcat dos2unix screen software-properties-common net-tools lolcat \
    build-essential libtool pkg-config python openssl libncurses5-dev libgdbm-dev \
    autoconf cmake vnstat checkinstall libsystemd-dev libssl-dev liblzo2-2 \
    liblzo2-dev zlib1g zlib1g-dev libnss3 libnss3-dev libpcre3 libreadline-dev \
    libpcre3-dev libpam0g libpam0g-dev libcppunit-dev libcap-dev libffi-dev lsof gnupg \
    dropbear stunnel ca-certificates apt-transport-https lsb-release squid screenfetch -yf
    apt-get autoremove -y
    wget -qO /etc/banner https://github.com/yakult13/parte/raw/main/cafe && dos2unix -q /etc/banner
    timedatectl set-timezone Asia/Manila > /dev/null 2>&1
    echo -e "0 0 * * *\troot\t/sbin/shutdown -r now" > /etc/cron.d/fcafe-reboot-daily
    rm -rf *
    clear
    F1='/etc/modules-load.d/modules.conf' && { [[ $(grep -cE '^tcp_bbr$' $F1) -ge 1 ]] && echo "bbr already added" || echo "tcp_bbr" >> "$F1"; } && modprobe tcp_bbr
    F2='net.core.default_qdisc' && F3='net.ipv4.tcp_congestion_control' && sed -i "/^$F2.*/d;/^$F3.*/d" /etc/sysctl{.conf,.d/*.conf} && echo -e "${F2}=fq\n${F3}=bbr" >> /etc/sysctl.d/98-bbr.conf && sysctl --system &>/dev/null
}

xInstall(){
    rm -rf /etc/apt/sources.list.d/openvpn*
    echo "deb http://build.openvpn.net/debian/openvpn/stable $(lsb_release -sc) main" > /etc/apt/sources.list.d/openvpn.list
 wget -qO - http://build.openvpn.net/debian/openvpn/stable/pubkey.gpg|apt-key add -
    apt-get update
    apt-get install openvpn -y
    mkdir -p /etc/ins
    cd /etc/ins
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/SSH"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Dropbear"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Squid"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Stunnel"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/OpenVPN"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Configs"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Firewall"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Menu"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Websocket"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/OHP"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/Nginx"
    curl -skLO -H "https://raw.githubusercontent.com/${RepoURL}/CreateDNS"
    chmod +x *
     echo -e "Setting up SSH" | lolcat
     ./SSH
     echo -e "Setting up Dropbear" | lolcat
     ./Dropbear
     echo -e "Setting up Squid" | lolcat
     ./Squid
     echo -e "Setting up Stunnel" | lolcat
     ./Stunnel
     echo -ne "Setting up OpenVPN"| lolcat
     ./OpenVPN
     echo -e "Setting up Configs" | lolcat
     ./Configs
     echo -e "Setting up Firewall" | lolcat
     ./Firewall
     echo -e "Setting up Menu" | lolcat
     ./Menu
     echo -e "Setting up Websocket"| lolcat
     ./Websocket
     echo -e "Setting up OHP-Server"| lolcat
     ./OHP
     echo -e "Setting up Nginx"| lolcat
     ./Nginx
     echo -e "Setting up DNS"| lolcat
     ./CreateDNS
    rm -rf *
    clear
    cd
    rm -rf *
}

isRoot
tunAvailable
checkOS
xUpdate
xInstall
apt autoclean
rm -rf *
sed -i "s|Freenet Cafe|${SSH}|g" /etc/ssh/sshd_config
sed -i "s|Freenet Cafe|${WS}|g" /var/local/80.py
systemctl restart systemd-journal2.service
systemctl restart ssh

clear
bash /etc/profile.d/juans.sh
echo -e "Command: menu" | lolcat
echo -e ""
echo -e "OpenSSH: 22, 225" | lolcat
echo -e "Stunnel: 443" | lolcat
echo -e "Dropbear: 550, 555" | lolcat
echo -e "OpenVPN: 110(TCP), 1194(UDP)" | lolcat
echo -e "Squid: 8000, 8080" | lolcat
echo -e "Websocket: 80" | lolcat
echo -e "OHP+Dropbear: 8085" | lolcat
echo -e "OHP+Stunnel: 8089" | lolcat
echo -e "OHP+OpenSSH: 8086" | lolcat
echo -e "OHP+OpenVPN(tcp): 8087" | lolcat
echo -e "OHP+OpenVPN(udp): 8088" | lolcat
echo -ne "SSH DNS: " | lolcat && cat /etc/dnsinfo/cdn.txt | lolcat
echo -ne "WS DNS: " | lolcat && cat /etc/dnsinfo/websocket_cdn.txt | lolcat
echo -e ""
echo -e "http://$(wget -4qO- http://ipinfo.io/ip):86/tcp.ovpn" | lolcat
echo -e "http://$(wget -4qO- http://ipinfo.io/ip):86/udp.ovpn" | lolcat
echo -e "http://$(wget -4qO- http://ipinfo.io/ip):86/OHPTCPConfig.ovpn" | lolcat
echo -e "http://$(wget -4qO- http://ipinfo.io/ip):86/OHPTCPConfig2.ovpn" | lolcat
echo -e ""
echo -e "JuanScript" | lolcat
echo -e "Strictly Not For Sale" | lolcat
rm -rf /{var,run}/log/{journal/*,lastlog}; history -w -c; rm -f ~/.bash_history
exit
