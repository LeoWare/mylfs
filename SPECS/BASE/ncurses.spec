Summary:	The Ncurses package contains libraries for terminal-independent handling of character screens. 
Name:		ncurses
Version:	6.0
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu//ncurses/%{name}-%{version}.tar.gz
%description
	The Ncurses package contains libraries for terminal-independent handling of character screens. 
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
%build
	./configure \
		--prefix=%{_prefix} \
		--mandir=/usr/share/man \
		--with-shared \
		--without-debug \
		--without-normal \
		--enable-pc-files \
		--enable-widec
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/lib
	mv -v %{buildroot}/usr/lib/libncursesw.so.6* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}/usr/lib/libncursesw.so) %{buildroot}/usr/lib/libncursesw.so
	for lib in ncurses form panel menu ; do
		rm -vf %{buildroot}/usr/lib/lib${lib}.so
		echo "INPUT(-l${lib}w)" > %{buildroot}/usr/lib/lib${lib}.so
		ln -sfv ${lib}w.pc %{buildroot}/usr/lib/pkgconfig/${lib}.pc
	done
	rm -vf %{buildroot}/usr/lib/libcursesw.so
	echo "INPUT(-lncursesw)" > %{buildroot}/usr/lib/libcursesw.so
	ln -sfv libncurses.so %{buildroot}/usr/lib/libcurses.so
	#	mkdir -v       %{buildroot}/usr/share/doc/ncurses-6.0
	#	cp -v -R doc/* %{buildroot}/usr/share/doc/ncurses-6.0
	#	Copy license/copying file 
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version