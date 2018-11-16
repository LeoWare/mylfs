# Linux from Scratch 8.2-systemd

This build system tracks [Linux From Scratch 8.2-systemd](http://linuxfromscratch.org/lfs/view/8.2-systemd/).

This system is partially based on https://github.com/baho-utot/LFS-RPM.git

## Installation

* The build system is installed to `/usr/src/lfs` by default
* Using your favorite partition editor, create two partitions:
	* An EFI System Partition (ESP) with a size of 200MiB and filesystem type of vfat.
	  You can utilize an existing ESP if you'd like, just put that partition in the `config.inc.sh`
	* A root partition any size you want. Format the partition.
* Edit the `config.inc` file [defaults in square brackets]
	* Set PARENT to the directory you un-tar'd or cloned the system into. [/usr/src/lfs]
	* Set LFS to the directory on the host system to which you want to mount the installation partition. [/mnt/lfs]
	* Set LFS_USER to the user to add to compile the packages. [lfs]
	* Set DEVICE to the partitiion to mount to $LFS. [/dev/sdb2]
	* Set BOOT_DEVICE to the partition to mount to $LFS/boot. [/dev/sdb1]
	* Set FILESYSTEM to the filesystem type you would like to use. [ext4]
* As root, `cd` to the source directory and execute `./build.sh`

The script will carry out the following:

* Mount the partition on which the system will be built
* Add the LFS user
* Download the packages
* Copy the build system scripts and sources to the build partition
* Build the LFS toolchain
* `chroot` into the build environment and build the base LFS system

## Booting

For this implementation, I've decided to use UEFI booting and GPT hard disks. LFS has instructions on using the GRUB2 bootloader. I have decided to use the systemd-boot boot manager. Using this requires some extra packages and some changes to the LFS book instructions. The new packages are:
- [dosfstools-4.1](https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.xz)
- [efivar-36](https://github.com/rhboot/efivar/releases/download/36/efivar-36.tar.bz2)
- [pciutils-3.5.6](https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.5.6.tar.xz)
- [efibootmgr-16](https://github.com/rhboot/efibootmgr/releases/download/16/efibootmgr-16.tar.bz2)
- [gnu-efi-3.0.8](https://sourceforge.net/projects/gnu-efi/files/gnu-efi-3.0.8.tar.bz2)
