Summary:	The Man-DB package contains programs for finding and viewing man pages.
Name:		man-db
Version:	2.8.1
Release:	1
License:	Other
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	util-linux
Source0:	http://download.savannah.gnu.org/releases/man-db/%{name}-%{version}.tar.xz
%description
	The Man-DB package contains programs for finding and viewing man pages.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--docdir=%{_docdir}/%{NAME}-%{VERSION} \
		--sysconfdir=/etc \
		--disable-setuid \
		--enable-cache-owner=bin \
		--with-browser=%{_bindir}/lynx \
		--with-vgrind=%{_bindir}/vgrind \
		--with-grap=%{_bindir}/grap \
		--with-systemdtmpfilesdir=
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 README %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.8.1-1
-	Initial build.	First version
