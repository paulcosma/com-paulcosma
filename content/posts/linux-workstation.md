---
title: "Linux Dual Boot Workstation Setup"
date: 2023-03-23T21:28:46+02:00
draft: false
toc: true
tableOfContents:
    endLevel: 2
    ordered: false
    startLevel: 1
images:
tags: 
  - linux
  - arch
  - windows
  - encrypted
  - dual-boot
---

This is a Arch linux installation guide with multiple options.
Have a look at the table of content.

The setup that I am currenylt using is a Dual Boot Arch Linux and Windows 11 each with it's own encryption.

# Laptop

My old laptop needed a replacement as it was 8-9 years old.
I decided to buy a TUXEDO InfinityBook Pro 16 - Gen7 - Workstation Edition.

Specs:
- Display | 2560 x 1600 | 16:10 | 90Hz
- Intel Iris Xe Graphics G7 (96EUs) | Black casing
- Intel Core i7-12700H (max. 4.70GHz 14-Cores, 20 Threads, 24MB Cache, 45W TDP)
- 2 x 32 GB (1x 32GB) 3200MHz CL22 Samsung
- 1 TB Samsung 980 PRO (NVMe PCIe 4.0)
- 500 GB Samsung 980 (NVMe PCIe 3.0)
- Keyboard layout ENGLISH US ISO (EN-US international)
- Intel Wi-Fi 6 AX200 Series (802.11ax | 2,4 & 5 GHz | Bluetooth 5.2)

I will run Arch Linux on the 1TB drive as primary OS and Win11 on the second disk.<br>

Probably you are asking yourself "why on earth to install windows on a laptop specially build for linux?". I have no excuse, this is blasphemy.

# Installation guide
https://wiki.archlinux.org/title/installation_guide

## Bios setup
Bios configuration
- Disable Secure Boot
> You will need to __disable Secure Boot__ to boot the installation medium. If desired, __Secure Boot__ can be set up after completing the installation.
- Set Boot Mode to UEFI Only
> The installation image uses __systemd-boot__ for booting in UEFI mode and __syslinux__ for booting in BIOS mode.

