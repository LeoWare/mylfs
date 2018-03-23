Summary:	Man pages
Name:		man-pages
Version:	4.15
Release:	1
License:	GPLv2
URL:		http://www.kernel.org/doc/man-pages
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	linux-api-headers
Source:	http://www.kernel.org/pub/linux/docs/man-pages/%{name}-%{version}.tar.xz
%description
The Man-pages package contains over 1,900 man pages.
%prep
%setup -q
%build
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 man-pages-%{version}.Announce %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Mon Mar 19 2018 baho-utot <baho-utot@columbus.rr.com> 4.15-1
*	Tue Dec 19 2017 baho-utot <baho-utot@columbus.rr.com> 4.12-1
-	update to version 4.12
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 3.59-1
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.53-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 3.51-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.50-1
*	Sun Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 3.47-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 3.42-1


