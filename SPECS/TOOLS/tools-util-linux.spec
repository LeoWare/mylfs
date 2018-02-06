Summary:	The Util-linux package contains miscellaneous utility programs. 	
Name:		tools-util-linux
Version:	2.30.1
Release:	1
License:	GPL
URL:		https://www.kernel.org/pub/linux/utils/util-linux/v2.30
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	https://www.kernel.org/pub/linux/utils/util-linux/v2.30/util-linux-%{version}.tar.xz
%description
	The Util-linux package contains miscellaneous utility programs. 
%prep
%setup -q -n util-linux-%{version}
%build
	#	FIXES:	zlib.h: No such file or directory
	#	added:	CPPFLAGS="-I/usr/include"
	#
	./configure --prefix=%{_prefix} \
		--without-python \
		--disable-makeinstall-chown \
		--without-systemdsystemunitdir \
		--without-ncurses \
		PKG_CONFIG="" \
		CPPFLAGS="-I/usr/include"
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Remove /tools/bin/kill, installed by tools-coreutils package
	rm 	%{buildroot}/tools/bin/kill
	rm -rf	%{buildroot}/tools/share/doc
	rm -rf	%{buildroot}/tools/share/man
	rm -rf	%{buildroot}/tools/share/locale
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 2.30.1-1
-	LFS-8.1