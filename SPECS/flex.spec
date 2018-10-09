Summary:	A utility for generating programs that recognize patterns in text
Name:		flex
Version:	2.6.4
Release:	1
License:	BSD
URL:		http://flex.sourceforge.net
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://prdownloads.sourceforge.net/flex/%{name}-%{version}.tar.gz
%description
The Flex package contains a utility for generating programs
that recognize patterns in text.
%prep
%setup -q
sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
%build
HELP2MAN=/tools/bin/true \
./configure \
	--prefix=%{_prefix} \
	--docdir=%{_defaultdocdir}/%{name}-%{version}
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot}%{_libdir} -name '*.la' -delete
ln -sv flex %{buildroot}%{_bindir}/lex
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/flex
%{_bindir}/flex++
%attr(755,root,root) %{_bindir}/lex
%{_libdir}/*
%{_includedir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Sat Apr 05 2014 baho-utot <baho-utot@columbus.rr.com> 2.5.38-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.5.37-1
-	Initial build.	First version
