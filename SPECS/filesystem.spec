Summary:	Default file system
Name:		filesystem
Version:	8.2_systemd
Release:	1
License:	GPLv3
Group:		System Environment/Base
Vendor:		Bonsai
URL:		http://www.linuxfromscratch.org
Distribution:	LFS
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
install -vdm 755 %{buildroot}/{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
install -vdm 755 %{buildroot}/{media/{floppy,cdrom},sbin,srv,var}
install -vdm 0750 %{buildroot}/root
install -vdm 1777 %{buildroot}/tmp %{buildroot}/var/tmp
install -vdm 755 %{buildroot}/usr/{,local/}{bin,include,lib,sbin,src}
install -vdm 755 %{buildroot}/usr/{,local/}share/{color,dict,doc,info,locale,man}
install -vdm 755 %{buildroot}/usr/{,local/}share/{misc,terminfo,zoneinfo}
install -vdm 755 %{buildroot}/usr/libexec
install -vdm 755 %{buildroot}/usr/{,local/}share/man/man{1..8}

#	Symlinks for x86_64
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

ln -sv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} %{buildroot}/bin
ln -sv /tools/bin/{install,perl} %{buildroot}/usr/bin

sed 's/tools/usr/' /tools/lib/libstdc++.la > %{buildroot}/usr/lib/libstdc++.la
for lib in blkid lzma mount uuid
do
    ln -sv /tools/lib/lib$lib.{a,so*} %{buildroot}/usr/lib
    sed 's/tools/usr/' /tools/lib/lib${lib}.la > %{buildroot}/usr/lib/lib${lib}.la
done
ln -sv bash %{buildroot}/bin/sh

ln -sv /proc/self/mounts %{buildroot}/etc/mtab
touch %{buildroot}/etc/mtab
touch %{buildroot}/var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp %{buildroot}/var/log/lastlog
chmod -v 664  %{buildroot}/var/log/lastlog
chmod -v 600  %{buildroot}/var/log/btmp

#
#	Configuration files
#
cat > %{buildroot}/etc/passwd <<- "EOF"
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/dev/null:/bin/false
	daemon:x:6:6:Daemon User:/dev/null:/bin/false
	messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
	systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
	systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
	systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
	systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
	systemd-network:x:76:76:systemd Network Management:/:/bin/false
	systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
	systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
	systemd-coredump:x:79:79:systemd Core Dumper:/:/bin/false
	nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > %{buildroot}/etc/group <<- "EOF"
	root:x:0:
	bin:x:1:daemon
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
	adm:x:16:
	messagebus:x:18:
	systemd-journal:x:23:
	input:x:24:
	mail:x:34:
	systemd-bus-proxy:x:72:
	systemd-journal-gateway:x:73:
	systemd-journal-remote:x:74:
	systemd-journal-upload:x:75:
	systemd-network:x:76:
	systemd-resolve:x:77:
	systemd-timesync:x:78:
	systemd-coredump:x:79:
	nogroup:x:99:
	users:x:999:
EOF

# Why are we doing this again here?
touch %{buildroot}/etc/mtab

#
#	7.2.1. Creating Network Interface Configuration Files"
#
install -vdm 755 %{buildroot}/etc/systemd/network
cat > %{buildroot}/etc/systemd/network/10-eth0-dhcp.network <<- "EOF"
[Match]
Name=eth0

[Network]
DHCP=ipv4

[DHCP]
UseDomains=true
EOF
#
#	7.2.2. Creating the /etc/resolv.conf File"
#
ln -sfv /run/systemd/resolve/resolv.conf %{buildroot}/etc/resolv.conf

#
#	7.2.3 Configuring the system hostname
#
echo "lfs" > %{buildroot}/etc/hostname

#
#	7.2.4. Customizing the /etc/hosts File"
#
cat > %{buildroot}/etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost
127.0.1.1 lfs.localhost lfs
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts (network card version)
EOF

#
#	7.5 Configuring the system clock
#
#	uncomment if your hardware clock is set to local time
#cat > %{buildroot}/etc/adjtime << "EOF"
#0.0 0 0.0
#0
#LOCAL
#EOF

