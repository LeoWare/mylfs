Summary:	Stream editor
Name:		sed
Version:	4.2.2
Release:	0
License:	GPLv3
URL:		http://www.gnu.org/software/sed
Group:		Applications/Editors
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/sed/%{name}-%{version}.tar.bz2
%description
The Sed package contains a stream editor.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--bindir=/bin \
	--htmldir=%{_defaultdocdir}/%{name}-%{version} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files -f %{name}.lang
%defattr(-,root,root)
/bin/*
%{_mandir}/man1/*
%changelog
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 4.2.2-0
-	Upgrade version
