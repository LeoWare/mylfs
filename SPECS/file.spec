Summary:	The File package contains a utility for determining the type of a given file or files
Name:		file
Version:	5.32
Release:	1
License:	Other
URL:		ftp://ftp.astron.com/pub
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	ftp://ftp.astron.com/pub/%{name}/%{name}-%{version}.tar.gz
%description
	The File package contains a utility for determining the type of a given file or files.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man1/file.1.gz
	%{_mandir}/man3/libmagic.3.gz
	%{_mandir}/man4/magic.4.gz
%changelog
*	Mon Mar 19 2018 baho-utot <baho-utot@columbus.rr.com> 5.32-1
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 5.31-1
-	Initial build.	First version
