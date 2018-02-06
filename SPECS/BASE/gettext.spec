Summary:	The Gettext package contains utilities for internationalization and localization.
Name:		gettext
Version:	0.19.8.1
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/gettext/%{name}-%{version}.tar.xz
%description
	The Gettext package contains utilities for internationalization and localization.
	These allow programs to be compiled with NLS (Native Language Support), enabling
	them to output messages in the user's native language. 
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in
	sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static \
		--docdir=/usr/share/doc/%{NAME}-%{VERSION}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	chmod -v 0755 %{buildroot}/usr/lib/preloadable_libintl.so
	rm -rf %{buildroot}/usr/share/doc/%{NAME}-%{VERSION}
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}/usr/share/info/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version