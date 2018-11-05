# MyLFS

This build system tracks [Linux From Scratch 8.2-systemd](http://linuxfromscratch.org/lfs/view/8.2-systemd/).

This is a build system based on https://github.com/baho-utot/LFS-RPM.git

In the copy that I forked, the author had built the toolchain from Chapter 5, but then used that system to try and build the finished RPMS. I am taking the approach of building the Chapter 5 toolchain and the Chapter 6 system with shell scripts, then using the completed Chapter 6 system to build the RPM packages.

## Installation

* The MyLFS build system is installed to `/usr/src/mylfs` by default
* Edit the `config.inc` file
* As root, execute `./build-lfs.sh`

The script will carry out the following:

* Format and mount the partition on which the system will be built
* Add the LFS user
* Download the packages
* Copy the build system scripts and sources to the new partition
* Build the LFS toolchain
* `chroot` into the build environment and build the base LFS system

## Beyond LFS

Now that the base LFS system is complete, it's time to make some design decisions.

### LSB Standard

At some point, I will make an attempt at LSB 5.0 Compliance. 

### Booting

For MyLFS, I've decided to use UEFI booting and GPT hard disks. LFS has instructions on using the GRUB2 bootloader. I have decided to use the systemd-boot boot manager. Using this requires some extra packages and some changes to the LFS book instructions. The new packages are:
- [dosfstools-4.1](https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.xz)
- [efivar-36](https://github.com/rhboot/efivar/releases/download/36/efivar-36.tar.bz2)
- [pciutils-3.5.6](https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.5.6.tar.xz)
- [efibootmgr-16](https://github.com/rhboot/efibootmgr/releases/download/16/efibootmgr-16.tar.bz2)
- [gnu-efi-3.0.8](https://sourceforge.net/projects/gnu-efi/files/gnu-efi-3.0.8.tar.bz2)

#### Graphical booting using Plymouth

MyLFS will use Plymouth on an initrd to start a graphical splash screen to hide the text mode boot sequence and transfer control to the X display manager after which will provide a graphical login.

### systemd

MyLFS will use systemd, instead of SysV init.

### Networking

Right now, I am running MyLFS inside a VM with an emulated e1000 NIC.
