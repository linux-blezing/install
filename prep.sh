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



# PROCESSOR
procieidven=$(grep "vendor_id" /proc/cpuinfo | head -n 1 | awk '{print $3}')

if [[ "$procieidven" == "GenuineIntel" ]]; then
    pacstrap /mnt intel-ucode $DISTRO_INSTALLATION_PACKAGE --noconfirm
elif [[ "$procieidven" == "AuthenticAMD" ]]; then
    pacstrap /mnt amd-ucode $DISTRO_INSTALLATION_PACKAGE  --noconfirm
fi


# GRAPHICAL
graphidven=$(lspci | grep -i --color 'vga\')

if [[ ! -z $(echo $graphidven | grep -i --color 'Intel Corporation') ]];then
    echo "graphic intel" &&
    pacstrap /mnt lib32-vulkan-intel vulkan-intel --noconfirm
fi

if [[ ! -z $(lspci | grep -i --color '3d\|NVIDIA') ]];then
    echo "graphic nvidia"
fi

if [[ ! -z $(lspci | grep -i --color '3d\|AMD\|AMD/ATI\|RADEON') ]];then
    echo "graphic radeon" &&
    pacstrap /mnt lib32-vulkan-amd vulkan-amd --noconfirm
fi


genfstab -U /mnt > /mnt/etc/fstab &&
cp -fr $(pwd)/post /mnt &&

arch-chroot /mnt /bin/bash /post/init.sh