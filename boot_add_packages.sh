
set -e
set -u
set -x

dev="${1}"
packages="${@:2}"

mkdir mnt
sudo mount ${dev}1 mnt


sudo pacstrap mnt $packages


sudo sync
sudo umount -R mnt
rmdir mnt
