Summary:	The Flex package contains a utility for generating programs that recognize patterns in text. 
Name:		flex
Version:	2.6.4
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	https://github.com/westes/flex/releases/download/v2.6.4/%{name}-%{version}.tar.gz
%description
	The Flex package contains a utility for generating programs that recognize patterns in text. 
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
%build
	HELP2MAN=/tools/bin/true \
	./configure \
		--prefix=%{_prefix} \
		--docdir=/usr/share/doc/%{name}-%{version}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	ln -sv flex %{buildroot}/usr/bin/lex
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}/usr/share/info/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version