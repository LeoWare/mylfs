#-----------------------------------------------------------------------------
Summary:	The attr package contains utilities to administer the extended attributes on filesystem objects.
Name:		attr
Version:	2.4.47
Release:	1
License:	GPLv2
URL:		http://savannah.nongnu.org/projects/attr
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://download.savannah.gnu.org/releases/%{name}/%{name}-%{version}.src.tar.gz
BuildRequires:	ncurses
%description
	The attr package contains utilities to administer the extended attributes on filesystem objects.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
	sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
	sed -i 's:{(:\\{(:' test/run
%build
	./configure \
		--prefix=%{_prefix} \
		--bindir=/bin \
		--disable-static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install install-dev install-lib
	chmod -v 755 %{buildroot}%{_libdir}/libattr.so
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}%{_libdir}/libattr.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libattr.so) %{buildroot}%{_libdir}/libattr.so
#-----------------------------------------------------------------------------
#	Copy license/copying file
#	install -D -m644 doc/COPYINGLICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man1/*.gz
	%{_mandir}/man3/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.4.47-1
-	Initial build.	First version
