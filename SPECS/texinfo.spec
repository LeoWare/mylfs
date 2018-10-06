#TARBALL:	http://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.xz
#MD5SUM:	3715197e62e0e07f85860b3d7aab55ed;SOURCES/texinfo-6.5.tar.xz
#-----------------------------------------------------------------------------
Summary:	The Texinfo package contains programs for reading, writing, and converting info pages.
Name:		texinfo
Version:	6.5
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/texinfo/%{name}-%{version}.tar.xz
%description
The Texinfo package contains programs for reading, writing, and converting info pages.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	make DESTDIR=%{buildroot} TEXMF=/usr/share/texmf install-tex
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
	%{_mandir}/man5/*.gz
%post
	pushd /usr/share/info
	rm -v dir
	for f in *;	do install-info $f dir 2>/dev/null; done
	popd
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 6.5-1
-	Initial build.	First version
