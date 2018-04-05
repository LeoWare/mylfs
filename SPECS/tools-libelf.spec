Summary:	The elfutils package contains a set of utilities and libraries for handling ELF files
Name:	tools-libelf
Version:	0.170
Release:	1
License:	GPL
URL:		https://sourceware.org/ftp/elfutils
Group:	LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-zlib
Source0:	https://sourceware.org/ftp/elfutils/0.170/elfutils-%{version}.tar.bz2
%description
	The elfutils package contains a set of utilities and libraries for handling ELF
	(Executable and Linkable Format) files.
%prep
%setup -q -n elfutils-%{version}
%build
	./configure \
		--prefix=%{_prefix} \
		--program-prefix="eu-" \
		--disable-shared \
		--enable-static
	make %{?_smp_mflags}
%install
	#	make DESTDIR=%{buildroot} install
	make DESTDIR=%{buildroot} -C libelf install
	install -vDm644 config/libelf.pc %{buildroot}/tools/lib/pkgconfig/libelf.pc
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 0.170-1
-	LFS-8.1
