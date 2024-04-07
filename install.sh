#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Making .config and Moving config files and background to Pictures
cd $builddir
git clone --bare https://github.com/kayodevital/.dotfiles.git $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
git clone https://github.com/kayodevital/wallpapers.git
#mkdir -p /home/$username/.config
#mkdir -p /home/$username/.fonts
#mkdir -p /home/$username/Pictures
#mkdir -p /home/$username/Pictures/backgrounds
#cp -R dotconfig/* /home/$username/.config/
#cp bg.jpg /home/$username/Pictures/backgrounds/
#mv user-dirs.dirs /home/$username/.config
#chown -R $username:$username /home/$username

# Installing Essential Programs 
apt install pcmanfm nitrogen lxpolkit x11-xserver-utils unzip wget pipewire xfce4-volumed xfce4-power-manager nm-applet pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev libx11-xcb-dev libxcb-res0-dev -y
# Installing Other less important Programs
apt install neofetch flameshot psmisc vim lxappearance fonts-noto-color-emoji lightdm redshift-gtk xfce4-screenshooter -y

# Download Theme
apt install arc-theme -y
wget -q0- https://git.io/papirus-icon-theme-install | sh
wget -q0- https://git.io/papirus-folders-theme-install | sh
papirus-folders -C cyan --theme ePapirus

# Installing fonts
cd $builddir 
apt install fonts-font-awesome fonts-liberation fonts-ubuntu fonts-recommended -y

# Reloading Font
fc-cache -vf

# Install cursor
apt install dmz-cursor-theme -y

# Install librewolf-browser
#apt install librewolf -y

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
systemctl set-default graphical.target

# Enable wireplumber audio service
#sudo -u $username systemctl --user enable wireplumber.service

# DWM Setup
git clone https://github.com/kayodevital/dwm.git
cd dwm
make clean install
cp dwm.desktop /usr/share/xsessions
cd $builddir

# st setup
git clone https://github.com/kayodevital/st.git
cd st
make clean install
cd $builddir

# slstatus setup
git clone https://github.com/kayodevital/sltatus.git
cd slstatus
make clean install
cd $builddir

# dmenu setup
git clone https://git.suckless.org/dmenu
cd dmenu
make clean install
cd $builddir
