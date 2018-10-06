#TARBALL:	http://download.savannah.gnu.org/releases/acl/acl-2.2.52.src.tar.gz
#MD5SUM:	a61415312426e9c2212bd7dc7929abda;SOURCES/acl-2.2.52.src.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Acl package contains utilities to administer Access Control Lists
Name:		acl
Version:	2.2.52
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://download.savannah.gnu.org/releases/%{name}/%{name}-%{version}.src.tar.gz
%description
	The Acl package contains utilities to administer Access Control Lists, which are
	used to define more fine-grained discretionary access rights for files and directories.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
	sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
	sed -i 's/{(/\\{(/' test/run
	sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c
%build
	./configure \
		--prefix=%{_prefix} \
 		--bindir=/bin \
		--disable-static \
		--libexecdir=%{_libdir}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install install-dev install-lib
	chmod -v 755 %{buildroot}%{_libdir}/libacl.so
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}%{_libdir}/libacl.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libacl.so) %{buildroot}%{_libdir}/libacl.so
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 doc/COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
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
	%{_mandir}/man5/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.2.52-1
-	Initial build.	First version
