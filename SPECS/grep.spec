Summary:	The Grep package contains programs for searching through files.
Name:		grep
Version:	3.1
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.xz
%description
	The Grep package contains programs for searching through files.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		 --bindir=/bin
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	#	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot}%{_infodir} -name 'dir' -delete
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 3.1-1
-	Initial build.	First version
