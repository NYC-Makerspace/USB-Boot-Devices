#! /bin/bash
#
# Provision a minimal LXDE Desktop environment
# in the first partition of a device.  ie. /dev/sdX1
#

set -e
set -u
set -x

dev="${1}"


mkdir mnt
sudo mount ${dev}1 mnt

sudo pacstrap mnt lxdm openbox lxde-common lxsession lxterminal lxpanel lxappearance
cat <<EOF | sudo arch-chroot mnt
systemctl enable lxdm
EOF

sudo sync
sudo umount -R mnt
rmdir mnt
