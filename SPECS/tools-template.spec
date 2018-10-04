%global debug_package %{nil}
#TARBALL:	
#MD5SUM:	
#PATCHES:
#FILE:		.md5sum
#-----------------------------------------------------------------------------
#	package
Summary:
Name:		tools-
Version:
Release:	1
License:	GPL
URL:
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	<name>-%{version}.tar.gz
Patch0:
%description
#-----------------------------------------------------------------------------
%prep
%setup -q -n <name>-%{version}
%patch0 -p0
%build
#	  CFLAGS='%_optflags ' \
#	CXXFLAGS='%_optflags ' \
#	LDFLAGS='%_ldflags ' \
	make %{?_smp_mflags}

%install
	make DESTDIR=%{buildroot} install
	#make PREFIX=%{buildroot}/usr install
	#find %{buildroot} -name '*.a'  -delete
	#find %{buildroot} -name '*.la' -delete
	#rm -rf %{buildroot}/tools/share/doc
	#rm -rf %{buildroot}/tools/share/info
	#rm -rf %{buildroot}/tools/share/man
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create directory list
	#	find "${RPM_BUILD_ROOT}" -type d -print \
	#		| sed -e "s|^${RPM_BUILD_ROOT}||" \
	#		| sort >> %{name}-manifest.list
	#	echo "" >> %{name}-manifest.list
#-----------------------------------------------------------------------------
#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f %{name}-manifest.list
	%defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	LFS-8.1
