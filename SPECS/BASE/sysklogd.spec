Summary:	The Sysklogd package contains programs for logging system messages
Name:		sysklogd
Version:	1.5.1
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://www.infodrom.org/projects/sysklogd/download/%{name}-%{version}.tar.gz
%description
	The Sysklogd package contains programs for logging system messages, such as those 
	given by the kernel when unusual things happen. 
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
	sed -i 's/union wait/int/' syslogd.c
%build
	make VERBOSE=1 
%install
	install -vdm 755 %{buildroot}/usr/share/man/man{5,8}
	install -vdm 755 %{buildroot}/usr/sbin
	install -vdm 755 %{buildroot}/usr/include/sysklogd
	install -vdm 755 %{buildroot}/sbin
	make install prefix=%{buildroot} \
	TOPDIR=%{buildroot} \
	MANDIR=%{buildroot}/usr/share/man \
	BINDIR=%{buildroot}/sbin \
	MAN_USER=`id -nu` MAN_GROUP=`id -ng`
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version