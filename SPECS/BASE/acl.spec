Summary:	The Acl package contains utilities to administer Access Control Lists
Name:		acl 
Version:	2.2.52
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://download.savannah.gnu.org/releases/%{name}/%{name}-%{version}.src.tar.gz
%description
	The Acl package contains utilities to administer Access Control Lists, which are
	used to define more fine-grained discretionary access rights for files and directories.
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
		--libexecdir=/usr/lib
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install install-dev install-lib
	chmod -v 755 %{buildroot}/usr/lib/libacl.so
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}/usr/lib/libacl.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}/usr/lib/libacl.so) %{buildroot}/usr/lib/libacl.so
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version