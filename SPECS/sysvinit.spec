Summary:	Controls the start up, running and shutdown of the system
Name:		sysvinit
Version:	2.88dsf
Release:	1
License:	GPLv2
URL:		http://savannah.nongnu.org/projects/sysvinit
Group:		System Environment/Daemons
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://download.savannah.gnu.org/releases/sysvinit/%{name}-%{version}.tar.bz2
Patch:		sysvinit-2.88dsf-consolidated-1.patch
%description
Contains programs for controlling the start up, running and
shutdown of the system
%prep
%setup -q
%patch	-p1
%build
make VERBOSE=1 %{?_smp_mflags} -C src
%install
make -C src ROOT=%{buildroot}\
	MANDIR=%{_mandir} \
	STRIP=/bin/true \
	BIN_OWNER=`id -nu` BIN_GROUP=`id -ng` install
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
/sbin/*
%{_includedir}/*
%{_mandir}/*/*
%changelog
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.88dsf-1
-	Initial build.	First version
