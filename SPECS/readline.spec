Summary:	Command-line editing and history capabilities
Name:		readline
Version:	7.0
Release:	1
License:	GPLv3
URL:		http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/readline/%{name}-%{version}.tar.gz
%description
The Readline package is a set of libraries that offers command-line
editing and history capabilities.
%prep
%setup -q
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
%build
./configure --prefix=/usr    \
	--disable-static \
	--docdir=/usr/share/doc/readline-7.0
make %{?_smp_mflags} SHLIB_LIBS="-L/tools/lib -lncursesw"
%install
make SHLIB_LIBS="-L/tools/lib -lncursesw" DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}%{_lib}
mv -v %{buildroot}%{_libdir}/lib{readline,history}.so.* %{buildroot}%{_lib}
ln -sfv ../..%{_lib}/$(readlink %{buildroot}%{_libdir}/libreadline.so) %{buildroot}%{_libdir}/libreadline.so
ln -sfv ../..%{_lib}/$(readlink %{buildroot}%{_libdir}/libhistory.so ) %{buildroot}%{_libdir}/libhistory.so
install -vdm 755 %{buildroot}%{_defaultdocdir}/%{name}-%{version}
install -v -m644 doc/*.{ps,pdf,html,dvi} %{buildroot}%{_defaultdocdir}/%{name}-%{version}
rm -rf %{buildroot}%{_infodir}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_lib}/*
%{_includedir}/*
%{_libdir}/*
%{_mandir}/*/*
%{_defaultdocdir}/%{name}-%{version}/*
%changelog
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 6.2-1
-	Initial build.	First version
