#!/bin/bash


source /post/config


#HOSTNAME
echo "creami" > /etc/hostname &&


## LOCALTIME 
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &&
hwclock --systohc &&
timedatectl set-ntp true &&
timedatectl set-timezone $TIMEZONE &&


## CONFIG
cp -fr /post/base/* / &&


## LOCALE
locale-gen &&


## KERNEL
curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash &&


# PROCESSOR
procieidven=$(grep "vendor_id" /proc/cpuinfo | head -n 1 | awk '{print $3}')

if [[ "$procieidven" == "GenuineIntel" ]]; then
    pacman -S intel-ucode  --noconfirm
elif [[ "$procieidven" == "AuthenticAMD" ]]; then
    pacman -S amd-ucode  --noconfirm
fi


# GRAPHICAL
graphidven=$(lspci | grep -i --color 'vga\')

if [[ ! -z $(echo $graphidven | grep -i --color 'Intel Corporation') ]];then
    echo "graphic intel"
fi

if [[ ! -z $(lspci | grep -i --color '3d\|NVIDIA') ]];then
    echo "graphic nvidia"
fi

if [[ ! -z $(lspci | grep -i --color '3d\|AMD\|AMD/ATI\|RADEON') ]];then
    echo "graphic radeon"
fi


## switch
wget -O /usr/pbin/switch.AppImage https://git.ryujinx.app/api/v4/projects/1/packages/generic/Ryubing/1.3.3/ryujinx-1.3.3-x64.AppImage &&
chmod +x /usr/pbin/switch.AppImage && 


## heroic
wget -O /usr/pbin/heroic.AppImage https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.18.1/Heroic-2.18.1-linux-x86_64.AppImage &&
chmod +x /usr/pbin/heroic.AppImage  &&


## playstation 1
wget -O /usr/pbin/plays1.AppImage https://github.com/stenzek/duckstation/releases/download/latest/DuckStation-x64.AppImage &&
chmod +x /usr/pbin/plays1.AppImage &&


## playstation 2
wget -O /usr/pbin/plays2.AppImage https://github.com/PCSX2/pcsx2/releases/download/v2.4.0/pcsx2-v2.4.0-linux-appimage-x64-Qt.AppImage &&
chmod +x /usr/pbin/plays2.AppImage &&


## playstation 3
wget -O /usr/pbin/plays3.AppImage https://github.com/RPCS3/rpcs3-binaries-linux/releases/download/build-c669a0beb721d704241980675154cb35b0221d92/rpcs3-v0.0.38-18364-c669a0be_linux64.AppImage &&
chmod +x /usr/pbin/plays3.AppImage &&


## xbox 360
wget -O /usr/pbin/xbox36.AppImage https://github.com/xemu-project/xemu/releases/download/v0.8.115/xemu-v0.8.115-x86_64.AppImage &&
chmod +x /usr/pbin/xbox36.AppImage && 


##
## FIRMWARE

## playstation 3
mkdir -p /var/games/bios/plays3 &&
wget -P /var/games/bios/plays3 https://archive.org/download/ps3-official-firmwares/Firmware%204.89/PS3UPDAT.PUP &&


## switch
mkdir -p /var/games/bios/switch &&
wget -P /var/games/bios/switch https://github.com/THZoria/NX_Firmware/releases/download/20.5.0/Firmware.20.5.0.zip &&
cd /var/games/bios/switch &&
unzip Firmware.20.5.0.zip &&
cd / &&


##
## SERVICE
systemctl enable lightdm &&
systemctl enable dnsmasq &&
systemctl enable sshd &&
systemctl enable update.timer &&
systemctl enable firewalld &&
systemctl enable NetworkManager &&
systemctl enable --global pipewire-pulse &&
systemctl enable systemd-timesyncd.service &&

## EXECUTE
chmod +x /usr/xbin/* &&
chmod +x /usr/pbin/* &&


##
## BOOTUPS
mkdir -p /boot/{efi,kernel,loader} &&
mkdir -p /boot/efi/{boot,linux,systemd,rescue} &&
mv /boot/*-ucode.img /boot/kernel/ &&
rm /etc/mkinitcpio.conf &&
rm -fr /etc/mkinitcpio.conf.d/ &&
rm /boot/initramfs-* &&
bootctl --path=/boot/ install &&

echo "root=$DISKPROC" > /etc/cmdline.d/01-boot.conf &&
mkinitcpio -P &&

## USERADD
useradd -m $USERNAME &&
usermod -aG wheel $USERNAME &&
echo "add user passworrd" &&
passwd $USERNAME