#TARBALL:	https://www.kernel.org/pub/linux/utils/util-linux/v2.31/util-linux-2.31.1.tar.xz
#MD5SUM:	7733b583dcb51518944d42aa62ef19ea;SOURCES/util-linux-2.31.1.tar.xz
#-----------------------------------------------------------------------------
Summary:	The Util-linux package contains miscellaneous utility programs.
Name:		util-linux
Version:	2.31.1
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	https://www.kernel.org/pub/linux/utils/util-linux/v2.31/%{name}-%{version}.tar.xz
%description
The Util-linux package contains miscellaneous utility programs.
Among them are utilities for handling file systems, consoles,
partitions, and messages.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		ADJTIME_PATH=/var/lib/hwclock/adjtime   \
		--docdir=%{_docdir}/%{NAME}-%{VERSION} \
		--disable-chfn-chsh  \
		--disable-login \
		--disable-nologin \
		--disable-su \
		--disable-setpriv \
		--disable-runuser \
		--disable-pylibmount \
		--disable-static \
		--without-python \
		--without-systemd \
		--without-systemdsystemunitdir
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	mkdir -pv %{buildroot}/var/lib/hwclock
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
	#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%dir	/var/lib/hwclock
#	%%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
	%{_mandir}/man3/*.gz
	%{_mandir}/man5/*.gz
	%{_mandir}/man8/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.31.1-1
-	Initial build.	First version
