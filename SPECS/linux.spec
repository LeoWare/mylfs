Summary:	Kernel
Name:		linux
Version:	3.13.3
Release:	1
License:	GPLv2
URL:		http://www.kernel.org/
Group:		System Environment/Kernel
Vendor:		Bildanet
Distribution:	Octothorpe
Source0:	http://www.kernel.org/pub/linux/kernel/v3.x/%{name}-%{version}.tar.xz
#Source1:	config-%{version}-generic.amd64
%description
The Linux package contains the Linux kernel.
%prep
%setup -q
%build
make mrproper
cp %{_topdir}/config .config
make LC=ALL= oldconfig
#make LC_ALL= silentoldconfig
#make LC_ALL= defconfig
make VERBOSE=1 %{?_smp_mflags}
%install
install -vdm 755 %{buildroot}/etc
install -vdm 755 %{buildroot}/boot
install -vdm 755 %{buildroot}%{_defaultdocdir}/%{name}-%{version}
install -vdm 755 %{buildroot}/etc/modprobe.d
make INSTALL_MOD_PATH=%{buildroot} modules_install
cp -v arch/x86/boot/bzImage	%{buildroot}/boot/vmlinuz-%{version}
cp -v System.map		%{buildroot}/boot/system.map-%{version}
cp -v .config			%{buildroot}/boot/config-%{version}
cp -r Documentation/*		%{buildroot}%{_defaultdocdir}/%{name}-%{version}

cat > %{buildroot}/etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
#	Cleanup dangling symlinks
rm -rf %{buildroot}/lib/modules/%{version}/source
rm -rf %{buildroot}/lib/modules/%{version}/build
%files
%defattr(-,root,root)
/boot/system.map-%{version}
/boot/config-%{version}
/boot/vmlinuz-%{version}
%config(noreplace)/etc/modprobe.d/usb.conf
/lib/firmware/*
/lib/modules/*
%{_defaultdocdir}/%{name}-%{version}/*
%changelog
*	Wed Apr 09 2014 baho-utot <baho-utot@columbus.rr.com> 3.13.3-1
*	Sat Aug 31 2013 baho-utot <baho-utot@columbus.rr.com> 3.10.10-1
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.10.9-1
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 3.9.7-1
*	Wed May 15 2013 baho-utot <baho-utot@columbus.rr.com> 3.9.2-1
*	Sat May 11 2013 baho-utot <baho-utot@columbus.rr.com> 3.9.1-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 3.9-1
*	Mon Apr 1  2013 baho-utot <baho-utot@columbus.rr.com> 3.8.5-1
*	Thu Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 3.8.1-1
-	Upgrade version
