Summary:	The Linux API Headers (in linux-4.12.7.tar.xz) expose the kernel's API for use by Glibc.	
Name:		tools-linux-api-headers
Version:	4.9.67	
Release:	1
License:	GPL
URL:		https://www.kernel.org
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	https://www.kernel.org/pub/linux/kernel/v4.x/linux-%{version}.tar.xz
%description
	The Linux API Headers expose the kernel's API for use by Glibc.
%prep
%setup -q -n linux-%{version}
%build
	make mrproper
%install
	make INSTALL_HDR_PATH=dest headers_install
	install -vdm 755 %{buildroot}/tools/include
	cp -rv dest/include/* %{buildroot}/tools/include
	find %{buildroot}/tools/include \( -name .install -o -name ..install.cmd \) -delete
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.9.67-1
-	LFS-8.1