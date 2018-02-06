Summary:	The LFS-Bootscripts package contains a set of scripts to start/stop the LFS system at bootup/shutdown.
Name:		lfs-bootscripts
Version:	20170626
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
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
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version