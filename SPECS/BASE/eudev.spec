#make -f udev-lfs-20140408/Makefile.lfs install

Summary:	The Eudev package contains programs for dynamic creation of device nodes.
Name:		eudev
Version:	3.2.2
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://dev.gentoo.org/~blueness/eudev/%{name}-%{version}.tar.gz
Source1:	http://anduin.linuxfromscratch.org/LFS/udev-lfs-20140408.tar.bz2
%description
	The Eudev package contains programs for dynamic creation of device nodes. 
%prep
%setup -q -n %{NAME}-%{VERSION}
%setup -T -D -a 1
	sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
	sed -i '/keyboard_lookup_key/d' src/udev/udev-builtin-keyboard.c
	cat > config.cache <<- "EOF"
		HAVE_BLKID=1
		BLKID_LIBS="-lblkid"
		BLKID_CFLAGS="-I/tools/include"
	EOF
%build
	./configure \
		--prefix=%{_prefix} \
		--bindir=/sbin \
		--sbindir=/sbin \
		--libdir=/usr/lib \
		--sysconfdir=/etc \
		--libexecdir=/lib \
		--with-rootprefix= \
		--with-rootlibdir=/lib \
		--enable-manpages \
		--disable-static \
		--config-cache
	LIBRARY_PATH=/tools/lib make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} LD_LIBRARY_PATH=/tools/lib install
	make -f udev-lfs-20140408/Makefile.lfs DESTDIR=%{buildroot} install
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%post
	LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version