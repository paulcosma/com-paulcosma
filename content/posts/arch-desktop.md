---
title: "Arch Desktop"
date: 2023-04-02T21:33:11+03:00
draft: true
toc: true
tableOfContents:
    endLevel: 2
    ordered: false
    startLevel: 1
images:
tags: 
  - arch
  - kde
  - linux
---

# Desktop environment
## Prerequisites
If you did not install a GUI interface before reboot you can Use nmtui-connect to establish the internet and begin installing packages.<br>

Install a graphical desktop environment and video driver.<br>
> Xorg is the standard for window management (look for Wayland in the future)
```bash
# this will allow to install a desktop environment
pacman -S xorg-server

# Driver installation https://wiki.archlinux.org/title/Xorg
# install video driver depending on hardware that you have
# First, identify the graphics card (the Subsystem output shows the specific model):
lspci -v | grep -A1 -e VGA -e 3D
# Then, install an appropriate driver. You can search the package database for a complete list of open-source video drivers:
pacman -Ss xf86-video
# amd
pacman -S xf86-video-amdgpu
# intel
pacman -S xf86-video-intel

pacman -S mesa # for intel or amd gpu
pacman -S nvidia # if you have nvidia gpu if you installed the "linux" kernel
pacman -S nvidia-lts # if you have nvidia gpu if you installed the "linux-lts" kernel. OR both if you have installed both linux kernels.

pacman -S xf86-input-synaptics  # Synaptics driver for notebook touchpads

# For virtual box only
pacman -S virtualbox-guest-utils xf86-video-vmware
systemctl enable vboxservice
```

Now choose your preferred Desktop
## GNOME
```bash
pacman -S gnome
pacman -S gnome-tweaks
```
Enable display manager
```bash
systemctl enable gdm # enable the login screen to appear
```
Set language if the terminal does not open.<br>
- Region-Language - if Unspecified select a language and restart

## Plasma
```bash
pacman -S plasma-meta kde-applications
systemctl enable sddm
``` 
## Xfce
```bash
pacman -S xfce4 xfce4-goodies
pacman -S lightdm lightdm-gtk-greeter # install the display manager
systemctl enable lightdm
```
## MATE

## KDE + Wayland
This is my choice.
```bash
# Installing KDE Plasma desktop. 
# https://wiki.archlinux.org/title/KDE#Plasma
# A. the lightest version
pacman -S xorg plasma-meta plasma-wayland-session
# B. light version instead of “kde-applications-meta” add
#pacman -S xorg plasma-meta plasma-wayland-session kde-utilities-meta kde-accessibility-meta
# C. full version
#pacman -S xorg plasma-meta plasma-wayland-session kde-applications-meta

# other tools if you want to install https://archlinux.org/groups/
# Xorg group
# KDE Plasma Desktop Environment
# Wayland session for KDE Plasma
# KDE applications group (consists of KDE specific applications including the Dolphin manager and other useful apps)

# Enable the Display Manager and Network Manager services:
systemctl enable sddm.service
systemctl enable NetworkManager.service
```

# Desktop software
```bash
pacman -S bluez bluez-utils pipewire wget firefox neofetch
systemctl enable bluetooth.service
systemctl start bluetooth.service
```

# Pacman
Pacman is Arch package manager.
```bash
pacman --help
pacman -S --help
```
```bash
pacman -Ss # search for packages
pacman -Sy # update all packages
pacman -Syu # sysupgrade full system upgrade
pacman -Rs <package-name>  # remove app from system
```

## AUR
Arch User repositories
Install AUR packages with multiple install methods.
- Clone repository of the package and look for PKGBUILD file.
https://github.com/aur-archive
```bash
makepkg --help
makepkg -și
pacman -U package_file
```
- Aur helper extends pacman functionality
## YAY
```bash
# Install YAY
su paul
sudo pacman -S --needed git base-devel
mkdir -p ~/.apps/ 
cd ~/.apps/
git clone https://aur.archlinux.org/yay.git
# id # to find the user and groups.
# sudo chown -R paul:users ./yay
cd yay
makepkg -si
```
```bash
# Install a package
yay -S <package-name>
# Upgrade all the packages on your system
yay -Syu
# Remove a package using
yay -Rns <package-name>
```
### Programs and tools installed
AUR Apps
```bash
yay -S sublime-text-4
```
```bash
# OR
# Download tarball from https://www.sublimetext.com/download
mkdir -p ~/Apps
cd ~/Apps
wget https://download.sublimetext.com/sublime_text_build_4126_x64.tar.xz
tar -xvf sublime_text_build_4126_x64.tar.xz
cd sublime_text
sed -i.bak "s/\/opt/\/home\/paul\/Apps/g" sublime_text.desktop
cp sublime_text.desktop /usr/share/applications/
```

# Resources
https://octetz.com/docs/2020/2020-2-16-arch-windows-install/
https://github.com/joshrosso/linux-desktop
https://www.learnlinux.tv/arch-linux-full-installation-guide/
