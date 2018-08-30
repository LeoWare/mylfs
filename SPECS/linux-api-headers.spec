Summary:	Linux API header files
Name:		linux-api-headers
Version:	4.15.3
Release:	1
License:	GPLv2
URL:		http://www.kernel.org/
Group:		System Environment/Kernel
Vendor:		LeoWare
Distribution:	LFS
Source0:	http://www.kernel.org/pub/linux/kernel/v4.x/linux-%{version}.tar.xz
BuildArch:	noarch
%description
The Linux API Headers expose the kernel's API for use by Glibc.
%prep
%setup -q -n linux-%{version}
%build
make mrproper
make headers_check
%install
cd %{_builddir}/linux-%{version}
make INSTALL_HDR_PATH=%{buildroot}%{_prefix} headers_install
find /%{buildroot}%{_includedir} \( -name .install -o -name ..install.cmd \) -delete
%files
%defattr(-,root,root)
%{_includedir}/asm-generic/*
%{_includedir}/asm/*
%{_includedir}/drm/*
%{_includedir}/linux
%{_includedir}/misc
%{_includedir}/mtd/*
%{_includedir}/rdma/*
%{_includedir}/scsi/*
%{_includedir}/sound/*
%{_includedir}/video/*
%{_includedir}/xen/*
%changelog
*	Mon Sep 18 2017 Samuel Raynor <samuel@samuelraynor.com> 4.12.7-1
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
