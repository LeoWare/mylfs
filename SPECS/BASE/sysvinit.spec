Summary:	Controls the start up, running and shutdown of the system
Name:		sysvinit
Version:	2.88dsf
Release:	1
License:	GPLv2
URL:		http://savannah.nongnu.org/projects/sysvinit
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://download.savannah.gnu.org/releases/sysvinit/%{name}-%{version}.tar.bz2
Patch:		sysvinit-2.88dsf-consolidated-1.patch
%description
	Contains programs for controlling the start up, running and
	shutdown of the system
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch	-p1
%build
	make VERBOSE=1 %{?_smp_mflags} -C src
%install
	make -C src ROOT=%{buildroot}\
		MANDIR=%{_mandir} \
		STRIP=/bin/true \
		BIN_OWNER=`id -nu` BIN_GROUP=`id -ng` install
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