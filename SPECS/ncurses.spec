#TARBALL:	http://ftp.gnu.org/gnu//ncurses/ncurses-6.1.tar.gz
#MD5SUM:	98c889aaf8d23910d2b92d65be2e737a;SOURCES/ncurses-6.1.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Ncurses package contains libraries for terminal-independent handling of character screens.
Name:		ncurses
Version:	6.1
Release:	1
License:	GPL
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu//ncurses/%{name}-%{version}.tar.gz
%description
The Ncurses package contains libraries for terminal-independent handling of character screens.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
%build
	./configure \
		--prefix=%{_prefix} \
		--mandir=%{_mandir} \
		--with-shared \
		--without-debug \
		--without-normal \
		--enable-pc-files \
		--enable-widec
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}%{_libdir}/libncursesw.so.6* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libncursesw.so) %{buildroot}%{_libdir}/libncursesw.so
	for lib in ncurses form panel menu ; do
		rm -vf %{buildroot}%{_libdir}/lib${lib}.so
		echo "INPUT(-l${lib}w)" > %{buildroot}%{_libdir}/lib${lib}.so
		ln -sfv ${lib}w.pc %{buildroot}%{_libdir}/pkgconfig/${lib}.pc
	done
	rm -vf %{buildroot}%{_libdir}/libcursesw.so
	echo "INPUT(-lncursesw)" > %{buildroot}%{_libdir}/libcursesw.so
	ln -sfv libncurses.so %{buildroot}%{_libdir}/libcurses.so
#	install -vdm 755 %{buildroot}%{_docdir}/%{NAME}-%{VERSION}
#	cp -v -R doc/* %{buildroot}%{_docdir}/%{NAME}-%{VERSION}
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man1/*.gz
	%{_mandir}/man3/*.gz
	%{_mandir}/man5/*.gz
	%{_mandir}/man7/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 6.1-1
-	Initial build.	First version
