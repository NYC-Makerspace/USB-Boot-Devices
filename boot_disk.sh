#!/bin/bash
#
# Setup a minimal Arch linux persistent USB disk
# (assuming host computer already runs Arch)
#
# instruction from https://gist.github.com/elerch/678941eb670324ffc3f261eabba81310
#

set -e
set -u


dev="$1"
hostname="${2}"
username="${3}"

if [[ ${dev} = "-h" ]] ; then
  echo "example usage:"
  echo "$0"' /dev/sdX hostname username'
  exit 1
fi

set -x

# zero out disk
sudo dd if=/dev/zero of=$dev bs=1k count=4096
sudo sync

#Partition scheme: GPT
sudo sgdisk -z ${dev} # zap anything existing (should be nothing after the dd command above)
sudo sgdisk -o ${dev} # write a new gpt partition with protective MBR
#parition 1: 0- (-200mb). linux system partition
sudo sgdisk -n 1:0:-200m ${dev} # partition 1 - everything but the last 200MB
sudo sgdisk -t 1:8300 ${dev} # set partition type to linux
#partition 2: 200mb. efi system partition with legacy boot ON
sudo sgdisk -n 2:-200m:-0 ${dev} # create partition 2 - last 200MB
sudo sgdisk -t 2:ef00 ${dev} # set partition type to esp
sudo sgdisk -a 2:set:2 ${dev} # turn legacy boot attribute on

sudo sync
sudo mkfs.ext4 -O "^has_journal" ${dev}1 # Primary Linux partition, without journaling enabled
sudo mkfs.fat -F32 ${dev}2 # ESP  (The EFI System Partition)

mkdir -p mnt boot
sudo mount ${dev}1 mnt
sudo mount ${dev}2 boot

sudo pacstrap mnt grub base vi wpa_supplicant dialog sudo
genfstab -U -p mnt | sudo tee mnt/etc/fstab

# configure the system
cat <<EOF | sudo arch-chroot mnt
# https://wiki.archlinux.org/index.php/installation_guide
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen 
locale-gen
echo $hostname > /etc/hostname
sed -i '/End of file/ s/^/127.0.1.1       '"${hostname}"'.localdomain   	    '"${hostname}"'\n\n/' /etc/hosts
mkinitcpio -p linux
sudo passwd -l root

# create default user
useradd -G wheel -m ${username}
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
echo ${username}:${username} | chpasswd
EOF

# configure boot options
sudo grub-install --target=x86_64-efi --recheck --removable --efi-directory boot --boot-directory=mnt/boot --bootloader-id=usbdiskgrub /dev/sda
# sudo grub-install --target=i386-pc --boot-directory=boot --recheck --bootloader-id=usbdiskgrub /dev/sda
cat <<EOF | sudo arch-chroot mnt
grub-mkconfig -o /boot/grub/grub.cfg
EOF

sudo sync
sudo umount -R mnt boot
rmdir mnt boot

echo 'done!'
