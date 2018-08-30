Summary:	Programs for generating Makefiles
Name:		automake
Version:	1.14.1
Release:	1
License:	GPLv2
URL:		http://www.gnu.org/software/automake/
Group:		LFS/Base
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/automake/%{name}-%{version}.tar.xz
%description
Contains programs for generating Makefiles for use with Autoconf.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--docdir=%{_defaultdocdir}/%{name}-%{version} \
	--disable-silent-rules
make %{?_smp_mflags}
%check
sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
make -k check %{?_smp_mflags} |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%install
make DESTDIR=%{buildroot} install
rm -rf %{buildroot}%{_infodir}
%files
%defattr(-,root,root)
%{_bindir}/*
%{_datarootdir}/aclocal/README
%{_datarootdir}/%{name}-1.14/*
%{_datarootdir}/aclocal-1.14/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 1.14.1-1
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 1.14-1
-	Upgrade version