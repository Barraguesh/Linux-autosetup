#!/bin/bash
#
#I reset my devices so much that I got tired and tried to automate most of the install, hope to not
#distro hop, because it will be a pain in the ass to research new issues to automate the fixing
#
#Script by Barraguesh. Text made with https://fsymbols.com/generators/tarty/
#
echo 'Fullscreen is recommended for readability'
sleep 2
echo '
░█████╗░██╗░░░██╗████████╗░█████╗░░██████╗███████╗████████╗██╗░░░██╗██████╗░  ██╗░░░██╗██████╗░░░░░░███╗░░
██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██║░░░██║██╔══██╗  ██║░░░██║╚════██╗░░░░████║░░
███████║██║░░░██║░░░██║░░░██║░░██║╚█████╗░█████╗░░░░░██║░░░██║░░░██║██████╔╝  ╚██╗░██╔╝░█████╔╝░░░██╔██║░░
██╔══██║██║░░░██║░░░██║░░░██║░░██║░╚═══██╗██╔══╝░░░░░██║░░░██║░░░██║██╔═══╝░  ░╚████╔╝░░╚═══██╗░░░╚═╝██║░░
██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██████╔╝███████╗░░░██║░░░╚██████╔╝██║░░░░░  ░░╚██╔╝░░██████╔╝██╗███████╗
╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═════╝░╚══════╝░░░╚═╝░░░░╚═════╝░╚═╝░░░░░  ░░░╚═╝░░░╚═════╝░╚═╝╚══════╝
'
sleep 5
mkdir /tmp/AutoSetup
cd /tmp/AutoSetup
echo '
█▀▀ █▀█ █▄░█ █▀▀ █ █▀▀ █░█ █▀█ █ █▄░█ █▀▀   ▄▀█ █▄░█ █▀▄   █▀█ █▀█ ▀█▀ █ █▀▄▀█ █ ▀█ █ █▄░█ █▀▀
█▄▄ █▄█ █░▀█ █▀░ █ █▄█ █▄█ █▀▄ █ █░▀█ █▄█   █▀█ █░▀█ █▄▀   █▄█ █▀▀ ░█░ █ █░▀░█ █ █▄ █ █░▀█ █▄█
'
sudo dnf upgrade --refresh -y
read -p 'Are you using a NVIDIA card? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf install akmod-nvidia -y
    sudo dnf install xorg-x11-drv-nvidia-cuda -y
fi
read -p 'Is this a laptop? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo dnf install tlp tlp-rdw -y
    sudo tlp start
fi
read -p 'Install Fastboot and ADB for LineageOS/developer support? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo dnf install adb fastboot -y
fi
read -p 'Install Docker? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sleep 10
fi
read -p 'Setup undervolt? (Intel only) (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git clone https://github.com/kitsunyan/intel-undervolt.git
    cd ./intel-undervolt
    ./configure && sudo make && sudo make install
    sudo nano /etc/intel-undervolt.conf
    sleep 5
    sudo intel-undervolt apply
    sudo intel-undervolt read
    cd ..
fi
#Flatpak support
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#Multiple rar support for file extract
sudo dnf install unrar -y
#ClamAV and freshclam
sudo dnf install clamav clamav-update -y
sudo service clamav-freshclam start
#Git credentials
sudo dnf install git -y
git config --global user.email "25356150+Barraguesh@users.noreply.github.com"
git config --global user.name "Barraguesh"
read -p 'Setup auto updates? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo dnf install dnf-automatic -y
    sudo env EDITOR='gedit -w' sudoedit /etc/dnf/automatic.conf
    sleep 5
    systemctl enable --now dnf-automatic.timer
fi
read -p 'Are you going to or dualbooting Windows? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    timedatectl set-local-rtc 1 --adjust-system-clock
fi
read -p 'Install NextDNS client? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sh -c "$(curl -sL https://nextdns.io/install)"
fi
echo '
█▀▀ █▄░█ █▀█ █▀▄▀█ █▀▀   █▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀ █▀
█▄█ █░▀█ █▄█ █░▀░█ ██▄   ▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█ ▄█
'
#Use "dconf watch /" and use tweaks/tools to see changes and create commands
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.interface font-name 'Liberation Sans 12'
gsettings set org.gnome.desktop.interface document-font-name 'Liberation Sans 12'
gsettings set org.gnome.desktop.interface monospace-font-name 'Liberation Mono 12'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Liberation Sans Bold 12'
gsettings set org.gnome.desktop.interface text-scaling-factor 1.1000000000000001
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.session idle-delay "uint32 600"
dconf write /org/gtk/settings/file-chooser/sort-directories-first true
#Night light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature "uint32 1700"
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
#Dock personalization (gsettings get org.gnome.shell favorite-apps)
gsettings set org.gnome.shell favorite-apps "['terminator.desktop', 'org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.standardnotes.standardnotes.desktop', 'com.valvesoftware.Steam.desktop', 'com.stremio.Stremio.desktop', 'org.signal.Signal.desktop', 'com.obsproject.Studio.desktop', 'org.pitivi.Pitivi.desktop']"
echo 'Settings applied.'
read -p 'Set up themes? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo '
    █▀ █▀▀ ▀█▀ ▀█▀ █ █▄░█ █▀▀   █░█ █▀█   ▀█▀ █░█ █▀▀ █▀▄▀█ █▀▀ █▀
    ▄█ ██▄ ░█░ ░█░ █ █░▀█ █▄█   █▄█ █▀▀   ░█░ █▀█ ██▄ █░▀░█ ██▄ ▄█
    '
    #Shell, use default
    #Applications and Flatpak support
    sudo dnf install arc-theme -y
    sudo flatpak install flathub org.gtk.Gtk3theme.Arc-Dark -y
    gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"
    #Icons
    sudo dnf install papirus-icon-theme -y
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    #Papirus folders for custom folder colors
    wget -qO- https://git.io/papirus-folders-install | sh
    papirus-folders -C teal
    #Cursor
    git clone https://github.com/mustafaozhan/Breeze-Adapta-Cursor.git
    sudo cp -R ./Breeze-Adapta-Cursor /usr/share/icons/Breeze\ Adapta
    gsettings set org.gnome.desktop.interface cursor-theme "Breeze Adapta"
    echo 'Sifr (dark) is the recommended icon theme for Libreoffice with dark themes)'
    sleep 10
