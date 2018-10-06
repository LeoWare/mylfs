#TARBALL:	https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.15.3.tar.xz
#MD5SUM:	c74d30ec13491aeb24c237d703eace3e;SOURCES/linux-4.15.3.tar.xz
#-----------------------------------------------------------------------------
Summary:	Linux API header files
Name:		linux-api-headers
Version:	4.15.3
Release:	1
License:	GPLv2
URL:		http://www.kernel.org/
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://www.kernel.org/pub/linux/kernel/v4.x/linux-%{version}.tar.xz
%description
The Linux API Headers expose the kernel's API for use by Glibc.
#-----------------------------------------------------------------------------
%prep
%setup -q -n linux-%{version}
%build
	make mrproper
%install
	cd %{_builddir}/linux-%{version}
	make INSTALL_HDR_PATH=dest headers_install
	find dest/include \( -name .install -o -name ..install.cmd \) -delete
	install -vdm 755 %{buildroot}%{_includedir}
	cp -rv dest/include/* %{buildroot}%{_includedir}
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
#-----------------------------------------------------------------------------
%changelog
*	Thu Mar 15 2018 baho-utot <baho-utot@columbus.rr.com> 4.15.3-1
*	Wed Jan 31 2018 baho-utot <baho-utot@columbus.rr.com> 4.9.67-2
*	Tue Dec 19 2017 baho-utot <baho-utot@columbus.rr.com> 4.9.67-1
-	update to version 4.9.67
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 3.13.3-1
*	Sat Aug 31 2013 baho-utot <baho-utot@columbus.rr.com> 3.10.10-1
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.10.9-1
*	Thu Jun 27 2013 baho-utot <baho-utot@columbus.rr.com> 3.9.7-1
*	Wed May 15 2013 baho-utot <baho-utot@columbus.rr.com> 3.9.2-1
*	Sat May 11 2013 baho-utot <baho-utot@columbus.rr.com> 3.9.1-1
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 3.9-1
*	Mon Apr 1 2013 baho-utot <baho-utot@columbus.rr.com> 3.8.5-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.8.3-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 3.8.1-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 3.5.2-1
-	initial version
