Summary:	Controls the start up, running and shutdown of the system
Name:		sysvinit
Version:	2.88dsf
Release:	1
License:	GPLv2
URL:		http://savannah.nongnu.org/projects/sysvinit
Group:		LFS/Base
Vendor:		Octothorpe
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
	install -D -m644 COPYRIGHT %{buildroot}/usr/share/licenses/%{name}/LICENSE
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/
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
	%{_mandir}/man5/*.gz
	%{_mandir}/man8/*.gz
	
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.88dsf-1
-	Initial build.	First version
