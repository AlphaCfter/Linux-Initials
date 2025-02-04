#!/bin/bash

echo ""
echo "Installing packages"
echo ""

echo ""
echo "Creating temporary folder"
mkdir ~/Desktop/Installation
cd ~/Desktop/Installation
echo ""

echo ""
echo "Full system upgrade"
sudo apt update
sudo apt upgrade -y
echo ""

echo ""
echo "System Essencials"
sudo apt install preload
sudo apt install ubuntu-drivers-extras
sudo apt install vlc virtualbox libfuse2
sudo apt upgrade -y
echo ""


echo "Installing autocpu freq"
echo ""
sudo apt install git wger curl ntfs-3g
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
if [ -$? -eq 0 ]; then
	echo "Autocpu Freq Installed"
fi

echo "Installing opensnitch"
echo ""
sudo apt install git wget curl python3 python3-pip
wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.7/python3-opensnitch-ui_1.6.7-1_all.deb
wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch_1.6.6-1_amd64.deb
sudo dpkg -i opensnitch_1.6.6-1_amd64.deb
sudo apt install -f
sudo dpkg -i python3-opensnitch-ui_1.6.7-1_all.deb
sudo apt install -f
pip3 install grpcio==1.41.0
pip3 install protobuf==3.19.0
if [ -$? -eq 0 ]; then
	echo "Opensnitch Installed"
fi

echo "Flatpak applications"
echo ""
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo ""
echo "Flatpak repository added"
echo ""
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community -y
flatpak install flathub com.redis.RedisInsight -y
flatpak install flathub com.visualstudio.code -y
flatpak install flathub com.protonvpn.www -y
flatpak install flathub com.getpostman.Postman -y
flatpak install flathub com.mongodb.Compass -y
flatpak install flathub com.usebottles.bottles -y

echo "Miscellaneous applications"
echo ""
sudo apt install git wget curl python3 python3-pip
wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.7/python3-opensnitch-ui_1.6.7-1_all.deb
wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch_1.6.6-1_amd64.deb
sudo dpkg -i opensnitch_1.6.6-1_amd64.deb
sudo apt install -f
sudo dpkg -i python3-opensnitch-ui_1.6.7-1_all.deb
sudo apt install -f
pip3 install grpcio==1.41.0
pip3 install protobuf==3.19.0
if [ -$? -eq 0 ]; then
	echo "Opensnitch Installed"
fi

echo ""
echo "GSettings"
echo ""
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
if [ -$? -eq 0 ]; then
	echo "GSettings applied"
fi
