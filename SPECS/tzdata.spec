Summary:		Time zone data
Name:			tzdata
Version:		2018c
Release:		1
URL:			http://www.iana.org/time-zones
License	:	public-domain
Group:			LFS/Base
Vendor:		Octothorpe
Source0:		http://www.iana.org//time-zones/repository/releases/%{name}%{version}.tar.gz
%description
Sources for time zone and daylight saving time data
%define blddir	%{name}-%{version}
%prep
	rm -rf %{blddir}
	install -vdm 755 %{blddir}
	cd %{blddir}
	tar xf %{SOURCE0}
%build
	cd %{blddir}
%install
	cd %{blddir}
	ZONEINFO=%{buildroot}/usr/share/zoneinfo
	install -vdm 755 $ZONEINFO/{posix,right}
	for tz in etcetera southamerica northamerica europe africa antarctica  \
		asia australasia backward pacificnew systemv; do
		zic -L /dev/null	-d $ZONEINFO		-y "sh yearistype.sh" ${tz}
		zic -L /dev/null	-d $ZONEINFO/posix	-y "sh yearistype.sh" ${tz}
		zic -L leapseconds	-d $ZONEINFO/right	-y "sh yearistype.sh" ${tz}
	done
	cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
	zic -d $ZONEINFO -p America/New_York
	install -vDm 555 %{buildroot}/usr/share/zoneinfo/America/New_York %{buildroot}/etc/localtime
	#	Copy license/copying file
	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	cd -
	#	Create file list
	rm -rf %{buildroot}/usr/share/info/dir
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Mon Mar 19 2018 baho-utot <baho-utot@columbus.rr.com> 2018c-1
*	Wed Dec 20 2014 baho-utot <baho-utot@columbus.rr.com> 2017b-1
-	Update to LFS-8.1
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 2013i-1
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 2013d-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 2013c-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 2013b-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 2012j-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2012e-1
