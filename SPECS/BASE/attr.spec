Summary:	The attr package contains utilities to administer the extended attributes on filesystem objects. 
Name:		attr 
Version:	2.4.47
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
	The attr package contains utilities to administer the extended attributes on filesystem objects. 
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
	chmod -v 755 %{buildroot}/usr/lib/libattr.so
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}/usr/lib/libattr.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}/usr/lib/libattr.so) %{buildroot}/usr/lib/libattr.so
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