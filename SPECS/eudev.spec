#-----------------------------------------------------------------------------
Summary:	The Eudev package contains programs for dynamic creation of device nodes.
Name:		eudev
Version:	3.2.5
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://dev.gentoo.org/~blueness/eudev/%{name}-%{version}.tar.gz
Source1:	http://anduin.linuxfromscratch.org/LFS/udev-lfs-20171102.tar.bz2
BuildRequires:	sysvinit
%description
	The Eudev package contains programs for dynamic creation of device nodes.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%setup -T -D -a 1
	sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
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
		--libdir=%{_libdir} \
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
	make -f udev-lfs-20171102/Makefile.lfs DESTDIR=%{buildroot} install
	mv %{buildroot}/usr/share/pkgconfig/udev.pc %{buildroot}/usr/lib/pkgconfig
	rm -rf %{buildroot}/usr/share/pkgconfig
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm	
%post
	LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
#	%%{_infodir}/*.gz
	%{_mandir}/man5/*.gz
	%{_mandir}/man7/*.gz
	%{_mandir}/man8/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 3.2.5-1
-	Initial build.	First version
