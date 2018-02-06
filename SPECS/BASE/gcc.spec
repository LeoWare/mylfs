Summary:	The GCC package contains the GNU compiler collection
Name:		gcc
Version:	7.2.0
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}/%{name}-%{version}.tar.xz
%description
	The GCC package contains the GNU compiler collection, which includes the C and C++ compilers.
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
%build
	mkdir build
	cd build
	SED=sed \
	../configure \
		--prefix=%{_prefix} \
		--enable-languages=c,c++ \
		--disable-multilib \
		--disable-bootstrap \
		--with-system-zlib
	make %{?_smp_mflags}
%install
	cd build
	make DESTDIR=%{buildroot} install

	install -vdm 755 %{buildroot}/lib
	ln -sv ../usr/bin/cpp %{buildroot}/lib

	install -vdm 755 %{buildroot}/usr/bin
	ln -sv gcc %{buildroot}/usr/bin/cc

	install -vdm 755 %{buildroot}/usr/lib/bfd-plugins
	ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/7.2.0/liblto_plugin.so %{buildroot}/usr/lib/bfd-plugins/

	install -vdm 755 %{buildroot}/usr/share/gdb/auto-load/usr/lib
	mv -v %{buildroot}/usr/lib/*gdb.py %{buildroot}/usr/share/gdb/auto-load/usr/lib
	cd -
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