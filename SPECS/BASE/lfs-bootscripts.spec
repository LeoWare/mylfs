Summary:	The LFS-Bootscripts package contains a set of scripts to start/stop the LFS system at bootup/shutdown.
Name:		lfs-bootscripts
Version:	20170626
Release:	1
License:	None
URL:		http://www.linuxfromscratch.org
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://www.linuxfromscratch.org/lfs/downloads/8.1/%{name}-%{version}.tar.bz2
%description
	The LFS-Bootscripts package contains a set of scripts to start/stop the LFS system
	at bootup/shutdown. The configuration files and procedures needed to customize the
	boot process are described in the following sections.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
%install
	make DESTDIR=%{buildroot} install
	#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
#	%%{_infodir}/*.gz
#	%%{_mandir}/man1/*.gz	
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 20170626-1
-	Initial build.	First version
