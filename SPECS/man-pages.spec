Summary:	Man pages
Name:		man-pages
Version:	4.15
Release:	1
License:	GPLv2
URL:		http://www.kernel.org/doc/man-pages
Group:		System Environment/Base
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://www.kernel.org/pub/linux/docs/man-pages/%{name}-%{version}.tar.xz
BuildArch:	noarch
%description
The Man-pages package contains over 1,900 man pages.
%prep
%setup -q
%build
%install
make DESTDIR=%{buildroot} install
#	The following man pages conflict with other packages
#rm -vf %{buildroot}%{_mandir}/man3/getspnam.3
#rm -vf %{buildroot}%{_mandir}/man5/passwd.5
%files
%defattr(-,root,root)
%{_mandir}/man1/*
%{_mandir}/man2/*
%{_mandir}/man3/*
%{_mandir}/man4/*
%{_mandir}/man5/*
%{_mandir}/man6/*
%{_mandir}/man7/*
%{_mandir}/man8/*
%changelog
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 3.59-1
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.53-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 3.51-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.50-1
*	Sun Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 3.47-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 3.42-1
