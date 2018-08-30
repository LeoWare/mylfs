Summary:	A utility for generating programs that recognize patterns in text
Name:		flex
Version:	2.5.38
Release:	1
License:	BSD
URL:		http://flex.sourceforge.net
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://prdownloads.sourceforge.net/flex/%{name}-%{version}.tar.bz2
%description
The Flex package contains a utility for generating programs
that recognize patterns in text.
%prep
%setup -q
sed -i -e '/test-bison/d' tests/Makefile.in
%build
./configure \
	--prefix=%{_prefix} \
	--docdir=%{_defaultdocdir}/%{name}-%{version} \
	--disable-silent-rules
make VERBOSE=1 %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot}%{_libdir} -name '*.la' -delete
cat > %{buildroot}/usr/bin/lex <<- "EOF"
#!/bin/sh
# Begin /usr/bin/lex

	exec /usr/bin/flex -l "$@"

# End /usr/bin/lex
EOF
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
