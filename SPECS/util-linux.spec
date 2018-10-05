Summary:	Utilities for file systems, consoles, partitions, and messages
Name:		util-linux
Version:	2.24.1
Release:	1
URL:		http://www.kernel.org/pub/linux/utils/util-linux
License:	GPLv2
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
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

