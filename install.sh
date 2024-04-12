#!/bin/bash

# Update packages list and update system
sudo apt update
sudo apt upgrade -y

# Making .config and Moving config files and background to Pictures
git clone --bare https://github.com/kayodevital/.dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
mkdir -p .dotfiles-backup && \
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .dotfiles-backup/{}
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
xdg-user-dirs-update
git clone https://github.com/kayodevital/wallpapers.git

# Installing Essential Programs 
sudo apt install pcmanfm nitrogen lxpolkit x11-xserver-utils unzip wget pipewire xfce4-power-manager network-manager network-manager-gnome pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev alsa-utils pulseaudio xorg-dev zathura ffpmeg imagemagick mpv firefox-esr sxiv syncthing pamixer dunst acpi acpid avahi-daemon dialog mtools dosfstools gvfs-backends xinput intel-microcode simple-scan bluez cups xorg xbacklight xbindkeys xvkbd -y
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid
sudo systemctl enable cups
sudo systemctl enable bluetooth
# Installing Other less important Programs
sudo apt install neofetch psmisc vim nvim lxappearance fonts-noto-color-emoji lightdm redshift-gtk slick-greeter xfce4-screenshooter libnotify-dev libnotify-bin dunst wmctrl -y

# Download Theme
sudo apt install arc-theme papirus-icon-theme -y
wget -q0- https://git.io/papirus-icon-theme-install | sh
wget -q0- https://git.io/papirus-folders-theme-install | sh
papirus-folders -C cyan --theme ePapirus

# Installing fonts
sudo apt install fonts-font-awesome fonts-liberation fonts-ubuntu fonts-recommended -y
sudo apt install exa -y

# Reloading Font
fc-cache -vf

# Install cursor
sudo apt install dmz-cursor-theme -y

# Install librewolf-browser
sudo apt update && sudo apt install -y wget gnupg lsb-release apt-transport-https ca-certificates

distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo focal; fi)

wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg

sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

sudo apt update

sudo apt install librewolf -y

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
systemctl set-default graphical.target

mkdir ~/.config/suckless

# DWM Setup
cd ~/.config/suckless
git clone https://github.com/kayodevital/dwm.git
cd dwm
sudo make clean install
cp dwm.desktop /usr/share/xsessions

# st setup
cd ~/.config/suckless
git clone https://github.com/kayodevital/st.git
cd st
sudo make clean install

# slstatus setup
cd ~/.config/suckless
git clone https://github.com/kayodevital/slstatus.git
cd slstatus
sudo make clean install

# dmenu setup
cd ~/.config/suckless
git clone https://git.suckless.org/dmenu
cd dmenu
sudo make clean install

sudo apt autoremove
