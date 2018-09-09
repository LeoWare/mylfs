%global _default_patch_fuzz 2
#-----------------------------------------------------------------------------
Summary:	
Name:		
Version:	
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source:		%{name}-%{version}
%description
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	CFLAGS='%_optflags ' \
	CXXFLAGS='%_optflags ' \
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
#-----------------------------------------------------------------------------
#	Copy license/copying file
#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
#	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
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
#	%%{_infodir}/*.gz
#	%%{_mandir}/man1/*.gz
#-----------------------------------------------------------------------------
%post
	pushd /usr/share/info
	rm -v dir
	for f in *; do install-info $f dir 2>/dev/null; done
	popd
%postun
	pushd /usr/share/info
	rm -v dir
	for f in *; do install-info $f dir 2>/dev/null; done
	popd
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version
