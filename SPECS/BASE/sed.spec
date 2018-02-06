Summary:	The Sed package contains a stream editor
Name:		sed 
Version:	4.4
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.xz
%description
	The Sed package contains a stream editor
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i 's/usr/tools/' build-aux/help2man
	sed -i 's/testsuite.panic-tests.sh//' Makefile.in
%build
	./configure \
		--prefix=%{_prefix} \
		--bindir=/bin
	make %{?_smp_mflags}
	make %{?_smp_mflags} html
%install
	make DESTDIR=%{buildroot} install
	#	install -d -m755 %{buildroot}/usr/share/doc/sed-4.4
	#	install -m644 doc/sed.html %{buildroot}/usr/share/doc/sed-4.4
	rm -rf %{buildroot}/%{_infodir}
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version