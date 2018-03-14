Summary:	The Xz package contains programs for compressing and decompressing files
Name:		xz
Version:	5.2.3
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://tukaani.org/xz/%{name}-%{version}.tar.xz
%description
	The Xz package contains programs for compressing and decompressing files. 
	It provides capabilities for the lzma and the newer xz compression formats.
	Compressing text files with xz yields a better compression percentage than
	with the traditional gzip or bzip2 commands. 
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static \
		--docdir=/usr/share/doc/%{NAME}-%{VERSION}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	install -vdm 755 %{buildroot}/lib
	mv -v   %{buildroot}/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} %{buildroot}/bin
	mv -v %{buildroot}/usr/lib/liblzma.so.* %{buildroot}/lib
	ln -svf ../../lib/$(readlink %{buildroot}/usr/lib/liblzma.so) %{buildroot}/usr/lib/liblzma.so
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