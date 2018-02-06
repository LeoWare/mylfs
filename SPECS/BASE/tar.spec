Summary:	The Tar package contains an archiving program.
Name:		tar
Version:	1.29
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/tar/%{name}-%{version}.tar.xz
%description
	The Tar package contains an archiving program.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	FORCE_UNSAFE_CONFIGURE=1 \
	./configure \
		--prefix=%{_prefix} \
		--bindir=/bin
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	make -C doc DESTDIR=%{buildroot} install-html docdir=/usr/share/doc/tar-1.29
	rm -rf %{buildroot}/%{_infodir}
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version