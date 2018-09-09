#-----------------------------------------------------------------------------
Summary:	The Procps-ng package contains programs for monitoring processes.
Name:		procps-ng
Version:	3.3.12
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://sourceforge.net/projects/procps-ng/files/Production/%{name}-%{version}.tar.xz
BuildRequires:	meson
%description
	The Procps-ng package contains programs for monitoring processes.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--exec-prefix= \
		--libdir=%{_libdir} \
		--docdir=%{_docdir}/%{NAME}-%{VERSION} \
		--disable-static \
		--disable-kill
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}%{_libdir}/libprocps.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libprocps.so) %{buildroot}%{_libdir}/libprocps.so
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
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
	%{_mandir}/man8/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 3.3.12-1
-	Initial build.	First version
