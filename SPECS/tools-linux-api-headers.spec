%global debug_package %{nil}
#TARBALL:	https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.15.3.tar.xz
#MD5SUM:	c74d30ec13491aeb24c237d703eace3e;SOURCES/linux-4.15.3.tar.xz
#PATCHES:
#FILE:		linux-4.15.3.tar.xz.md5sum
#-----------------------------------------------------------------------------
Summary:	The Linux API Headers expose the kernel's API for use by Glibc.
Name:		tools-linux-api-headers
Version:	4.15.3
Release:	1
License:	GPL
URL:		https://www.kernel.org
Group:		LFS/Tools
Vendor:	Octothorpe
Source:	https://www.kernel.org/pub/linux/kernel/v4.x/linux-%{version}.tar.xz
%description
The Linux API Headers expose the kernel's API for use by Glibc.
#-----------------------------------------------------------------------------
%prep
%setup -q -n linux-%{version}
%build
	make mrproper
%install
	make INSTALL_HDR_PATH=dest headers_install
	install -vdm 755 %{buildroot}%{_includedir}
	cp -rv dest/include/* %{buildroot}%{_includedir}
	find %{buildroot}%{_includedir} \( -name .install -o -name ..install.cmd \) -delete
#-----------------------------------------------------------------------------
#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Sat Mar 10 2018 baho-utot <baho-utot@columbus.rr.com> 4.15.3-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.9.67-1
-	LFS-8.1
