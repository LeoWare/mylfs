Summary:	Text file viewer
Name:		less
Version:	458
Release:	0
License:	GPLv3
URL:		http://www.greenwoodsoftware.com/less
Group:		Applications/File
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://www.greenwoodsoftware.com/less/%{name}-%{version}.tar.gz
%description
The Less package contains a text file viewer
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--sysconfdir=%{_sysconfdir} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
%files
%defattr(-,root,root)
%{_bindir}/*
%{_mandir}/*/*
%changelog
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 458-0
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 451-1
-	Upgrade version
