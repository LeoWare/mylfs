Summary:	The GMP package contains math libraries.
Name:		gmp
Version:	6.1.2
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.xz
%description
	The GMP package contains math libraries. These have useful functions for arbitrary precision arithmetic. 
%prep
%setup -q -n %{NAME}-%{VERSION}
	cp -v configfsf.guess config.guess
	cp -v configfsf.sub   config.sub
%build
	./configure \
		--prefix=%{_prefix} \
		--enable-cxx \
		--disable-static \
		--docdir=/usr/share/doc/gmp-6.1.2
	make %{?_smp_mflags}
	make %{?_smp_mflags} html
%install
	make DESTDIR=%{buildroot} install
	#	make DESTDIR=%{buildroot} install-html
	#	Copy license/copying file 
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}/usr/share/info/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version