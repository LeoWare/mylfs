Summary:	The Sysklogd package contains programs for logging system messages
Name:		sysklogd
Version:	1.5.1
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	patch
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
	install -vdm 755 %{buildroot}%{_mandir}/man{5,8}
	install -vdm 755 %{buildroot}%{_sbindir}
	install -vdm 755 %{buildroot}%{_includedir}/%{NAME}
	install -vdm 755 %{buildroot}/sbin
	make install prefix=%{buildroot} \
	TOPDIR=%{buildroot} \
	MANDIR=%{buildroot}%{_mandir} \
	BINDIR=%{buildroot}/sbin \
	MAN_USER=`id -nu` MAN_GROUP=`id -ng`
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
	%{_mandir}/man5/*.gz
	%{_mandir}/man8/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.5.1-1
-	Initial build.	First version
