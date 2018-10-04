Summary:	The Bc package contains an arbitrary precision numeric processing language
Name:		bc
Version:	1.07.1
Release:	1
License:	GPLv3
URL:		http://www.gnu.org
Group:		LFS/Base
Vendor:		Octothorpe
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
#ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
#ln -sfv libncurses.so.6 /usr/lib/libncurses.so
#sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure
%build
	./configure \
		--prefix=%{_prefix} \
		--with-readline \
		--mandir=%{_mandir} \
		--infodir=%{_infodir}
	make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/%{_mandir}
rm -rf %{buildroot}%{_infodir}
rm -f /usr/lib/libncursesw.so.6
rm -f /usr/lib/libncurses.so
%check
#make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post
/sbin/ldconfig
%postun
/sbin/ldconfi
%files
%defattr(-,root,root)
%{_bindir}/*
%{_mandir}/*/*
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.07.1-1
-	Initial build.	First version
