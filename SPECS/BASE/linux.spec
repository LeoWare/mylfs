Summary:	The Linux package contains the Linux kernel. 
Name:		linux
Version:	4.9.67
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	https://www.kernel.org/pub/linux/kernel/v4.x/%{name}-%{version}.tar.xz
%define		_configfile	config-%{VERSION}
%description
	The Linux package contains the Linux kernel. 
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	make mrproper
	#	make menuconfig
	cp ${RPM_SOURCE_DIR}/%{_configfile} .config
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} INSTALL_MOD_PATH=%{buildroot} modules_install
	install -vdm 755 %{buildroot}/boot
	cp -v arch/x86/boot/bzImage %{buildroot}/boot/vmlinuz-%{VERSION}-lfs-8.1
	cp -v System.map %{buildroot}/boot/System.map-%{VERSION}
	cp -v .config %{buildroot}/boot/%{_configfile}
	install -d %{buildroot}/usr/share/doc/%{NAME}-%{VERSION}
	cp -r Documentation/* %{buildroot}/usr/share/doc/%{NAME}-%{VERSION}
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version