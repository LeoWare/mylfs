Summary:	Programming language
Name:		lua
Version:	5.2.3
Release:	1
License:	MIT
URL:		http://www.lua.org
Group:		Development/Tools
Vendor:		Bildanet
Distribution:	Octothorpe
Source0:	ttp://www.lua.org/ftp/%{name}-%{version}.tar.gz
Patch0:		lua-5.2.3-shared_library-1.patch
%description
Lua is a powerful, light-weight programming language designed for extending
applications. Lua is also frequently used as a general-purpose, stand-alone
language. Lua is free software
%prep
%setup -q
%patch0 -p1
sed -i '/#define LUA_ROOT/s:/usr/local/:/usr/:' src/luaconf.h
%build
make VERBOSE=1 %{?_smp_mflags} linux
%install
make %{?_smp_mflags} \
	INSTALL_TOP=%{buildroot}/usr TO_LIB="liblua.so \
	liblua.so.5.2 liblua.so.5.2.3" \
	INSTALL_DATA="cp -d" \
	INSTALL_MAN=%{buildroot}/usr/share/man/man1 \
	install
install -vdm 755 %{buildroot}%{_libdir}/pkgconfig
cat > %{buildroot}%{_libdir}/pkgconfig/lua.pc <<- "EOF"
	V=5.2
	R=5.2.3

	prefix=/usr
	INSTALL_BIN=${prefix}/bin
	INSTALL_INC=${prefix}/include
	INSTALL_LIB=${prefix}/lib
	INSTALL_MAN=${prefix}/man/man1
	exec_prefix=${prefix}
	libdir=${exec_prefix}/lib
	includedir=${prefix}/include

	Name: Lua
	Description: An Extensible Extension Language
	Version: ${R}
	Requires: 
	Libs: -L${libdir} -llua -lm
	Cflags: -I${includedir}
EOF
rmdir %{buildroot}%{_libdir}/lua/5.2
rmdir %{buildroot}%{_libdir}/lua
%clean
rm -rf %{buildroot}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%{_mandir}/*/*
%changelog
*	Thu Apr 10 2014 GangGreene <GangGreene@bildanet.com> 5.2.3-1
*	Tue Jul 02 2013 GangGreene <GangGreene@bildanet.com> 5.2.2-1
*	Wed Jan 30 2013 GangGreene <GangGreene@bildanet.com> 5.1.5-1
-	Initial build.	First version