Summary:	The Kbd package contains key-table files, console fonts, and keyboard utilities.
Name:		kbd
Version:	2.0.4
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	https://www.kernel.org/pub/linux/utils/kbd/%{name}-%{version}.tar.xz
Patch0:		kbd-2.0.4-backspace-1.patch
%description
	The Kbd package contains key-table files, console fonts, and keyboard utilities.
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch0 -p1
	sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
	sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
%build
	PKG_CONFIG_PATH=/tools/lib/pkgconfig \
	./configure \
		--prefix=%{_prefix} \
		--disable-vlock
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	mkdir -v %{buildroot}/usr/share/doc/kbd-2.0.4
	#	cp -R -v docs/doc/* %{buildroot}/usr/share/doc/kbd-2.0.4
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version