fi
read -p 'Set up extensions? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo '
    █▀█ █▀▀ █▀▀ █▀█ █▀▄▀█ █▀▄▀█ █▀▀ █▄░█ █▀▄ █▀▀ █▀▄   █▀▀ ▀▄▀ ▀█▀ █▀▀ █▄░█ █▀ █ █▀█ █▄░█ █▀
    █▀▄ ██▄ █▄▄ █▄█ █░▀░█ █░▀░█ ██▄ █░▀█ █▄▀ ██▄ █▄▀   ██▄ █░█ ░█░ ██▄ █░▀█ ▄█ █ █▄█ █░▀█ ▄█
    '
    sleep 5
    firefox 'https://extensions.gnome.org/extension/3843/just-perfection/'
    firefox 'https://extensions.gnome.org/extension/2890/tray-icons-reloaded/'
    firefox 'https://extensions.gnome.org/extension/2072/skip-window-ready-notification/'
    firefox 'https://extensions.gnome.org/extension/906/sound-output-device-chooser/'
    firefox 'https://extensions.gnome.org/extension/2182/noannoyance/'
    firefox 'https://extensions.gnome.org/extension/307/dash-to-dock/'
    firefox 'https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/'
    firefox 'https://extensions.gnome.org/extension/945/cpu-power-manager/'
fi
read -p 'Install apps? (y/N) ' -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo '
    █ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░ █ █▄░█ █▀▀   ▄▀█ █▀█ █▀█ █▀
    █ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄ █ █░▀█ █▄█   █▀█ █▀▀ █▀▀ ▄█
    '
    sleep 5
    #Terminal apps
    sudo dnf install neofetch -y
    sudo dnf install gnome-tweak-tool  -y
    sudo dnf install terminator -y
    sudo dnf install htop -y
    #VS Code
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code
    #Non terminal installable apps
    firefox 'https://www.veracrypt.fr/en/Downloads.html'
    firefox 'https://cryptomator.org/downloads/'
    #Appimage installer
    firefox 'https://github.com/TheAssassin/AppImageLauncher/releases'
    #Flatpak apps
    sudo flatpak install flathub com.obsproject.Studio -y
    sudo flatpak install flathub com.tutanota.Tutanota -y
    sudo flatpak install flathub com.stremio.Stremio -y
    sudo flatpak install flathub com.github.philip_scott.spice-up -y
    sudo flatpak install flathub org.videolan.VLC -y
    #sudo flatpak install flathub org.kde.kdenlive -y
    sudo flatpak install flathub org.pitivi.Pitivi -y
    sudo flatpak install flathub fr.romainvigier.MetadataCleaner -y
    sudo flatpak install flathub org.standardnotes.standardnotes -y
    sudo flatpak install flathub org.chromium.Chromium -y
    sudo flatpak install flathub org.telegram.desktop -y
    sudo flatpak install flathub com.belmoussaoui.Obfuscate -y
    sudo flatpak install flathub org.signal.Signal -y
    sudo flatpak install flathub org.fedoraproject.MediaWriter -y
    sudo flatpak install flathub com.valvesoftware.Steam -y
    sudo flatpak install flathub dev.alextren.Spot -y
    sudo flatpak install flathub com.transmissionbt.Transmission -y
    sudo flatpak install flathub org.glimpse_editor.Glimpse -y
    sudo flatpak install flathub com.github.tchx84.Flatseal -y
    sudo flatpak install flathub org.gnome.Extensions -y
fi
cd /tmp
sudo rm -rf AutoSetup
echo '
███╗░░░███╗░█████╗░░█████╗░██╗░░██╗██╗███╗░░██╗███████╗  ██████╗░███████╗░█████╗░██████╗░██╗░░░██╗
████╗░████║██╔══██╗██╔══██╗██║░░██║██║████╗░██║██╔════╝  ██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗░██╔╝
██╔████╔██║███████║██║░░╚═╝███████║██║██╔██╗██║█████╗░░  ██████╔╝█████╗░░███████║██║░░██║░╚████╔╝░
██║╚██╔╝██║██╔══██║██║░░██╗██╔══██║██║██║╚████║██╔══╝░░  ██╔══██╗██╔══╝░░██╔══██║██║░░██║░░╚██╔╝░░
██║░╚═╝░██║██║░░██║╚█████╔╝██║░░██║██║██║░╚███║███████╗  ██║░░██║███████╗██║░░██║██████╔╝░░░██║░░░
╚═╝░░░░░╚═╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝╚══════╝  ╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░
'
echo 'Restarting is recommended'
