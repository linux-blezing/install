#!/bin/bash


source /post/config


#HOSTNAME
echo "blezing" > /etc/hostname &&

##
## LOCALTIME 
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &&
hwclock --systohc &&
timedatectl set-ntp true &&
timedatectl set-timezone $TIMEZONE &&


##
## CONFIG
cp -fr /post/base/* / &&
locale-gen &&


##
## BOOTUPS
mkdir -p /boot/{efi,kernel,loader} &&
mkdir -p /boot/efi/{boot,linux,systemd,rescue} &&
mv /boot/*-ucode.img /boot/kernel/ &&
rm /etc/mkinitcpio.conf &&
rm -fr /etc/mkinitcpio.conf.d/ &&



## KERNELS
curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash &&


##
## SERVICE
systemctl enable sddm &&
systemctl enable sshd &&
systemctl enable dnsmasq &&
systemctl enable update.timer &&
systemctl enable firewalld &&
systemctl enable NetworkManager &&
systemctl enable apparmor.service &&
systemctl enable --global pipewire-pulse &&
systemctl enable systemd-timesyncd.service &&
systemctl enable --global gcr-ssh-agent.socket &&


## EXECUTE
chmod +x /usr/xbin/* &&
chmod +x /usr/rbin/* &&



## BOOTING
echo "rd.luks.name=$(blkid -s UUID -o value $DISKPROC)=root root=/dev/mapper/root" > /etc/cmdline.d/01-boot.conf &&
echo "data UUID=$(blkid -s UUID -o value $DISKDATA) none" >> /etc/crypttab &&
bootctl --path=/boot/ install &&
mkinitcpio -P &&


## USERADD
useradd -m $USERNAME &&
usermod -aG wheel $USERNAME &&
echo "add user passworrd" &&
passwd $USERNAME