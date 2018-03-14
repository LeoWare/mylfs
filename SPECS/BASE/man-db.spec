Summary:	The Man-DB package contains programs for finding and viewing man pages.
Name:		man-db
Version:	2.7.6.1
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://download.savannah.gnu.org/releases/man-db/%{name}-%{version}.tar.xz
%description
	The Man-DB package contains programs for finding and viewing man pages.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--docdir=/usr/share/doc/man-db-2.7.6.1 \
		--sysconfdir=/etc \
		--disable-setuid \
		--enable-cache-owner=bin \
		--with-browser=/usr/bin/lynx \
		--with-vgrind=/usr/bin/vgrind \
		--with-grap=/usr/bin/grap \
		--with-systemdtmpfilesdir=
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version