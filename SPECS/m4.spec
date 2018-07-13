Summary:    The M4 package contains a macro processor
Name:       m4
Version:	1.4.18
Release:	1
License:	GPLv3
URL:		http://www.gnu.org
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.xz
%description
	The M4 package contains a macro processor
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 README %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot}%{_infodir} -name 'dir' -delete
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/m4.1.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.4.18-1
-	Initial build.	First version
