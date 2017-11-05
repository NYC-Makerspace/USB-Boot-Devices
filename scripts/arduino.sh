#!/bin/bash
set -e
set -u

dev="$1"

#./boot_main.sh $dev
./boot_add_packages.sh $dev arduino openscad jupyter ipython python-numpy python-pandas python-scipy python-matplotlib python-pip python-setuptools

