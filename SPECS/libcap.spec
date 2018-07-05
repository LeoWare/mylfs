Summary:	The Libcap package implements the user-space interfaces to the POSIX 1003.1e
Name:		libcap
Version:	2.25
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	acl
Source0:	https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/%{name}-%{version}.tar.xz
%description
	The Libcap package implements the user-space interfaces to the POSIX 1003.1e
	capabilities available in Linux kernels. These capabilities are a partitioning
	of the all powerful root privilege into a set of distinct privileges.
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i '/install.*STALIBNAME/d' libcap/Makefile
%build
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} RAISE_SETFCAP=no lib=lib prefix=/usr install
	chmod -v 755 %{buildroot}%{_libdir}/libcap.so
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}%{_libdir}/libcap.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libcap.so) %{buildroot}%{_libdir}/libcap.so
	#	Copy license/copying file
	install -D -m644 License %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man1/*.gz
	%{_mandir}/man3/*.gz
	%{_mandir}/man8/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.25-1
-	Initial build.	First version
