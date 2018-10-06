#TARBALL:	https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
#MD5SUM:	2882e3179748cc9f9c23ec593d6adc8d;SOURCES/flex-2.6.4.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Flex package contains a utility for generating programs that recognize patterns in text.
Name:		flex
Version:	2.6.4
Release:	1
License:	BSD
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	https://github.com/westes/flex/releases/download/v2.6.4/%{name}-%{version}.tar.gz
%description
The Flex package contains a utility for generating programs that recognize patterns in text.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
%build
	HELP2MAN=/tools/bin/true \
	./configure \
		--prefix=%{_prefix} \
		--docdir=%{_docdir}/%{name}-%{version}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	ln -sv flex %{buildroot}%{_bindir}/lex
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.6.4-1
-	Initial build.	First version
