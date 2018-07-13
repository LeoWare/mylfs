Summary:	The Readline package is a set of libraries that offers command-line editing and history capabilities
Name:	readline
Version:	7.0
Release:	1
License:	GPLv3
URL:		http://ftp.gnu.org/gnu/readline/%{name}-%{version}.tar.gz
Group:	LFS/Base
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.gz
%description
	The Readline package is a set of libraries that offers command-line editing and history capabilities
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i '/MV.*old/d' Makefile.in
	sed -i '/{OLDSUFF}/c:' support/shlib-install
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static \
		--docdir=%{_mandir}/%{name}-%{version}
	make %{?_smp_mflags} SHLIB_LIBS="-L/tools/lib -lncursesw"
%install
	make DESTDIR=%{buildroot} SHLIB_LIBS="-L/tools/lib -lncurses" install
	install -vdm 755 %{buildroot}/lib
	install -vdm 755 %{buildroot}%{_libdir}
	mv -v %{buildroot}%{_libdir}/lib{readline,history}.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libreadline.so) %{buildroot}%{_libdir}/libreadline.so
	ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/libhistory.so ) %{buildroot}%{_libdir}/libhistory.so
	rm -rf %{buildroot}%{_infodir}
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot}%{_infodir} -name 'dir' -delete
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man3/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 7.0-1
-	Initial build.	First version
