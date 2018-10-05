Summary:	Package manager
Name:		rpm
Version:	4.11.2
Release:	1
License:	GPLv2
URL:		http://rpm.org
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	http://rpm.org/releases/rpm-4.11.x/%{name}-%{version}.tar.bz2
Source1:	http://download.oracle.com/berkeley-db/db-6.0.20.tar.gz
#Source2:	rpm.conf
%description
RPM package manager
%prep
%setup -q
%setup -q -T -D -a 1
mv db-6.0.20 db
%build
./autogen.sh --noconfigure
./configure \
	CPPFLAGS='-I/usr/include/nspr -I/usr/include/nss' \
        --program-prefix= \
        --prefix=%{_prefix} \
        --exec-prefix=%{_prefix} \
        --bindir=%{_bindir} \
        --sbindir=%{_sbindir} \
        --sysconfdir=%{_sysconfdir} \
        --datadir=%{_datadir} \
        --includedir=%{_includedir} \
        --libdir=%{_libdir} \
        --libexecdir=%{_libexecdir} \
        --localstatedir=%{_var} \
        --sharedstatedir=%{_sharedstatedir} \
        --mandir=%{_mandir} \
        --infodir=%{_infodir} \
        --disable-dependency-tracking \
       	--disable-static \
	--with-lua \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot} -name '*.la' -delete
%find_lang %{name}
#	System macros and prefix
install -dm 755 %{buildroot}%{_sysconfdir}/rpm
install -vm644 %{_topdir}/macros %{buildroot}%{_sysconfdir}/rpm/
%post -p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%clean
rm -rf %{buildroot}
%files -f %{name}.lang
%defattr(-,root,root)
/bin/rpm
%{_sysconfdir}/rpm/macros
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%{_mandir}/fr/man8/*.gz
%{_mandir}/ja/man8/*.gz
%{_mandir}/ko/man8/*.gz
%{_mandir}/*/*.gz
%{_mandir}/pl/man1/*.gz
%{_mandir}/pl/man8/*.gz
%{_mandir}/ru/man8/*.gz
%{_mandir}/sk/man8/*.gz
%changelog
*	Thu Apr 10 2014 baho-utot <baho-utot@columbus.rr.com> 4.11.2-1
*	Thu Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 4.11.0.1-1
-	Upgrade version
