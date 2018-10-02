#-----------------------------------------------------------------------------
Summary:	The GCC package contains the GNU compiler collection
Name:		gcc
Version:	7.3.0
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}/%{name}-%{version}.tar.xz
BuildRequires:	mpc
#Provides:	libgcc_s.so.1()(64bit)
#Provides:	libgcc_s.so.1(GCC_3.0)(64bit)
#Provides:	libgcc_s.so.1(GCC_3.3)(64bit)
#Provides:	libgcc_s.so.1(GCC_4.2.0)(64bit)
%description
			The GCC package contains the GNU compiler collection, which includes the C and C++ compilers.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
	rm -f /usr/lib/gcc
	mkdir build
%build
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
	ln -sv ..%{_bindir}/cpp %{buildroot}/lib
	install -vdm 755 %{buildroot}%{_bindir}
	ln -sv gcc %{buildroot}%{_bindir}/cc
	install -vdm 755 %{buildroot}%{_libdir}/bfd-plugins
	ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/7.2.0/liblto_plugin.so %{buildroot}%{_libdir}/bfd-plugins/
	cd -
	install -vd 755 %{buildroot}/usr/share/gdb/auto-load/usr/lib
	mv -v %{buildroot}/usr/lib/*gdb.py %{buildroot}/usr/share/gdb/auto-load/usr/lib
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
	%{_mandir}/man7/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 7.3.0-1
-	Initial build.	First version
