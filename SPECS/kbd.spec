Summary:	Key table files, console fonts, and keyboard utilities
Name:		kbd
Version:	2.0.1
Release:	0
License:	GPLv2
URL:		http://ftp.altlinux.org/pub/people/legion/kbd
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.altlinux.org/pub/people/legion/kbd/%{name}-%{version}.tar.gz
Patch0:		kbd-2.0.1-backspace-1.patch
%description
The Kbd package contains key-table files, console fonts, and keyboard utilities.
%prep
%setup -q
%patch0 -p1
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //'  docs/man/man8/Makefile.in
%build
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
./configure \
	--prefix=%{_prefix} \
	--disable-vlock \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}%{_defaultdocdir}/%{name}-%{version}
cp -R -v docs/doc/* %{buildroot}%{_defaultdocdir}/%{name}-%{version}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_datarootdir}/consolefonts/*
%{_datarootdir}/consoletrans/*
%{_datarootdir}/keymaps/*
%{_datarootdir}/unimaps/*
%{_mandir}/*/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 2.0.1-0
*	Thu Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 1.15.5-1
-	Upgrade version
