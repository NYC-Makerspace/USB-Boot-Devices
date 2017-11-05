set -e
set -u

dev="$1"
hostname="${2:-maker}"
username="${3:-default}"
extra_pkgs="${4:-chromium wicd wicd-gtk}"


./boot_disk.sh ${dev} ${hostname} ${username}
./boot_lxde.sh ${dev}
./boot_add_packages.sh ${dev} ${extra_pkgs}
