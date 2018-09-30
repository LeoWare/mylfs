# mylfs

This build system tracks Linux From Scratch 8.2-systemd.

This is a build system based on https://github.com/baho-utot/LFS-RPM.git

I am taking the approach of building the Chapter 5 toolchain and the Chapter 6 system with shell scripts, then using the completed Chapter 6 system to build the RPM packages.

## Beyond LFS

Now that the base LFS system is complete, it's time to make some design decisions.

### LSB Standard

At some point, I will make an attempt at LSB 5.0 Compliance. 

### Booting

For mylfs, I've decided to use UEFI booting and GPT hard disks. The standard way of booting, even in UEFI, seems to be to use the GRUB bootloader. This is a mature and full-featured bootloader system. For now, I am designing this system without GRUB. This means that, to get mylfs to boot, I have to add the boot entry directly into the computer's UEFI firmware boot manager, instead of making a grub menu. One issue with this is that if there are multiple operating systems on a computer, it will be up to the computer's UEFI firmware to discover all the boot entries on all EFI System Partitions.

Graphical booting using Plymouth

mylfs will use Plymouth on an initrd to start a graphical splash screen to hide the text mode boot sequence and transfer control to the X display manager after which will provide a graphical login.

### systemd

Mylfs will use systemd, instead of SysV init.

### Networking

