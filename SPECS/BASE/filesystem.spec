Summary:	Default file system
Name:		filesystem
Version:	8.1
Release:	1
License:	MIT
Group:		LFS/Base
Vendor:		Bildanet
URL:		http://www.linuxfromscratch.org
Distribution:	Octothorpe
BuildArch:	noarch

%description
The filesystem package is one of the basic packages that is installed
on a Linux system. Filesystem contains the basic directory
layout for a Linux operating system, including the correct permissions
for the directories.

%prep
%build

%install
	#
	#	6.2. Preparing Virtual Kernel File Systems
	#
	install -vdm 755	%{buildroot}/{dev,proc,sys,run}
	mknod -m 600 		%{buildroot}/dev/console c 5 1
	mknod -m 666 		%{buildroot}/dev/null c 1 3
	#
	#	6.5.  Creating Directories
	#
	install -vdm 755	%{buildroot}/{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
	install -vdm 755	%{buildroot}/{media/{floppy,cdrom},sbin,srv,var}
	install -dv -m 0750 	%{buildroot}/root
	install -dv -m 1777 	%{buildroot}/tmp %{buildroot}/var/tmp
	install -vdm 755 	%{buildroot}/usr/{,local/}{bin,include,lib,sbin,src}
	install -vdm 755 	%{buildroot}/usr/{,local/}share/{color,dict,doc,info,locale,man}
	install -vdm 755 	%{buildroot}/usr/{,local/}share/{misc,terminfo,zoneinfo}
	install -vdm 755 	%{buildroot}/usr/libexec
	install -vdm 755 	%{buildroot}/usr/{,local/}share/man/man{1..8}
	install -vdm 755 %{buildroot}/lib64
	install -vdm 755 %{buildroot}/var/{log,mail,spool}
	install -vdm 755 %{buildroot}/run
	ln -sv /run %{buildroot}/var/run
	ln -sv /run/lock %{buildroot}/var/lock
	install -vdm 755 %{buildroot}/var/{opt,cache,lib/{color,misc,locate},local}
	#	mounted filesystems
	ln -sv /proc/self/mounts %{buildroot}/etc/mtab
	#
	#	6.6. Creating Essential Files and Symlinks
	#
	cat > %{buildroot}/etc/passwd <<- "EOF"
		root::0:0:root:/root:/bin/bash
		bin:x:1:1:bin:/dev/null:/bin/false
		daemon:x:6:6:Daemon User:/dev/null:/bin/false
		messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
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
		nogroup:x:99:
		users:x:999:
	EOF
	touch %{buildroot}/var/log/{btmp,lastlog,faillog,wtmp}
	#	6.9.2.1. Adding nsswitch.conf 
	cat > %{buildroot}/etc/nsswitch.conf <<- "EOF"
		# Begin /etc/nsswitch.conf

		passwd: files
		group: files
		shadow: files

		hosts: files dns
		networks: files

		protocols: files
		services: files
		ethers: files
		rpc: files

		# End /etc/nsswitch.conf
	EOF
	#	6.9.2.3. Configuring the Dynamic Loader
	cat > %{buildroot}/etc/ld.so.conf <<- "EOF"
		# Begin /etc/ld.so.conf
		/usr/local/lib
		/opt/lib

	EOF
	cat >> %{buildroot}/etc/ld.so.conf <<- "EOF"
		# Add an include directory
		include /etc/ld.so.conf.d/*.conf

	EOF
	install -vdm 755 %{buildroot}/etc/ld.so.conf.d
	#
	#	6.63.2. Configuring Sysklogd 
	#
	cat > %{buildroot}/etc/syslog.conf <<- "EOF"
		# Begin /etc/syslog.conf

		auth,authpriv.* -/var/log/auth.log
		*.*;auth,authpriv.none -/var/log/sys.log
		daemon.* -/var/log/daemon.log
		kern.* -/var/log/kern.log
		mail.* -/var/log/mail.log
		user.* -/var/log/user.log
		*.emerg *

		# End /etc/syslog.conf
	EOF
	#
	#	7.5.1. Creating Network Interface Configuration Files
	#
	cat > %{buildroot}/etc/sysconfig/ifconfig.eth0 <<- "EOF"
		ONBOOT=yes
		IFACE=eth0
		SERVICE=ipv4-static
		IP=192.168.1.2
		GATEWAY=192.168.1.1
		PREFIX=24
		BROADCAST=192.168.1.255
	EOF
	#
	#	7.5.2. Creating the /etc/resolv.conf File
	#
	cat > %{buildroot}/etc/resolv.conf <<- "EOF"
		# Begin /etc/resolv.conf

		domain <Your Domain Name>
		nameserver <IP address of your primary nameserver>
		nameserver <IP address of your secondary nameserver>

		# End /etc/resolv.conf
	EOF
	#
	#	7.5.3. Configuring the system hostname 
	#
	echo "<lfs>" > %{buildroot}/etc/hostname
	#
	#	7.5.4. Customizing the /etc/hosts File 
	#
	cat > %{buildroot}/etc/hosts <<- "EOF"
		# Begin /etc/hosts

		127.0.0.1	localhost
		127.0.1.1	<FQDN> <HOSTNAME>
		<192.168.1.1>	<FQDN> <HOSTNAME> [alias1] [alias2 ...]
		::1		localhost ip6-localhost ip6-loopback
		ff02::1		ip6-allnodes
		ff02::2		ip6-allrouters

		# End /etc/hosts
	EOF
	#
	#	7.6.2. Configuring Sysvinit 
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
	#	7.6.4. Configuring the System Clock 
	#
	cat >  %{buildroot}/etc/sysconfig/clock <<- "EOF"
		# Begin /etc/sysconfig/clock

		# Change the value of the UTC variable below to a value of
		# 0 (zero) if the hardware clock is not set to UTC time.

		UTC=1

		# Set this to any options you might need to give to hwclock,
		# such as machine hardware clock type for Alphas.
		CLOCKPARAMS=

		# End /etc/sysconfig/clock
	EOF
	#
	#	7.6.5. Configuring the Linux Console 
	#
	#
	#	7.6.8. The rc.site File
	#
	cat >  %{buildroot}/etc/sysconfig/rc.site <<- "EOF"
		# rc.site
		# Optional parameters for boot scripts.

		# Distro Information
		# These values, if specified here, override the defaults
		#DISTRO="Linux From Scratch" # The distro name
		#DISTRO_CONTACT="lfs-dev@linuxfromscratch.org" # Bug report address
		#DISTRO_MINI="LFS" # Short name used in filenames for distro config

		# Define custom colors used in messages printed to the screen

		# Please consult `man console_codes` for more information
		# under the "ECMA-48 Set Graphics Rendition" section
		#
		# Warning: when switching from a 8bit to a 9bit font,
		# the linux console will reinterpret the bold (1;) to
		# the top 256 glyphs of the 9bit font.  This does
		# not affect framebuffer consoles

		# These values, if specified here, override the defaults
		#BRACKET="\\033[1;34m" # Blue
		#FAILURE="\\033[1;31m" # Red
		#INFO="\\033[1;36m"    # Cyan
		#NORMAL="\\033[0;39m"  # Grey
		#SUCCESS="\\033[1;32m" # Green
		#WARNING="\\033[1;33m" # Yellow

		# Use a colored prefix
		# These values, if specified here, override the defaults
		#BMPREFIX="     "
		#SUCCESS_PREFIX="${SUCCESS}  *  ${NORMAL}"
		#FAILURE_PREFIX="${FAILURE}*****${NORMAL}"
		#WARNING_PREFIX="${WARNING} *** ${NORMAL}"

		# Manually seet the right edge of message output (characters)
		# Useful when resetting console font during boot to override
		# automatic screen width detection
		#COLUMNS=120

		# Interactive startup
		#IPROMPT="yes" # Whether to display the interactive boot prompt
		#itime="3"    # The amount of time (in seconds) to display the prompt

		# The total length of the distro welcome string, without escape codes
		#wlen=$(echo "Welcome to ${DISTRO}" | wc -c )
		#welcome_message="Welcome to ${INFO}${DISTRO}${NORMAL}"

		# The total length of the interactive string, without escape codes
		#ilen=$(echo "Press 'I' to enter interactive startup" | wc -c )
		#i_message="Press '${FAILURE}I${NORMAL}' to enter interactive startup"

		# Set scripts to skip the file system check on reboot
		#FASTBOOT=yes

		# Skip reading from the console
		#HEADLESS=yes

		# Write out fsck progress if yes
		#VERBOSE_FSCK=no

		# Speed up boot without waiting for settle in udev
		#OMIT_UDEV_SETTLE=y

		# Speed up boot without waiting for settle in udev_retry
		#OMIT_UDEV_RETRY_SETTLE=yes

		# Skip cleaning /tmp if yes
		#SKIPTMPCLEAN=no

		# For setclock
		#UTC=1
		#CLOCKPARAMS=

		# For consolelog (Note that the default, 7=debug, is noisy)
		#LOGLEVEL=7

		# For network
		#HOSTNAME=mylfs

		# Delay between TERM and KILL signals at shutdown
		#KILLDELAY=3

		# Optional sysklogd parameters
		#SYSKLOGD_PARMS="-m 0"

		# Console parameters
		#UNICODE=1
		#KEYMAP="de-latin1"
		#KEYMAP_CORRECTIONS="euro2"
		#FONT="lat0-16 -m 8859-15"
		#LEGACY_CHARSET=

	EOF
	#
	#	7.7. The Bash Shell Startup Files 
	#
	cat > %{buildroot}/etc/profile <<- "EOF"
		# Begin /etc/profile

		#export LANG=<ll>_<CC>.<charmap><@modifiers>

		export LANG=en_US.iso88591
		#export LANG=en_utf8

		# End /etc/profile
	EOF
	#
	#	7.8. Creating the /etc/inputrc File
	#
	cat >  %{buildroot}/etc/inputrc <<- "EOF"
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
	#	7.9. Creating the /etc/shells File
	#
	cat >  %{buildroot}/etc/shells <<- "EOF"
		# Begin /etc/shells

		/bin/sh
		/bin/bash

		# End /etc/shells
	EOF
	#
	#	8.2. Creating the /etc/fstab File 
	#
	cat > %{buildroot}/etc/fstab <<- "EOF"
		# Begin /etc/fstab

		#	hdparm -I /dev/sda | grep NCQ --> can use barrier
		# file system  mount-point  type     options                                     dump  fsck
		#                                                                                      order
		#/dev/sdxx     /            ext4     defaults,barrier,noatime,noacl,data=ordered 1     1
		#/dev/sdxx     /            ext4     defaults                                    1     1
		#/dev/sdxx     /boot        ext4     defaults                                    1     2
		/dev/<xxx>     /            <fff>    defaults                                    1     1
		/dev/<yyy>     swap         swap     pri=1                                       0     0
		proc           /proc        proc     nosuid,noexec,nodev                         0     0
		sysfs          /sys         sysfs    nosuid,noexec,nodev                         0     0
		devpts         /dev/pts     devpts   gid=5,mode=620                              0     0
		tmpfs          /run         tmpfs    defaults                                    0     0
		devtmpfs       /dev         devtmpfs mode=0755,nosuid                            0     0
		#tmpfs         /tmp         tmpfs    defaults                                    0     0

		# End /etc/fstab
	EOF
	#
	#	8.3.2. Configuring Linux Module Load Order 
	#
	install -v -m755 -d %{buildroot}/etc/modprobe.d
	cat > %{buildroot}/etc/modprobe.d/usb.conf <<- "EOF"
		# Begin /etc/modprobe.d/usb.conf

		install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
		install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

		# End /etc/modprobe.d/usb.conf
	EOF
	#
	#	9.1. The End 
	#
	echo 8.1 > %{buildroot}/etc/lfs-release
	cat > %{buildroot}/etc/lsb-release <<- "EOF"
		DISTRIB_ID="Linux From Scratch"
		DISTRIB_RELEASE="8.1"
		DISTRIB_CODENAME="<your name here>"
		DISTRIB_DESCRIPTION="Linux From Scratch"
	EOF
%files
	%defattr(-,root,root)
   #
   #	Directories
   #
   /home
   %dir %attr(750,root,root) /root
   %dir	/mnt
   %dir	/boot
   %dir	/var
   %dir	/var/log
   %dir	/var/mail
   %dir	/var/local
   %dir	/var/spool
   %dir	/var/cache
   %dir	/var/lib
   %dir	/var/lib/locate
   %dir	/var/lib/misc
   %dir	/var/lib/color
   %dir	/var/opt
   %dir	%attr(1777,root,root) /var/tmp
   %dir	/etc
   %dir	/etc/sysconfig
   %dir	/etc/opt
   %dir	/lib64
   %dir	/usr
   %dir	/usr/src
   %dir	/usr/local
   %dir	/usr/local/src
   %dir	/usr/local/bin
   %dir	/usr/local/sbin
   %dir	/usr/local/lib
   %dir	/usr/local/share
   %dir	/usr/local/share/misc
   %dir	/usr/local/share/terminfo
   %dir	/usr/local/share/doc
   %dir	/usr/local/share/zoneinfo
   %dir	/usr/local/share/man
   %dir	/usr/local/share/man/man3
   %dir	/usr/local/share/man/man4
   %dir	/usr/local/share/man/man7
   %dir	/usr/local/share/man/man1
   %dir	/usr/local/share/man/man6
   %dir	/usr/local/share/man/man8
   %dir	/usr/local/share/man/man5
   %dir	/usr/local/share/man/man2
   %dir	/usr/local/share/locale
   %dir	/usr/local/share/dict
   %dir	/usr/local/share/color
   %dir	/usr/local/share/info
   %dir	/usr/local/include
   %dir	/usr/bin
   %dir	/usr/sbin
   %dir	/usr/lib
   %dir	/usr/libexec
   %dir	/usr/share
   %dir	/usr/share/misc
   %dir	/usr/share/terminfo
   %dir	/usr/share/doc
   %dir	/usr/share/zoneinfo
   %dir	/usr/share/man
   %dir	/usr/share/man/man3
   %dir	/usr/share/man/man4
   %dir	/usr/share/man/man7
   %dir	/usr/share/man/man1
   %dir	/usr/share/man/man6
   %dir	/usr/share/man/man8
   %dir	/usr/share/man/man5
   %dir	/usr/share/man/man2
   %dir	/usr/share/locale
   %dir	/usr/share/dict
   %dir	/usr/share/color
   %dir	/usr/share/info
   %dir	/usr/include
   %dir	/bin
   %dir	/media
   %dir	/media/floppy
   %dir	/media/cdrom
   %dir	/sbin
   %dir	/srv
   %dir	/lib
   %dir	/lib/firmware
   %dir	/dev
   %dir	/opt
   %dir	/sys
   %dir	%attr(1777,root,root) /tmp
   %dir	/proc
   %dir	/run
   #
   #	Files
   #
   %config(noreplace)	/etc/group
   %config(noreplace)	/etc/passwd
   %config(noreplace)	/etc/syslog.conf
   %config(noreplace)	/etc/fstab
   %config(noreplace)	/etc/hostname
   %config(noreplace)	/etc/hosts
   %config(noreplace)	/etc/inittab
   %config(noreplace)	/etc/inputrc
   %config(noreplace)	/etc/lfs-release
   %config(noreplace)	/etc/lsb-release
   %config(noreplace)	/etc/modprobe.d/usb.conf
   %config(noreplace)	/etc/profile
   %config(noreplace)	/etc/resolv.conf
   %config(noreplace)	/etc/shells
   %config(noreplace)	/etc/sysconfig/clock
   %config(noreplace)	/etc/sysconfig/ifconfig.eth0
   %config(noreplace)	/etc/sysconfig/rc.site
   %config(noreplace)	/etc/ld.so.conf
   %config(noreplace)	/etc/nsswitch.conf
   /etc/mtab
   /var/log/faillog
   /var/lock
   /var/run
   %attr(600,root,root)	/var/log/btmp
   %attr(664,root,utmp) /var/log/lastlog
   %attr(-,root,root)	/var/log/wtmp
%changelog
*	Tue Dec 12 2017 baho-utot <baho-utot@columbus.rr.com> 8.1-1
-	Update to LFS-8.1
*	Tue Jun 17 2014 baho-utot <baho-utot@columbus.rr.com> 7.5-1
*	Fri Apr 19 2013 baho-utot <baho-utot@columbus.rr.com> 20130401-1
-	Upgrade version
