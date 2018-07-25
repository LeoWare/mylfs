Summary:	The Libcap package implements the user-space interfaces to the POSIX 1003.1e
Name:		libffi
Version:	3.2.1
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	    Octothorpe
Source0:	%{name}-%{version}.tar.gz
%description
	The Libffi library provides a portable, high level programming interface to various calling conventions.
	This allows a programmer to call any function specified by a call interface description at run time.
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' -i include/Makefile.in
	sed -e '/^includedir/ s/=.*$/=@includedir@/' -e 's/^Cflags: -I${includedir}/Cflags:/' -i libffi.pc.in
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
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
	%{_mandir}/man3/*.gz
%changelog
*	Fri Jul 17 2018 baho-utot <baho-utot@columbus.rr.com> 3.2.1-1
-	Initial build.	First version
