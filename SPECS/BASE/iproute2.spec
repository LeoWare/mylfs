Summary:	The IPRoute2 package contains programs for basic and advanced IPV4-based networking.
Name:		iproute2
Version:	4.12.0
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	https://www.kernel.org/pub/linux/utils/net/iproute2/%{NAME}-%{VERSION}.tar.xz
%description
	The IPRoute2 package contains programs for basic and advanced IPV4-based networking.
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i /ARPD/d Makefile
	sed -i 's/arpd.8//' man/man8/Makefile
	rm -v doc/arpd.sgml
	sed -i 's/m_ipt.o//' tc/Makefile
%build
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot}  DOCDIR=/usr/share/doc/iproute2-4.12.0 install
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version