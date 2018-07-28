Summary:	The Findutils package contains programs to find files.
Name:		findutils
Version:	4.6.0
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/findutils/%{name}-%{version}.tar.gz
%description
	The Findutils package contains programs to find files. These programs
	are provided to recursively search through a directory tree and to
	create, maintain, and search a database (often faster than the recursive
	find, but unreliable if the database has not been recently updated).
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--localstatedir=%{_localstatedir}/lib/locate
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	mv -v %{buildroot}%{_bindir}/find %{buildroot}/bin
	sed -i 's|find:=${BINDIR}|find:=/bin|' %{buildroot}%{_bindir}/updatedb
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm	
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
	%{_mandir}/man5/*.gz
	%dir %{_localstatedir}/lib/locate
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 4.6.0-1
-	Initial build.	First version
