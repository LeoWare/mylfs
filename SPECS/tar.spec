Summary:	Archiving program
Name:		tar
Version:	1.27.1
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/tar
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source0:	tar/%{name}-%{version}.tar.xz
Patch0:		tar-1.27.1-manpage-1.patch
%description
Contains GNU archiving program
%prep
%setup -q
%patch0 -p1
%build
FORCE_UNSAFE_CONFIGURE=1  ./configure \
	--prefix=%{_prefix} \
	--bindir=/bin \
	--disable-silent-rules
make %{?_smp_mflags}
%install
install -vdm 755 %{buildroot}%{_sbindir}
make DESTDIR=%{buildroot} install
make DESTDIR=%{buildroot} -C doc install-html docdir=%{_defaultdocdir}/%{name}-%{version}
install -vdm 755 %{buildroot}/usr/share/man/man1 
perl tarman > %{buildroot}/usr/share/man/man1/tar.1
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files -f %{name}.lang
%defattr(-,root,root)
/bin/tar
%{_libexecdir}/rmt
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 1.27.1-1
*	Mon Sep 02 2013 baho-utot <baho-utot@columbus.rr.com> 1.26-3
-	Add man directory
*	Sun Sep 01 2013 baho-utot <baho-utot@columbus.rr.com> 1.26-2
-	Add man page patch
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.26-1
-	Initial build.	First version
