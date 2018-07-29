Summary:	The Linux package contains the Linux kernel.
Name:		linux
Version:	4.15.3
Release:	1
License:	GPLv2
URL:		https://www.kernel.org
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	https://www.kernel.org/pub/linux/kernel/v4.x/%{name}-%{version}.tar.xz
%description
	The Linux package contains the Linux kernel.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	make mrproper
	make defconfig
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} INSTALL_MOD_PATH=%{buildroot} modules_install
	install -vdm 755 %{buildroot}/boot
	cp -v arch/x86/boot/bzImage %{buildroot}/boot/vmlinuz-%{version}
	cp -v System.map %{buildroot}/boot/System.map-%{version}
	cp -v .config %{buildroot}/boot/config-%{version}
	install -d %{buildroot}%{_docdir}/%{NAME}-%{VERSION}
	cp -r Documentation/* %{buildroot}%{_docdir}/%{NAME}-%{version}
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
#	%%{_infodir}/*.gz
#	%%{_mandir}/man1/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 4.15.3-1
-	Initial build.	First version
