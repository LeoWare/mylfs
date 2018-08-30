<<<<<<< HEAD
Summary:	The Util-linux package contains miscellaneous utility programs.
Name:		util-linux
Version:	2.31.1
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	https://www.kernel.org/pub/linux/utils/util-linux/v2.31/%{name}-%{version}.tar.xz
%description
	The Util-linux package contains miscellaneous utility programs.
	Among them are utilities for handling file systems, consoles,
	partitions, and messages.
%prep
%setup -q -n %{NAME}-%{VERSION}
#	mkdir -pv %{buildroot}/var/lib/hwclock
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
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm	
%files -f filelist.rpm
	%defattr(-,root,root)
	%dir	/var/lib/hwclock
#	%%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
	%{_mandir}/man3/*.gz
	%{_mandir}/man5/*.gz
	%{_mandir}/man8/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.31.1-1
-	Initial build.	First version
=======
Summary:	Utilities for file systems, consoles, partitions, and messages
Name:		util-linux
Version:	2.24.1
Release:	1
URL:		http://www.kernel.org/pub/linux/utils/util-linux
License:	GPLv2
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		%{name}-%{version}.tar.xz
%description
Utilities for handling file systems, consoles, partitions,
and messages.
%prep
%setup -q
sed -i -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' $(grep -rl '/etc/adjtime' .)
%build
./configure \
	--disable-nologin \
	--disable-silent-rules
make %{?_smp_mflags}
%install
install -vdm 755 %{buildroot}%{_sharedstatedir}/hwclock
make DESTDIR=%{buildroot} install
find %{buildroot} -name '*.la' -delete
%find_lang %{name}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
%dir %{_sharedstatedir}/hwclock
/bin/*
%{_lib}/*
/sbin/*
%{_bindir}/*
%{_libdir}/*
%{_includedir}/*
%{_sbindir}/*
%{_mandir}/*/*
%{_datadir}/bash-completion/completions/*
%{_datadir}/doc/util-linux/getopt/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 2.24.1-1
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 2.23.2-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 2.23-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.22.2-1
-	Upgrade version

>>>>>>> Initial Commit.
