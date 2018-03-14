Summary:	The Bc package contains an arbitrary precision numeric processing language
Name:		bc
Version:	1.07.1
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.gz
%description
	The Bc package contains an arbitrary precision numeric processing language
%prep
%setup -q -n %{NAME}-%{VERSION}
	cat > bc/fix-libmath_h <<- "EOF"
	#! /bin/bash
	sed -e '1   s/^/{"/' \
	    -e     's/$/",/' \
	    -e '2,$ s/^/"/'  \
	    -e   '$ d'       \
	    -i libmath.h

	sed -e '$ s/$/0}/' \
    	-i libmath.h
	EOF
	sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure
%build
	./configure \
		--prefix=%{_prefix} \
		--with-readline \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
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