## Setting up bootable media
Choose option A or B.
### (A) Bootable USB stick with Ventoy
[Ventoy](https://www.ventoy.net/en/doc_start.html) will allow you to have one USB with multiple iso files.<br>
[Ventoy releases](https://github.com/ventoy/Ventoy/releases)
- Install Ventoy
```bash
cd /tmp
wget https://github.com/ventoy/Ventoy/releases/download/v1.0.90/ventoy-1.0.90-linux.tar.gz
tar -xzvf ventoy-1.0.90-linux.tar.gz
lsblk
# get your disk and replace bellow. /dev/sde in my case.
sudo sh ventoy-1.0.90/Ventoy2Disk.sh -i -s /dev/sde
# or to upgrade
sudo sh ventoy-1.0.90/Ventoy2Disk.sh -u -s /dev/sde
# Or install using gui-mode
./VentoyGUI.x86_64
```
- Add Windows and Arch Linux images
```bash
mount /dev/sde1 /media/usb
cd /media/usb
wget http://mirrors.chroot.ro/archlinux/iso/2023.03.01/archlinux-2023.03.01-x86_64.iso
cp  /home/paul/Downloads/Win11_22H2_EnglishInternational_x64v1.iso /media/usb
```

#### (B) Create separate bootable disks
> If you do not want to use Ventoy you can create two bootable disks:
- Windows
```bash
# Format USB to FAT32 using the Disks utility in Ubuntu.
# Get the usb disk. /dev/sde in my case.
lsblk
sudo dd bs=4M if=/home/paul/Downloads/Win11_22H2_EnglishInternational_x64v1.iso of=/dev/sde conv=fdatasync status=progress
```
- Arch Linux
```bash
# Get .iso image.
# Insert a USB drive 
# List block devices and determine the device name. (usb will be something like /dev/sde)
# lsblk
# Create a bootable flash drive from that image (https://bztsrc.gitlab.io/usbimager/).
# or Write the ISO to the device using dd.
dd bs=4M if=/home/paul/Downloads/archlinux.iso of=/dev/sde status=progress oflag=sync
# dd: copies and converts a file based on arguments.
# bs: amount of bytes to write at a time.
# if: specify a file to read rather than stdin.
# of: specify a file to write to rather than stdout.
# status: level to log to stderr; progress shows periodic transfer stats.
# oflag: set to sync synchronizes I/O for data and metadata.
```
# Installing OS
## Windows Installation
Start with Windows Pro install if you want to have dual boot.<br>
 _Starting with windows as this phase some options on how the partition layout goes and the partition layout it put in place can be used so we build the linux on it_.<br>
Installing Windows first allows __reuse__ of the Windows-created __EFI partition__ (bootloader).<br>
The Windows partition will be __encrypted__ with __Bitlocker__. You can also try other tools like VeraCrypt.

Ventoy
- Insert USB disk into laptop and start
- Select Windows iso from Ventoy
- Select "normal boot"
- Select Windows 11 Pro if you want encryption with Bitlocker

When installing Windows
- Click Customised: Install Windows only (advanced).
- Delete all existing partitions.
- Create a new partition of the size you'd like Windows to occupy.
- Go through setup and select I don't have internet _(also select No as much as possible :))_
- Bypass Windows 11 internet setup requirements and create a local account
- On the “Oops, you've lost internet connection” or “Let's connect you to a network” page, use the Shift + F10 keyboard shortcut. 
```bash
# In Command Prompt, type the following command to bypass network requirements
OOBE\BYPASSNRO
# then press Enter
```
- After reboot, go through the Windows setup procedure.
- Download and Install drivers from [Tuxedo](https://mytuxedo.de/index.php/s/ZeB8FTf8CrpEtJr?path=%2FInfinityBook_Pro_Series%2FInfinityBook_Pro_16_Gen7) _(start with wifi and bluetooth drivers so you can use your mouse)_
- Open Control Panel.
- In the top right search, enter power.
- Click Change what the power buttons do/Change what closing the lid does.
- Click Change settings that are currently unavailable.
- __Uncheck Turn on fast startup__ (recommended).
- Open Start > Settings > Update & Security and Check for updates.
- Download and install all Windows updates.
- Reboot
- __Encrypt disk__ with Bitlocker (or Veracrypt).
- Open Manage Bitlocker -> Turn Bitlocker on -> Save key -> Encrypt entire drive
- Store your key in a safe place

## Arch Install
Official guide for [installing Arch Linux](https://wiki.archlinux.org/title/installation_guide)
### Boot into arch installer
- Insert Ventory USB with arch linux into laptop and restart
- Press the key to activate the Boot Menu F7 (F9/F12 on other laptops) when the system starts.
- Select arch and boot in normal mode
### Verify internet connection
- Verify internet connection<br>
```bash
# see if you have any ip assigned
ip addr show
#for wifi interface
iwctl # promt have changed to iwd
device list # list all available wireless devices
# if device is powered off and no device is displayed
# I've solved it by blacklisting hp_wmi. Do this as root:
$ echo "blacklist hp_wmi" > /etc/modprobe.d/hp.conf
# Reboot, then unblock all WiFi with (as root):
$ rfkill unblock all
# scan local area and find wifi access points that we can connect to
# station <wireless-device-name/wlan0> scan 
station wlan0 scan
# scan is initiated but it will not show the results
station wlan0 get-networks # get list of wifi networks found
station wlan0  connect "CXP5" # connect to wireless network of choice
# exit the iwd prompt after some time (ctrl+d)
ctrl+d
ip a s
ping -c 3 8.8.8.8
ping -c google.com 

# another option is to use “wifi-connect”
```
- After the steps above, I always __start sshd__ _(included in the archiso)_ and __finish the installation process from another computer__.<br> 
This enables me to have access to copy and paste, editors, and browsers rather than the restricted terminal on my target machine.
This is optional, but the steps below may make your experience better.<br>
```bash
#Set a root passwd for archiso.
passwd
#Enable sshd.
systemctl start sshd
#Determine your local address using ip a.
ip a s
# From another machine, ssh in.
ssh root@${TARGET_MACHINE_IP}
```
### Update the system clock
```bash
timedatectl set-ntp true
```

## Disk Layout
Before installing Arch it is a good ideea to read more about [Arch boot process](https://wiki.archlinux.org/title/Arch_boot_process) to better understand the disk layout options.<br>

There are multiple options that I will list here but I will provide details for the setups that I've tried on different laptops.<br>
__Choose A,B,C,D or E based on your desired setup.<br>__

On this laptop I have two disks and I can have each OS on it's own disk. When laptop starts I use F7 boot menu key to choose between Windows and Linux Disk.<br>
In Bios I've changed the "UEFI NVME Drive BBS Priorities to the linux disk."
I will then create on arch a grub config that will recognize the encrypted windows partition. This setup with grub is also handy if you have just one disk.<br>

### (A) Non-UEFI

### (B) UEFI
### (C) UEFI with Encryption
You need UEFI enabled in your BIOS (enable uefi will wipe out your disk).

#### - Create partition tables.
3 partitions are created:
-  __EFI__ 
- __boot__ 
- __root__

```bash
# Get the harddisk name and get device identifier. e.g.: /dev/nvme1n1
fdisk -l
# Start creating partitions
fdisk /dev/nvme1n1 # 
p # list all the partitions that you have
g # create a fresh partition layout. Will create a new GPT partition layout (this is needed on a single boot, fresh install)
```
- Create first partition __(UEFI partition)__
```bash
n # create a new partition (UEFI partition)
# set partition number: 1
# accept the default sector
+500M # last sector set: +500M
t # set type of partition
# select partition type: 1 (for EFI system)
# Changed type of partition 'Linux filesystem' to 'EFI System' will be displayed
```
- Create a second partition __(boot partition)__
```bash
# Create a second partition (boot partition)
n # create partition
# accept default partition number: 2
# accept default first sector
+512M # last sector set: +512M
p # list all the partitions that you have
```
- Create the 3rd partition __(root partition)__
```bash
# Create the 3rd partition (root partition)
n # crete the LVM partition
# accept default partition number:3
# accept default first sector
# accept default last sector to use all remaining disk
t # set type of partition
# set 3 for partition number
# change partition type to 43 for LVM (type L to list all partitions types as the number for LVM might change)
# Changed type of partition 'Linux filesystem' to 'Linux LVM'. is displayed

p # review partitions. 1st is efi system, 2nd = linux filesystem type 3 = lvm

w # save changes
```
#### - Format the partitions.
```bash
mkfs.fat -F32 /dev/nvme1n1p1 # set FAT32 partition (EFI partition)
mkfs.ext4 /dev/nvme1n1p2 # ext4 for 2nd partition (Boot partition)
```
#### - Encrypt the 3rd partition and Setup LVM
```bash
# encrypt partition
cryptsetup -y --use-random luksFormat /dev/nvme1n1p3
# -y: interactively requests the passphrase twice.
# --use-random: uses /dev/random to produce keys.
# luksFormat: initializes a LUKS partition.
# unlock partition
cryptsetup open --type luks /dev/nvme1n1p3 lvm # # we call it "lvm". Opens the LUKS device and creates a mapping in /dev/mapper
# not that is open. lsblk command should display it as a sub mapper directory. Next command are going to be executed against the mapper.
pvcreate --dataalignment 1m /dev/mapper/lvm # create the physical volume
vgcreate vg00 /dev/mapper/lvm # create a volume group = a namespace that will contain logical volumes
# create two logical volumes (one for the root filesystem and another for home folder)
lvcreate -L 50GB vg00 -n lv_root
lvcreate -l 100%FREE vg00 -n lv_home
# Activate LVM
modprobe dm_mod # load the dm_mod kernel module into memory
vgscan # scan for volume groups
vgchange -ay # activate found volume group. will activate the logical volumes found in the volume group.
```
> Output example
```bash
root@archiso ~ # lsblk
NAME               MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0                7:0    0 688.5M  1 loop  /run/archiso/airootfs
sda                  8:0    1     0B  0 disk
sdb                  8:16   1  14.7G  0 disk
├─sdb1               8:17   1  14.6G  0 part
│ └─ventoy         254:0    0 810.3M  1 dm
└─sdb2               8:18   1    32M  0 part
nvme1n1            259:0    0 931.5G  0 disk
├─nvme1n1p1        259:6    0   500M  0 part
├─nvme1n1p2        259:7    0   512M  0 part
└─nvme1n1p3        259:8    0 930.5G  0 part
  └─lvm            254:1    0 930.5G  0 crypt
    ├─vg00-lv_root 254:2    0    50G  0 lvm
    └─vg00-lv_home 254:3    0 880.5G  0 lvm
nvme0n1            259:1    0 465.8G  0 disk
├─nvme0n1p1        259:2    0   100M  0 part
├─nvme0n1p2        259:3    0    16M  0 part
├─nvme0n1p3        259:4    0   465G  0 part
└─nvme0n1p4        259:5    0   633M  0 part
```

#### - Format the logical volumes (3rd partition, the root partition)
```bash
# Format root logical volume
mkfs.ext4 /dev/vg00/lv_root
# Format home logical volume
mkfs.ext4 /dev/vg00/lv_home
```

#### - Mount the volumes
```bash
# Mount the root logical volume
mount /dev/vg00/lv_root /mnt

# Create directory for boot and mount the second partition
mkdir /mnt/boot
mount /dev/nvme1n1p2 /mnt/boot

# Create and mount home directory
mkdir /mnt/home
mount /dev/vg00/lv_home /mnt/home
```

### (D) Dual boot (Windows10 and Arch linux both with separate encryption - single disk)
Dual boot Arch and Windows both are fully encrypted independent of one another.<br>
Grub the bootloader is used to select what system to boot into.<br>

#### - Create partition tables.
3 partitions are created:
- EFI, 
- boot
- root partition
```bash
# Get the harddisk name and get device identifier. e.g.: /dev/sda
lsblk
fdisk -l
# Device         	Start   	End   Sectors  Size Type
/dev/nvme0n1p1  	2048	206847	204800  100M EFI System
/dev/nvme0n1p2	206848	239615 	32768   16M Microsoft reserved
/dev/nvme0n1p3	239616 103843839 103604224 49.4G Microsoft basic data
/dev/nvme0n1p4 103843840 105095167   1251328  611M Windows recovery environment
 
# Start creating partitions
fdisk /dev/nvme0n1 # 
p # list all the partitions that you have
# We don’t create a fresh GPT partition layout. Will be building on top of the partition layout created by the Windows install.
```
- Create first partition __(UEFI partition)__
<br>
We are going to _reuse the Windows-created EFI partition_.<br>
_Note_ the _partition number_ of the EFI System partition. This will be referenced later when configuring grub. In the result above, it is partition nvme0n1p1.

- Create a second partition __(boot partition)__
```bash
n # create partition
# accept default partition number: 5
# accept default first sector
+512M # last sector set: +512M
p # list all the partitions that you have
```
- Create the 3rd partition __(root partition)__
```bash

n # crete the LVM partition
# accept default partition number:6
# accept default first sector
# accept default last sector to use all remaining disk
t # set type of partition
# select the partition number: 6
# (type L to list all types)
# change partition type to 43 for “Linux LVM”

p # review partitions. Type of partitions is: 1st is efi system, 2nd = linux filesystem and 3rd = linux lvm
# /dev/nvme0n1p1  	2048	206847	204800   100M EFI System
# /dev/nvme0n1p5 105095168 106143743   1048576   512M Linux filesystem
# /dev/nvme0n1p6 106143744 500118158 393974415 187.9G Linux LVM

w # save changes
```
#### - Format the partitions.

__EFI partition is already set by windows (fat32).__<br>

Only format the EFI system partition if you created it during the partitioning step.<br>
If there already was an EFI system partition on disk beforehand, reformatting it can destroy the boot loaders of other installed operating systems.

Format the boot partition
```bash
mkfs.ext4 /dev/nvme0n1p5 # ext4 for 2nd partition (Boot partition)
```
### - Encrypt the 3rd partition (root partition) and Setup LVM
```bash
# encrypt partition
cryptsetup -y --use-random luksFormat /dev/nvme0n1p6
# -y: interactively requests the passphrase twice.
# --use-random: uses /dev/random to produce keys.
# luksFormat: initializes a LUKS partition.
# unlock partition
cryptsetup open --type luks /dev/nvme0n1p6 lvm # we call it lvm or cryptlvm. Opens the LUKS device and creates a mapping in /dev/mapper
pvcreate --dataalignment 1m /dev/mapper/lvm # create the physical volume
vgcreate vg00 /dev/mapper/lvm # create a volume group = a namespace that will contain logical volumes
# create two logical volumes (one for the root filesystem and another for home folder)
lvcreate -L 50GB vg00 -n lv_root
lvcreate -l 100%FREE vg00 -n lv_home
# Activate LVM
modprobe dm_mod # load the dm_mod kernel module into memory
vgscan # scan for volume groups
vgchange -ay # activate found volume group. will activate the logical volumes found in the volume group.
```
### - Format the logical volumes (3rd partition, the root partition)
```bash
# Format root logical volume
mkfs.ext4 /dev/vg00/lv_root
# Format home logical volume
mkfs.ext4 /dev/vg00/lv_home
```

#### - Mount the volumes
Boot partition is separated from the root (optional step) and the reason is because we are going to set up initramfs. <br>
You can put boot in root but we need to have boot completely unencrypted and the reason is when you log on into and bring up the grub menu you don’t have to put a password. You can choose windows or linux and then based on your choice it will take you to windows encryption or linux encryption.<br>

[Other mount points](https://wiki.archlinux.org/title/EFI_system_partition#Typical_mount_points), such as /mnt/efi, are possible, provided that the used boot loader is capable of loading the kernel and initramfs images from the root volume. See the warning in [Arch boot process](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader).

```bash
# Mount the root logical volume to /mnt
mount /dev/vg00/lv_root /mnt

# Create directory for boot (create a boot directory at root) and mount the second partition (mount the boot directory to the boot partition)
mkdir /mnt/boot
mount /dev/nvme0n1p5 /mnt/boot

# Create an efi directory in /mnt/boot and Mount the Window's created EFI partition to /mnt/boot/efi
mkdir /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi

# Create and mount home directory
mkdir /mnt/home
mount /dev/vg00/lv_home /mnt/home
```

### (E) Dual boot (Windows10 and Arch linux both with separate encryption - separate disks)
Follow steps from section [(C) UEFI with Encryption](###-(C)-UEFI-with-Encryption)

## Installing Arch Linux
- Select the mirrors
Packages to be installed must be downloaded from [mirror servers](https://archlinux.org/mirrorlist/all/https/)
```bash
vim /etc/pacman.d/mirrorlist
# Move the geographically closest mirrors to the top of the list and uncomment them.
```
- Essential packages<br>
Pastrap is the tool that will install tools to the root directory _(install the base package, Linux kernel and firmware for common hardware)_.
```bash
# Install essential packages
pacstrap /mnt base linux linux-firmware linux-headers linux-lts linux-lts-headers
# Notice that I've installed two Linux kernel
# - the latest linux kernel (to have the latest features and upgrade)
# - linux-lts as fallback (just in case I mess something up).
```

> Another option is to Install base packages, change root into the system and install other packages using pacman command.<br>
```bash
# Install base packages
pacstrap -i /mnt base
# Access the in-progress Arch installation. 
# Change root into the new system:
arch-chroot /mnt # will give access to the arch installation. the command prompt is attached to that installation in progress. We'll make this installation independent of the boot media (usb disk).

# At this point our arch installation is a distribution not a linux because it does not have a linux kernel yet.
# Install default linux kernel and lts linux kernel (2 kernels)
pacman -S linux linux-firmware linux-headers linux-lts linux-lts-headers
# (linux = standard linux kernel, latest + linux-lts=long term supported linux kernel - more stable and have 2nd kernel as a failover if you mess-up with the latest one )
# ? not sure if linux-firmware needs to be installed instead of linux-headers and linux-lts-headers
```

- Optional packages
```bash
pacstrap /mnt base-devel grub efibootmgr lvm2 vi git openssh

# base-devel: common package for development in Linux ( https://www.archlinux.org/groups/x86_64/# base-devel ).
# grub: (GRand Unified Bootloader) is a multi-boot loader.
# efibootmgr: userspace application used to modify the Intel Extensible Firmware Interface (EFI) Boot Manager.
# lvm2: add lvm support (even if you don't use lvm)
# vi: text editor.
# git: version control system.
# openssh: remote login with the SSH protocol
```

## Configure the system
- Fstab<br>
```bash
# Create the directory for fstab file (file used by distribution when it boots up so it knows where to find all the partitions). 
mkdir -p /mnt/etc
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
```
- Chroot<br>
Access the in-progress Arch installation. 
```bash
# Change root into the new system:
arch-chroot /mnt # will give access to the arch installation. The command prompt is attached to that installation in progress. We'll make this installation independent of the boot media (usb disk).

# Enable OpenSSH
systemctl enable sshd
```
- Time zone<br>
```bash
# Set the time zone:
ln -sf /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
# Run hwclock(8) to generate /etc/adjtime. Set the Hardware Clock from the System Clock, and update the timestamps in /etc/adjtime.
hwclock --systohc
```
- Localization<br>
```bash
# Uncomment the line from the /etc/locale.gen file that corresponds to your locale (uncomment en_US.UTF-8)
vi /etc/locale.gen
# Generate the locale
locale-gen
# Set the LANG variable to the same locale in /etc/locale.conf.
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
# The default console keymap is US If you set the console keyboard layout, make the changes persistent in vconsole.conf(5).
```
- Network configuration<br>
```bash
# Set your hostname.
echo "softaz" >> /etc/hostname

# Complete the network configuration for the newly installed environment.
# Installing suitable network management software.
pacman -S networkmanager wpa_supplicant wireless_tools netctl dialog iwd

# Enable networkmanager
systemctl enable NetworkManager

# Networking tools
# networkmanager: handles connecting to wireless and wired networks.
# wpa_supplicant: wireless drivers
# wireless_tools:
# netctl: network manager
# dialog: dialog (required for wifi-menu)
# iwd: wireless daemon for Linux written by Intel
```
- Initramfs<br>
Initial Ramdisk Configuration = The initial ramdisk is a root file system that will be booted into memory. It aids in startup. This section covers setup and generation of an mkinitcpio configuration for generating initramfs.<br>
Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.<br>
For LVM, system encryption or RAID, modify mkinitcpio.conf(5) and recreate the initramfs image.

Ensure boot process support our configuration
```bash
# Edit /etc/mkinitcpio.conf
vi /etc/mkinitcpio.conf

# Look for a line called "HOOKS" that is not commented out.
# HOOKS are modules added to the initramfs image. Without encrypt and lvm2, systems won't contain modules necessary to decrypt LUKs.

# between "block" and "filesystems" (order matters) add
# - "encrypt" if you used encryption (if you did not use encryption don't add this)
# - and "lvm2" if you used lvm
# Move “keyboard” before “modconf” in HOOKS.
# Save the file that will contain HOOKS=(base ... block encrypt lvm2 filesystems ...)

# It should look similar to the following (don't copy this line in case they change it):
HOOKS=(base udev autodetect keyboard modconf kms keymap consolefont block encrypt lvm2 filesystems fsck)

# Build initramfs with the linux preset. Create the initial ramdisk for the main kernel (activate the options added)
mkinitcpio -p linux
# Create the initial ramdisk for the LTS kernel (if you installed it)
mkinitcpio -p linux-lts
```

- Root password<br>
Set root password and add a user
```bash
# Set the root password
passwd

# Create a user for yourself
# useradd -m -g users -G wheel <username>
useradd -m -g users -G wheel paul

# Set your password
passwd paul

# Install sudo
pacman -S sudo

# Allow users in the 'wheel' group to use sudo
EDITOR=vi visudo
# Uncomment:
wheel ALL=(ALL) ALL
OR
%wheel ALL=(ALL) NOPASSWD: ALL
```

## Boot loader
### Installing GRUB<br>
Choose and install a Linux-capable boot loader.<br> 
If you have an Intel or AMD CPU, enable microcode updates in addition.<br>

Choose A,B,C or D based on your setup.
### (A) Installing GRUB for non-UEFI, with no encryption
```bash
# Install the required packages for GRUB:
pacman -S grub dosfstools os-prober mtools
# Install GRUB:
grub-install --target=i386-pc --recheck /dev/sda
# Create the locale directory for GRUB
mkdir /boot/grub/locale
# Copy the locale file to locale directory
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
# Generate GRUB's config file
grub-mkconfig -o /boot/grub/grub.cfg
```
### (B) Installing GRUB for UEFI, with no encryption
```bash
# Install the required packages for GRUB:
pacman -S grub efibootmgr dosfstools os-prober mtools
# Create the EFI directory:
mkdir /boot/EFI
# Mount the EFI partition:
mount /dev/<DEVICE PARTITION 1> /boot/EFI
# Install GRUB:
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
# Create the locale directory for GRUB
mkdir /boot/grub/locale
# Copy the locale file to locale directory
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
#Generate GRUB's config file
grub-mkconfig -o /boot/grub/grub.cfg
```
### (C) Installing GRUB for UEFI, with LUKS disk encryption
```bash
# Install the required packages for GRUB:
pacman -S grub efibootmgr dosfstools os-prober mtools
# Create the EFI directory:
mkdir /boot/EFI
# Mount the EFI partition:
mount /dev/<DEVICE PARTITION 1> /boot/EFI
# Install GRUB:
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
# Create the locale directory for GRUB
mkdir /boot/grub/locale
# Copy the locale file to locale directory
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
# Set up GRUB to be able to unlock the disk
# Open the defaulg config file for GRUB:
vi /etc/default/grub
# Uncomment:
GRUB_ENABLE_CRYPTODISK=y
#Add cryptdevice=<PARTUUID>:volgroup0 to the GRUB_CMDLINE_LINUX_DEFAULT line If using standard device naming, the option will look similar this (be sure to adjust the device name):
cryptdevice=/dev/sda3:volgroup0:allow-discards quiet
#Generate GRUB's config file
grub-mkconfig -o /boot/grub/grub.cfg
```
### (D) Installing GRUB for UEFI, with LUKS disk encryption and Dual Boot
In /etc/default/grub you don’t need to enable GRUB_ENABLE_CRYPTODISK=y.<br> 
This is needed only if your boot partition is encrypted.<br>
In our case it is not as windows and linux are encrypted separately.<br>
```bash
# Install the required packages for GRUB:
pacman -S grub efibootmgr dosfstools os-prober mtools

# ---
# Create the EFI directory. This might be already done on the "mount" step.
mkdir -p /boot/efi
# Mount the EFI partition. This might be already done on the "mount" step.
# For dual boot with Windows EFI. Mount the Window's created EFI partition to /boot/efi  
mount /dev/nvme0n1p1 /boot/efi
# OR For dual boot with Windows EFI on a separate disk and Linux on another mount the linux efi partition from the second disk
#mount /dev/nvme1n1p1 /boot/efi 
# if you are mounting while logged into the arch system (after arch-chroot) command. If you mounted before the arch-chroot command use the full path /mnt/boot/efi
# ---

# Determine the UUID of your root partition and EFI partition.
fdisk -l
blkid
# nvme0n1p1 = /boot/efi = example UUID="10BC-C49B"
# nvme0n1p6 = / = example UUID="6e0e2ea6-27e5-4d49-9a87-4503c08124f7"
# Those will be referenced in the Grub configuration

# Edit the GRUB boot loader configuration.
vi /etc/default/grub

# Update the GRUB_CMDLINE_LINUX to match the format cryptdevice=UUID=${ROOT_UUID}:cryptroot root=/dev/mapper/cryptroot where ${ROOT_UUID} is the UUID captured above.
GRUB_CMDLINE_LINUX="cryptdevice=UUID=aacb44ed-54fa-4481-be1a-4a46aabad50f:lvm root=/dev/mapper/vg00-lv_root"

# Add grub menu item for Windows 11 by editing /etc/grub.d/40_custom.
# Replace $FS_UUID with the EFI partition's UUID, found in step above of this section. $FS_UUID is specified after --set=root
cp /etc/grub.d/40_custom /etc/grub.d/40_custom.bak
vi /etc/grub.d/40_custom
```
Grub config
```bash
#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change the 'exec tail' line above.
menuentry "System shutdown" {
    	echo "System shutting down..."
    	halt
}
menuentry "System restart" {
    	echo "System rebooting..."
    	reboot
}
if [ "${grub_platform}" == "efi" ]; then
  menuentry "Windows 11" {
    insmod part_gpt
    insmod fat
    insmod search_fs_uuid
    insmod chain
    search --fs-uuid --set=root $FS_UUID <change this with the windows EFI partition ID>
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    # chainloader /EFI/VeraCryot/DcsBoot.efi # if you used Veracrypt for windows encryption
  }
fi
```
Install
```bash
# Install grub on the master boot record
grub-install
# This assumes your efi is located in /boot/efi; additional flags are available if you used an alternative location.
# grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck /dev/nvme0n1 # without a partition number at the end.

# ---
# Create the locale directory for GRUB if it does not exist
ls -alh /boot/grub
mkdir /boot/grub/locale
# Copy the locale file to locale directory
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
# if you want to use another language in grub refer to the documentation for that.
# ---

#---
# In /etc/default/grub you don't need to enable GRUB_ENABLE_CRYPTODISK=y . This is needed only if your boot partition is encrypted. In our case it is not.
# For dual-boot we added grub to a separate non-encrypted disk (nvme1n1p2    	259:15   0   512M  0 part  /boot). 

# If you have grub on encrypted disk to the steps from the following description
# For encryption only. Inform grub that it needs to trigger the unlock of the disk at boot otherwise is not going to boot at all.
# Set up GRUB to be able to unlock the disk
# Open the default config file for GRUB:
#vi /etc/default/grub
# search for GRUB_ENABLE_CRYPTODISK=y and uncomment that line
#GRUB_ENABLE_CRYPTODISK=y

# Also edit line
# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
# to
# GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=/dev/sda3:volgroup0:allow-discards loglevel=3 quiet"
#Add cryptdevice=<PARTUUID>:volgroup0 to the GRUB_CMDLINE_LINUX_DEFAULT line If using standard device naming, the option will look similar this (be sure to adjust the device name):
# cryptdevice=/dev/sda3:volgroup0:allow-discards quiet
# ---

# Generate the grub configuration.
grub-mkconfig -o /boot/grub/grub.cfg
```
Making Grub Font Readable
```bash
# To set a custom font and size, create a grub-compatible font.
pacman -S wget unzip freetype2
{
  mkdir -p /usr/share/grub-fonts/
  wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip -O /usr/share/grub-fonts/Hack-v3.003-ttf.zip
  unzip /usr/share/grub-fonts/Hack-v3.003-ttf.zip -d /usr/share/grub-fonts/
}
grub-mkfont -s 30 -o /boot/grubfont.pf2 /usr/share/grub-fonts/ttf/Hack-Regular.ttf
# Then add the following in /etc/default/grub.
GRUB_FONT="/boot/grubfont.pf2"
```
Remember last selected choice
```bash
vi /etc/default/grub
# modify at the top
GRUB_DEFAULT=saved
# uncomment
GRUB_SAVEDEFAULT=true
# Add “savedefault” to Windows menuentry
vi /etc/grub.d/40_custom
menuentry 'Windows 11' {
	savedefault	# <<<<<<<<<<<< THIS Attribute was missing!
}
# Regenerate the grub config.
grub-mkconfig -o /boot/grub/grub.cfg
```
Change [Grub "Arch Linux"](https://wiki.archlinux.org/title/GRUB/Tips_and_tricks#Changing_the_default_menu_entry) kernel
```bash
# Because we installed two kernel (arch latest and arch-lts) the simple "Arch Linux" optiont (not the Advanced) can be updated to point to latest or lts version as you need (default is it takes the lts)
# find all instelled kernels
find /boot/vmli*
# get current kernel
uname -r
pacman -Q linux
# Read thread https://bbs.archlinux.org/viewtopic.php?id=266583
vi /etc/grub.d/10_linux
# Change the line
reverse_sorted_list=$(echo $list | tr ' ' '\n' | sed -e 's/\.old$/ 1/; / 1$/! s/$/ 2/' | version_sort -r | sed -e 's/ 1$/.old/; s/ 2$//')
# with
reverse_sorted_list=$(echo $list | tr ' ' '\n' | sed -e 's/\.old$/ 1/; / 1$/! s/$/ 2/' | version_sort -V | sed -e 's/ 1$/.old/; s/ 2$//')
# Regenerate the grub config.
rm /boot/grub/grub.cfg
grub-mkconfig -o /boot/grub/grub.cfg
# Verify menuentry from /boot/grub/grub.cfg
# menuentry 'Arch Linux' {
# ...
# initrd  /intel-ucode.img /initramfs-linux.img # or initramfs-linux-lts.img
#}
#
# OR - simply modify the
vi /boot/grub/grub.cfg
```

### Reboot<br>
```bash
exit # Exit the arch-chroot environment by typing exit
umount -a # umount -R /mnt
reboot
```
Go to __Bios__ setting and change __boot order__ to the disk where Arch is installed. (Bios F2 -> Boot -> UEFI NVME Drive BBS Priorities - set Boot Option #1 to __arch__)<br>

If reboot fails follow go to [Debugging](#Debugging)

## Post-installation
Using grub, login to Arch linux.<br>
Establish internet connection  with “nmtui-connect” and begin installing packages.<br>
You can connect from another machine to perform post-installation and desktop setup
```bash
# on another machine
ssh paul@<ip-of-laptop>
```

- Create a swap file if needed.<br>
I have plenty of ram on this laptop so I will skip this.
```bash
# 8GB swap example
sudo su
cd /root
dd if=/dev/zero of=/swapfile bs=1M count=8192  status=progress
chmod 600 /swapfile
mkswap /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
mount -a
swapon -a
free -m
```
- Set timezone
```bash
# timedatectl list-timezones
timedatectl set-timezone Europe/Bucharest
# synchronize clock
systemctl enable systemd-timesyncd
```
- Set hostname
```bash
hostnamectl set-hostname softaz
cat /etc/hostname
```
- Edit /etc/hosts file
```bash
vi /etc/hosts

127.0.0.1 localhost
127.0.1.1 softaz # the hostname used

```
- Install microcode for CPU depending on cpu you are using
```bash
pacman -S intel-ucode
# or 
# pacman -S amd-ucode 
```

Congrats ＼(＾O＾)／ now you have say __"I use arch btw"__ 

You will probably need a GUI interface, but I'll address that in a separate [post]({{< ref "arch-desktop" >}}).

# Debugging
In case you need to troubleshoot failed install after reboot.

- Go back to the boot menu (F7)
- Boot back into the ventoy usb drive (with arch installer).
- Connect to the internet. SSH into the installer if you want
- List the block devices 
```bash
lsblk
```
- Unlock the encrypted disk and arbitrary name it lvm
```bash
cryptsetup luksOpen /dev/nvme1n1p3 lvm
vgscan
vgchange -ay
```
- Remount all of the files to the appropriate partitions
```bash
```bash
# Mount lvm root at /mnt.
mount /dev/vg00/lv_root /mnt
# Mount the boot directory to the boot partition.
mount /dev/nvme1n1p2 /mnt/boot
# Mount the Window's created EFI partition to /mnt/boot/efi.
#mount /dev/nvme0n1p1 /mnt/boot/efi
mount /dev/vg00/lv_home /mnt/home
lsblk # check

# Create and mount home directory
mkdir /mnt/home
mount /dev/vg00/lv_home /mnt/home
```
Get back on the internet with wifi-menu or another tool.
Enter the system root via arch-chroot.
```bash
arch-chroot /mnt
```
Install what you are missing. 
```bash
#.e.g: 
pacman -S NetworkManager
```
Exit and reboot
```bash
exit
umount -a # umount -R /mnt
reboot
```
# Resources
https://octetz.com/docs/2020/2020-2-16-arch-windows-install/
https://github.com/joshrosso/linux-desktop#making-grub-font-readable
https://www.learnlinux.tv/arch-linux-full-installation-guide/
https://bbs.archlinux.org/viewtopic.php?id=259170
https://askubuntu.com/questions/148662/how-to-get-grub2-to-remember-last-choice
