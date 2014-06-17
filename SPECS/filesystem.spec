Summary:	Default file system
Name:		filesystem
Version:	7.5
Release:	1
License:	GPLv3
Group:		System Environment/Base
Vendor:		Bildanet
URL:		http://www.linuxfromscratch.org
Distribution:	Octothorpe
%description
The filesystem package is one of the basic packages that is installed
on a Linux system. Filesystem contains the basic directory
layout for a Linux operating system, including the correct permissions
for the directories.
%prep
%build
%install
#
#	6.5.  Creating Directories
#
install -vdm 755 %{buildroot}/{dev,proc,run/lock,sys}
install -vdm 755 %{buildroot}/{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt}
install -vdm 755 %{buildroot}/{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 %{buildroot}/root
install -dv -m 1777 %{buildroot}/tmp %{buildroot}/var/tmp
install -vdm 755 %{buildroot}/usr/{,local/}{bin,include,lib,sbin,src}
install -vdm 755 %{buildroot}/usr/{,local/}share/{color,dict,doc,info,locale,man}
install -vdm 755 %{buildroot}/usr/{,local/}share/{misc,terminfo,zoneinfo}
install -vdm 755 %{buildroot}/usr/libexec
install -vdm 755 %{buildroot}/usr/{,local/}share/man/man{1..8}
#	Symlinks for AMD64
%ifarch x86_64
	ln -sv lib %{buildroot}/lib64
	ln -sv lib %{buildroot}/usr/lib64
	ln -sv lib %{buildroot}/usr/local/lib64
%endif
install -vdm 755 %{buildroot}/var/{log,mail,spool}
ln -sv ../run %{buildroot}/var/run
ln -sv ../run/lock %{buildroot}/var/lock
install -vdm 755 %{buildroot}/var/{opt,cache,lib/{color,misc,locate},local}
#
#	6.6. Creating Essential Files and Symlinks
#
ln -sv /proc/self/mounts %{buildroot}/etc/mtab
touch %{buildroot}/etc/mtab
touch %{buildroot}/var/log/{btmp,lastlog,wtmp}
#
#	Configuration files
#
cat > %{buildroot}/etc/passwd <<- "EOF"
	root::0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/dev/null:/bin/false
	nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF
cat > %{buildroot}/etc/group <<- "EOF"
	root:x:0:
	bin:x:1:
	sys:x:2:
	kmem:x:3:
	tape:x:4:
	tty:x:5:
	daemon:x:6:
	floppy:x:7:
	disk:x:8:
	lp:x:9:
	dialout:x:10:
	audio:x:11:
	video:x:12:
	utmp:x:13:
	usb:x:14:
	cdrom:x:15:
	mail:x:34:
	nogroup:x:99:
EOF
touch %{buildroot}/etc/mtab
#
#	7.2.2. Creating Network Interface Configuration Files"
#
cat > %{buildroot}/etc/sysconfig/ifconfig.eth0 <<- "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.1.2
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=255.255.255.0
EOF
#
#	7.2.3. Creating the /etc/resolv.conf File"
#
cat > %{buildroot}/etc/resolv.conf <<- "EOF"
# Begin /etc/resolv.conf

domain example.com
nameserver 192.168.1.1
nameserver 192.168.1.1

# End /etc/resolv.conf
EOF
#
#	7.3. Customizing the /etc/hosts File"
#
cat > %{buildroot}/etc/hosts <<- "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1	localhost
127.0.0.2	lfs.example.com lfs
192.168.1.2	lfs.example.com lfs

# End /etc/hosts (network card version)
EOF
#
#	7.7.1. Configuring Sysvinit"
#
cat > %{buildroot}/etc/inittab <<- "EOF"
# Begin /etc/inittab
id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF
#
#	7.8. Configuring the system hostname
#
echo "HOSTNAME=lfs.example.com" > %{buildroot}/etc/sysconfig/network
#
#	7.9. Configuring the setclock Script"
#
cat > %{buildroot}/etc/sysconfig/clock <<- "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF
#
#	7.10. Configuring the Linux Console"
#
cat > %{buildroot}/etc/sysconfig/console <<- "EOF"
# Begin /etc/sysconfig/console
#       Begin /etc/sysconfig/console
#       KEYMAP="us"
#       FONT="lat1-16 -m utf8"
#       FONT="lat1-16 -m 8859-1"
#       KEYMAP_CORRECTIONS="euro2"
#       UNICODE="1"
#       LEGACY_CHARSET="iso-8859-1"
# End /etc/sysconfig/console
EOF
#
#	7.13. The Bash Shell Startup Files
#
cat > %{buildroot}/etc/profile <<- "EOF"
# Begin /etc/profile

#	export LANG=<ll>_<CC>.<charmap><@modifiers>
#	export LANG=en_US.utf8

# End /etc/profile
EOF

#
#	7.14. Creating the /etc/inputrc File
#
cat > %{buildroot}/etc/inputrc <<- "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF
#
#	8.2. Creating the /etc/fstab File
#
cat > %{buildroot}/etc/fstab <<- "EOF"
#	Begin /etc/fstab
#	hdparm -I /dev/sda | grep NCQ --> can use barrier
#system		mnt-pt		type		options			dump fsck
#/dev/sdxx	/		ext4	defaults,barrier,noatime,noacl,data=ordered 1 1
#/dev/sdxx	/		ext4		defaults		1 1
#/dev/sdxx	/boot		ext4		defaults		1 2
#/dev/sdxx	swap		swap		pri=1			0 0
proc		/proc		proc		nosuid,noexec,nodev	0 0
sysfs		/sys		sysfs		nosuid,noexec,nodev	0 0
devpts		/dev/pts	devpts		gid=5,mode=620		0 0
tmpfs		/run		tmpfs		defaults		0 0
devtmpfs	/dev		devtmpfs	mode=0755,nosuid	0 0
#	mount points
#tmpfs		/tmp		tmpfs		defaults		0 0
#	End /etc/fstab
EOF
#
#	8.3.2. Configuring Linux Module Load Order
#
install -vdm 755 %{buildroot}/etc/modprobe.d
cat > %{buildroot}/etc/modprobe.d/usb.conf <<- "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
#
#		chapter 9.1. The End
#
echo %{version} > %{buildroot}/etc/lfs-release
cat > %{buildroot}/etc/lsb-release <<- "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="7.5"
DISTRIB_CODENAME="Octothorpe"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF
%files
%defattr(-,root,root)
#	Root filesystem
%dir /bin
%dir /boot
%dir /dev
%dir /etc
%dir /home
%dir /lib
%dir /media
%dir /mnt
%dir /opt
%dir /proc
%dir /root
%dir /run
%dir /sbin
%dir /srv
%dir /sys
%dir /tmp
%dir /usr
%dir /var
#	etc fileystem
%dir /etc/opt
%config(noreplace) /etc/fstab
%config(noreplace) /etc/group
%config(noreplace) /etc/hosts
%config(noreplace) /etc/inittab
%config(noreplace) /etc/inputrc
%config(noreplace) /etc/lfs-release
%config(noreplace) /etc/lsb-release
%config(noreplace) /etc/mtab
%config(noreplace) /etc/passwd
%config(noreplace) /etc/profile
%config(noreplace) /etc/resolv.conf
%dir /etc/modprobe.d
%config(noreplace) /etc/modprobe.d/usb.conf
%dir /etc/sysconfig
%config(noreplace) /etc/sysconfig/clock
%config(noreplace) /etc/sysconfig/console
%config(noreplace) /etc/sysconfig/ifconfig.eth0
%config(noreplace) /etc/sysconfig/network
#	media filesystem
%dir /media/cdrom
%dir /media/floppy
#	run filesystem
%dir /run/lock
#	usr filesystem
%dir /usr/bin
%dir /usr/include
%dir /usr/lib
%dir /usr/libexec
%dir /usr/local
%dir /usr/local/bin
%dir /usr/local/include
%dir /usr/local/lib
%dir /usr/local/share
%dir /usr/local/share/color
%dir /usr/local/share/dict
%dir /usr/local/share/doc
%dir /usr/local/share/info
%dir /usr/local/share/locale
%dir /usr/local/share/man
%dir /usr/local/share/man/man1
%dir /usr/local/share/man/man2
%dir /usr/local/share/man/man3
%dir /usr/local/share/man/man4
%dir /usr/local/share/man/man5
%dir /usr/local/share/man/man6
%dir /usr/local/share/man/man7
%dir /usr/local/share/man/man8
%dir /usr/local/share/misc
%dir /usr/local/share/terminfo
%dir /usr/local/share/zoneinfo
%dir /usr/local/src
%dir /usr/sbin
%dir /usr/share
%dir /usr/share/color
%dir /usr/share/dict
%dir /usr/share/doc
%dir /usr/share/info
%dir /usr/share/locale
%dir /usr/share/man
%dir /usr/share/man/man1
%dir /usr/share/man/man2
%dir /usr/share/man/man3
%dir /usr/share/man/man4
%dir /usr/share/man/man5
%dir /usr/share/man/man6
%dir /usr/share/man/man7
%dir /usr/share/man/man8
%dir /usr/share/misc
%dir /usr/share/terminfo
%dir /usr/share/zoneinfo
%dir /usr/src
#	var filesystem
%dir /var/cache
%dir /var/lib
%dir /var/lib/color
%dir /var/lib/locate
%dir /var/lib/misc
%dir /var/local
%dir /var/log
%dir /var/mail
%dir /var/opt
%dir /var/spool
%dir /var/tmp
%attr(-,root,root) 	/var/log/wtmp
%attr(664,root,utmp)	/var/log/lastlog
%attr(600,root,root)	/var/log/btmp
/var/lock
/var/run
/var/run/lock
#	Symlinks for AMD64
%ifarch x86_64
/lib64
/usr/lib64
/usr/local/lib64
%endif
%changelog
*	Tue Jun 17 2014 baho-utot <baho-utot@columbus.rr.com> 7.5-1
*	Fri Apr 19 2013 baho-utot <baho-utot@columbus.rr.com> 20130401-1
-	Upgrade version
