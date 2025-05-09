#!/bin/bash

DISTRO=$(lsb_release -i | awk -F: '{print $2}' | xargs)

if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [ "$ID" == "arch" ]; then
        DISTRO="Arch"
    # elif [[ "$ID" == "ubuntu"  || "$ID" == "pop" ]]; then
    #     DISTRO="Debian"
    # fi
fi



echo ""
echo "Installing packages"
sleep 3
echo ""

mkdir -p Installation
cd Installation
sleep 3

echo "Full system upgrade"
sleep 3
if [[ "$DISTRO" == 'Arch' ]]; then
   sudo pacman -Syu --noconfirm

elif [[ "$DISTRO" == 'Ubuntu' || "$DISTRO" == 'Pop' ]]; then
    sudo apt update && sudo apt upgrade -y
elif [[ "$DISTRO" == 'Fedora' ]]; then
    sudo dnf update -y && sudo dnf upgrade -y
fi
sleep 3



echo "Installing system essentials"
sleep 3

if [[ "$DISTRO" == 'Ubuntu' || "$DISTRO" == 'Pop' ]]; then
    sudo apt install -y preload ubuntu-drivers-common vlc virtualbox libfuse2 gnome-tweaks ntfs-3g



echo "Installing auto-cpufreq"
sleep 3
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
if [ $? -eq 0 ]; then
    echo "Auto CPU Frequency Installed"
fi
cd ..

echo "Installing OpenSnitch"
sleep 3
sudo apt install -y git wget curl python3 python3-pip gdebi-core
wget http://ftp.us.debian.org/debian/pool/main/p/python-slugify/python3-slugify_2.0.1-1_all.deb
sudo dpkg -i python3-slugify_2.0.1-1_all.deb
wget http://ftp.us.debian.org/debian/pool/main/libn/libnetfilter-queue/libnetfilter-queue1_1.0.3-1_amd64.deb
sudo dpkg -i libnetfilter-queue1_1.0.3-1_amd64.deb
wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.7/python3-opensnitch-ui_1.6.7-1_all.deb
wget https://github.com/evilsocket/opensnitch/releases/download/v1.6.6/opensnitch_1.6.6-1_amd64.deb
sudo dpkg -i opensnitch_1.6.6-1_amd64.deb python3-opensnitch-ui_1.6.7-1_all.deb
sudo apt -f install -y
if [ $? -eq 0 ]; then
    echo "OpenSnitch Installed"
fi

if [[ "$DISTRO" == 'Ubuntu' || "$DISTRO" == 'Pop' ]]; then
    echo "Applying Fixes"
    pip3 install grpcio==1.41.0 protobuf==3.19.0
fi

echo "Installing Flatpak applications"
sleep 3
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.jetbrains.IntelliJ-IDEA-Community com.redis.RedisInsight com.visualstudio.code com.protonvpn.www com.getpostman.Postman com.mongodb.Compass com.usebottles.bottles

echo "Applying GSettings"
sleep 3
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
if [ $? -eq 0 ]; then
    echo "GSettings Applied"
fi

echo "Removing Unnecessary Services"
sudo apt remove -y avahi-daemon cups samba dnsmasq bind9-dnsutils

case "$DISTRO" in
    Deepin)
        echo "Removing Deepin telemetry"
        sudo apt remove -y uos-ai deepin-app-store deepin-home-appstore-daemon dde-crypto deepin-movie deepin-music \
                            com.deepin.gomoku com.deepin.lianliankan deepin-feedback deepin-sync-daemon deepin-deepinid-client \
                            deepin-home dde-cooperation dde-cooperation-daemon dde-cooperation-transfer \
                            deepin-app-store-runtime deepin-upgrade-manager geoclue-2.0
        sudo apt autoremove -y && sudo apt clean
        ;;
    Ubuntu)
        echo "Ubuntu detected"
        read -p "Do you want to remove Snap and snapd? (y/N): " CHOICE
        if [[ "$CHOICE" =~ ^[Yy]$ ]]; then
            sudo snap remove snapd-desktop-integration snap-store gtk-common-themes firefox
            sudo snap list | awk '/gnome/ {print $1}' | xargs --no-run-if-empty sudo snap remove
            sudo snap list | awk '/core/ {print $1}' | xargs --no-run-if-empty sudo snap remove
            sudo snap remove core20 bare
            sudo apt remove -y snapd
        fi
        sudo install -d -m 0755 /etc/apt/keyrings
        wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
        echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
        echo -e "Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n\nPackage: firefox*\nPin: release o=Ubuntu\nPin-Priority: -1" | sudo tee /etc/apt/preferences.d/mozilla
        sudo apt update && sudo apt remove -y firefox && sudo apt install -y firefox
        ;;
    *)
        echo "Unrecognized Linux distribution ❓"
        ;;
esac

echo "Cleaning up installation files"
cd ..
rm -rf Installation