#
#	7.6. Configuring the Linux Console"
#
cat > %{buildroot}/etc/vconsole.conf << "EOF"
KEYMAP=us
FONT=LatArCyrHeb
EOF

#
#	7.7 Configuring the system locale
#
cat > %{buildroot}/etc/locale.conf << "EOF"
LANG=en_US.UTF-8
EOF

#
#	7.8 Creating the /etc/inputrc file
#
cat > %{buildroot}/etc/inputrc << "EOF"
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
#	7.9 Creating the /etc/shells file
#
cat > %{buildroot}/etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

#
#	7.10.1 Disabling the screen clearing at boot time
#
install -vdm 644 %{buildroot}/etc/systemd/system/getty@tty1.service.d

cat > %{buildroot}/etc/systemd/system/getty@tty1.service.d/noclear.conf << EOF
[Service]
TTYVTDisallocate=no
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
#	8.2 Creating the /etc/fstab file
#
cat > %{buildroot}/etc/fstab <<- "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

#/dev/<xxx>     /            <fff>    defaults            1     1
#/dev/<yyy>     swap         swap     pri=1               0     0

# End /etc/fstab
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
cat > %{buildroot}/etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="8.2-systemd"
ID=lfs
PRETTY_NAME="Linux From Scratch 8.1-systemd"
VERSION_CODENAME="LFS"
EOF

echo %{version} > %{buildroot}/etc/lfs-release

cat > %{buildroot}/etc/lsb-release <<- "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="8.1-systemd"
DISTRIB_CODENAME="LFS"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF

%post
# these lines moved from above to %post. these files conflict with gcc later on.
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
#rm -fv %{buildroot}/usr/lib/libstdc++.la

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
%config(noreplace) /etc/hostname
%config(noreplace) /etc/hosts
%config(noreplace) /etc/inputrc
%config(noreplace) /etc/lfs-release
%config(noreplace) /etc/locale.conf
%config(noreplace) /etc/lsb-release
%config(noreplace) /etc/mtab
%config(noreplace) /etc/os-release
%config(noreplace) /etc/passwd
%config(noreplace) /etc/profile
%config(noreplace) /etc/resolv.conf
%config(noreplace) /etc/shells
%dir /etc/modprobe.d
%config(noreplace) /etc/modprobe.d/usb.conf
%config(noreplace) /etc/systemd/network/10-eth0-dhcp.network
%config(noreplace) /etc/systemd/system/getty@tty1.service.d/noclear.conf
%config(noreplace) /etc/vconsole.conf
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
/bin/bash
/bin/cat
/bin/dd
/bin/echo
/bin/ln
/bin/pwd
/bin/rm
/bin/sh
/bin/stty

/usr/bin/install
/usr/bin/perl
/usr/lib/libblkid.a
/usr/lib/libblkid.la
/usr/lib/libblkid.so
/usr/lib/libblkid.so.1
/usr/lib/libblkid.so.1.1.0
#/usr/lib/libgcc_s.so
#/usr/lib/libgcc_s.so.1
/usr/lib/liblzma.a
/usr/lib/liblzma.la
/usr/lib/liblzma.so
/usr/lib/liblzma.so.5
/usr/lib/liblzma.so.5.2.3
/usr/lib/libmount.a
/usr/lib/libmount.la
/usr/lib/libmount.so
/usr/lib/libmount.so.1
/usr/lib/libmount.so.1.1.0
#/usr/lib/libstdc++.a
/usr/lib/libstdc++.la
#/usr/lib/libstdc++.so
#/usr/lib/libstdc++.so.6
/usr/lib/libuuid.a
/usr/lib/libuuid.la
/usr/lib/libuuid.so
/usr/lib/libuuid.so.1
/usr/lib/libuuid.so.1.3.0
/var/log/faillog
#	Symlinks for x86_64
%ifarch x86_64
/lib64
/usr/lib64
/usr/local/lib64
%endif
%changelog
*	Tue Jun 17 2014 baho-utot <baho-utot@columbus.rr.com> 7.5-1
*	Fri Apr 19 2013 baho-utot <baho-utot@columbus.rr.com> 20130401-1
-	Upgrade version
