#!/bin/bash

source /install/post/config
source /install/post/packer
source /install/post/inform

echo $DISKPROC;
echo $DISKDATA;

header_install &&

if [[ ! -z $(findmnt --mountpoint /mnt) ]]; then 
 	umount -R /mnt
fi


mkfs.ext4 -F -q -b 4096 $DISKPROC &&
mkfs.ext4 -F -q -b 4096 $DISKDATA &&
mkfs.vfat -F32 -S 4096 -n BOOT $DISKBOOT &&

mount $DISKPROC /mnt &&

mkdir -p /mnt/boot && 
mount -o uid=0,gid=0,dmask=007,fmask=007 $DISKBOOT /mnt/boot/ &&

mkdir -p /mnt/home &&
mount $DISKDATA /mnt/home &&

echo "[multilib]" >> /mnt/etc/pacman.conf &&
echo "Include = /etc/pacman.d/mirrorlist" >> /mnt/etc/pacman.conf &&

pacman -Syy &&

pacstrap /mnt $DISTRO_INSTALLATION_PACKAGE &&

genfstab -U /mnt > /mnt/etc/fstab &&
cp -fr $(pwd)/post /mnt &&

arch-chroot /mnt /bin/bash /post/init.sh