Summary:	The Procps-ng package contains programs for monitoring processes.
Name:		procps-ng
Version:	3.3.12
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://sourceforge.net/projects/procps-ng/files/Production/%{name}-%{version}.tar.xz
%description
	The Procps-ng package contains programs for monitoring processes.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--exec-prefix= \
		--libdir=/usr/lib \
		--docdir=/usr/share/doc/%{NAME}-%{VERSION} \
		--disable-static \
		--disable-kill
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}/usr/lib/libprocps.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}/usr/lib/libprocps.so) %{buildroot}/usr/lib/libprocps.so
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