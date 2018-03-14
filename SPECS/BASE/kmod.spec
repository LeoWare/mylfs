Summary:	The Kmod package contains libraries and utilities for loading kernel modules 
Name:		kmod
Version:	24
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	https://www.kernel.org/pub/linux/utils/kernel/kmod/%{name}-%{version}.tar.xz
%description
	The Kmod package contains libraries and utilities for loading kernel modules 
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--bindir=/bin \
		--sysconfdir=/etc \
		--with-rootlibdir=/lib \
		--with-xz \
		--with-zlib
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	install -vdm 755 %{buildroot}/sbin
	for target in depmod insmod lsmod modinfo modprobe rmmod; do
		ln -sfv ../bin/kmod %{buildroot}/sbin/$target
	done
	ln -sfv kmod %{buildroot}/bin/lsmod
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version