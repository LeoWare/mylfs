Summary:	The E2fsprogs package contains the utilities for handling the ext2 file system.
Name:		e2fsprogs
Version:	1.43.9
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	procps-ng
Source0:	http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.5/%{name}-%{version}.tar.gz
%description
	The E2fsprogs package contains the utilities for handling the ext2 file system.
	It also supports the ext3 and ext4 journaling file systems.
%prep
%setup -q -n %{NAME}-%{VERSION}
	mkdir build
%build
	cd build
	LIBS=-L/tools/lib \
	CFLAGS=-I/tools/include \
	PKG_CONFIG_PATH=/tools/lib/pkgconfig \
	../configure \
		--prefix=%{_prefix} \
		--bindir=/bin \
		--with-root-prefix="" \
		--enable-elf-shlibs \
		--disable-libblkid \
		--disable-libuuid \
		--disable-uuidd \
		--disable-fsck
	make %{?_smp_mflags}
%install
	cd build
	make DESTDIR=%{buildroot} install
	make DESTDIR=%{buildroot} install-libs
	cd -
	chmod -v u+w %{buildroot}%{_libdir}/{libcom_err,libe2p,libext2fs,libss}.a
	gunzip -v %{buildroot}%{_infodir}/libext2fs.info.gz
	install-info --dir-file=%{buildroot}%{_infodir}/dir %{buildroot}%{_infodir}/libext2fs.info

	makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
	install -v -m644 doc/com_err.info %{_infodir}
	install-info --dir-file=%{_infodir}/dir %{_infodir}/com_err.info
	#	Copy license/copying file
	install -D -m644 NOTICE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Wed Jul 25 2018 baho-utot <baho-utot@columbus.rr.com> 1.43.9-1
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.43.5-1
-	Initial build.	First version
