Summary:	The Readline package is a set of libraries that offers command-line editing and history capabilities
Name:		readline
Version:	7.0
Release:	1
License:	Any
URL:		http://ftp.gnu.org/
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
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
		--docdir=/usr/share/doc/%{name}-%{version}
	make %{?_smp_mflags} SHLIB_LIBS="-L/tools/lib -lncursesw"
%install
	make DESTDIR=%{buildroot} SHLIB_LIBS="-L/tools/lib -lncurses" install
	install -vdm 755 %{buildroot}/lib
	install -vdm 755 %{buildroot}/usr/lib
	mv -v %{buildroot}/usr/lib/lib{readline,history}.so.* %{buildroot}/lib
	ln -sfv ../../lib/$(readlink %{buildroot}/usr/lib/libreadline.so) %{buildroot}/usr/lib/libreadline.so
	ln -sfv ../../lib/$(readlink %{buildroot}/usr/lib/libhistory.so ) %{buildroot}/usr/lib/libhistory.so
	rm -rf %{buildroot}/usr/share/info
	#	Copy license/copying file 
	#install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version