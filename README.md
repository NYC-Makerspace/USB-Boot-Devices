Performs a persistent install of Arch Linux on USB disks.


# For the uninitiated:

## What?

Thumb drives are very useful, and arguably ubiquitous.  This project
converts a thumb drive into an operating system, enabling you to make
any public computer your own private machine.

## How does this work, from an end user's perspective?

Plug the usb thumb drive into a computer, reboot the computer, and choose
to "boot from USB" (you may need to press F12 to get a special boot menu).

A linux OS starts up.  Linux is like Windows, but so much more fun!  I
mean, who runs a computer with a flash drive?


# For the initiated:

Assuming you have a usb drive running Arch Linux...

- Be very careful choosing the usb device.  You can do so with `lsblk`.
- The device should be unmounted first.
- I recommend carefully reviewing every line of code before running, as
  the scripts make heavy use of sudo.  You should probably even just run
  it by hand.  That's what I would do if I didn't write the scripts!

```
# Format USB with default options.
./boot_main.sh /dev/sdX hostname username "extra arch packages"

# for only a bare-bones usb disk:
./boot_disk.sh /dev/sdX hostname username

# see the code for details
```

The particular base installs we use to teach classes at NYC Makerspace
are here:

```
ls ./scripts/
```

## Note about choices:

By default, we use the following:

- LXDE desktop
- wicd for internet access
- grub (via UEFI)
- Otherwise, it's pretty bare bones.

## How you can contribute:

- do legacy BIOS systems boot these USBs?  Let's figure out how to get it working if not.
- provide scripts for different toolsets, opinionated configurations
- boot_main.sh could be more configurable if we start needing to choose
  between different configuration options.
