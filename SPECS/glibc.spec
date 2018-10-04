Summary:	Main C library
Name:		glibc
Version:	2.27
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/libc
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/glibc/%{name}-%{version}.tar.xz
Patch0:		glibc-2.27-fhs-1.patch
%description
This library provides the basic routines for allocating memory,
searching directories, opening and closing files, reading and
writing files, string handling, pattern matching, arithmetic,
and so on.
%prep
%setup -q
#sed -i 's/\\$$(pwd)/`pwd`/' timezone/Makefile
%patch0 -p1
install -vdm 755 %{_builddir}/%{name}-build
ln -sfv /tools/lib/gcc /usr/lib
%build
%ifarch x86_64
	GCC_INCDIR=/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
	install -vdm 755 %{buildroot}/lib64
	ln -sfv ../lib/ld-linux-x86-64.so.2 %{buildroot}/lib64
	ln -sfv ../lib/ld-linux-x86-64.so.2 %{buildroot}/lib64/ld-lsb-x86-64.so.3
%else
	GCC_INCDIR=/usr/lib/gcc/$(uname -m)-pc-linux-gnu/7.3.0/include
	ln -sfv ld-linux.so.2 %{buildroot}/lib/ld-lsb.so.3
%endif
rm -f /usr/include/limits.h
cd %{_builddir}/%{name}-build
CC="gcc -isystem $GCC_INCDIR -isystem /usr/include" \
	../%{name}-%{version}/configure --prefix=%{_prefix} \
	--disable-werror \
	--enable-kernel=3.2 \
	--enable-stack-protector=strong \
	libc_cv_slibdir=/lib
unset GCC_INCDIR
make %{?_smp_mflags}
%check
cd %{_builddir}/glibc-build
make -k check > %{_topdir}/LOGS/%{name}-check.log 2>&1 || true
%install
#	Do not remove static libs
cd %{_builddir}/glibc-build
install -vdm 755 %{buildroot}%{_sysconfdir}
cat > %{buildroot}%{_sysconfdir}/ld.so.conf <<- "EOF"
#	Begin /etc/ld.so.conf
	/usr/local/lib
	/opt/lib
	include /etc/ld.so.conf.d/*.conf
EOF
sed '/test-installation/s@$(PERL)@echo not running@' -i ../%{name}-%{version}/Makefile
#	Create directories
make install_root=%{buildroot} install
install -vdm 755 %{buildroot}%{_sysconfdir}/ld.so.conf.d
cp -v %{_builddir}/%{name}-%{version}/nscd/nscd.conf %{buildroot}%{_sysconfdir}/nscd.conf
install -vdm 755 %{buildroot}/var/cache/nscd
install -v -Dm644 %{_builddir}/%{name}-%{version}/nscd/nscd.tmpfiles %{buildroot}/usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 %{_builddir}/%{name}-%{version}/nscd/nscd.service %{buildroot}/lib/systemd/system/nscd.service

install -vdm 755 %{buildroot}%{_libdir}/locale

#	Install locale generation script and config file
cp -v %{_topdir}/locale-gen.conf %{buildroot}%{_sysconfdir}
cp -v %{_topdir}/locale-gen.sh %{buildroot}/sbin
#	Remove unwanted cruft
# this links to /lib/ld-2.6.so, we want this to link to ld-lsb instead.
# leaving this file conflicts on installation on x86_64
rm -f %{buildroot}%{_lib}/ld-linux-x86-64.so.2
rm -rf %{buildroot}%{_infodir}
#	Install configuration files
cat > %{buildroot}%{_sysconfdir}/nsswitch.conf <<- "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

%post
# locale-gen.sh depends on sed
# sed is not present when building from the toolchain
# which hasn't been installed yet
# if /bin/sed isn't present, create a link to the toolchain version
[ -e /bin/sed ] || ln -sv /tools/bin/sed /bin
printf "Creating ldconfig cache\n";/sbin/ldconfig
printf "Creating locale files\n";/sbin/locale-gen.sh
# if we had to link to the toolchain sed, remove the link now
[ -h /bin/sed ] && rm -fv /bin/sed
%files
%defattr(-,root,root)
%dir %{_localstatedir}/cache/nscd
%dir %{_libdir}/locale
%{_sysconfdir}/*
%ifarch x86_64
%{_lib}/*
%{_libdir}/*
%{_lib64}/*
#%{_lib64dir}/*
%else
%{_lib}/*
%endif
/sbin/*
%{_bindir}/*
%{_includedir}/*
%{_libexecdir}/*
%{_sbindir}/*
%{_datadir}/i18n/charmaps/*.gz
%{_datadir}/i18n/locales/*
%lang(be) %{_datarootdir}/locale/be/LC_MESSAGES/libc.mo
%lang(bg) %{_datarootdir}/locale/bg/LC_MESSAGES/libc.mo
%lang(ca) %{_datarootdir}/locale/ca/LC_MESSAGES/libc.mo
%lang(cs) %{_datarootdir}/locale/cs/LC_MESSAGES/libc.mo
%lang(da) %{_datarootdir}/locale/da/LC_MESSAGES/libc.mo
%lang(de) %{_datarootdir}/locale/de/LC_MESSAGES/libc.mo
%lang(el) %{_datarootdir}/locale/el/LC_MESSAGES/libc.mo
%lang(en_GB) %{_datarootdir}/locale/en_GB/LC_MESSAGES/libc.mo
%lang(eo) %{_datarootdir}/locale/eo/LC_MESSAGES/libc.mo
%lang(es) %{_datarootdir}/locale/es/LC_MESSAGES/libc.mo
%lang(fi) %{_datarootdir}/locale/fi/LC_MESSAGES/libc.mo
%lang(fr) %{_datarootdir}/locale/fr/LC_MESSAGES/libc.mo
%lang(gl) %{_datarootdir}/locale/gl/LC_MESSAGES/libc.mo
%lang(hr) %{_datarootdir}/locale/hr/LC_MESSAGES/libc.mo
%lang(hu) %{_datarootdir}/locale/hu/LC_MESSAGES/libc.mo
%lang(ia) %{_datarootdir}/locale/ia/LC_MESSAGES/libc.mo
%lang(id) %{_datarootdir}/locale/id/LC_MESSAGES/libc.mo
%lang(it) %{_datarootdir}/locale/it/LC_MESSAGES/libc.mo
%lang(ja) %{_datarootdir}/locale/ja/LC_MESSAGES/libc.mo
%lang(ko) %{_datarootdir}/locale/ko/LC_MESSAGES/libc.mo
%{_datarootdir}/locale/locale.alias
%lang(lt) %{_datarootdir}/locale/lt/LC_MESSAGES/libc.mo
%lang(nb) %{_datarootdir}/locale/nb/LC_MESSAGES/libc.mo
%lang(nl) %{_datarootdir}/locale/nl/LC_MESSAGES/libc.mo
%lang(pl) %{_datarootdir}/locale/pl/LC_MESSAGES/libc.mo
%lang(pt_BR) %{_datarootdir}/locale/pt_BR/LC_MESSAGES/libc.mo
%lang(ru) %{_datarootdir}/locale/ru/LC_MESSAGES/libc.mo
%lang(rw) %{_datarootdir}/locale/rw/LC_MESSAGES/libc.mo
%lang(sk) %{_datarootdir}/locale/sk/LC_MESSAGES/libc.mo
%lang(sl) %{_datarootdir}/locale/sl/LC_MESSAGES/libc.mo
%lang(sv) %{_datarootdir}/locale/sv/LC_MESSAGES/libc.mo
%lang(tr) %{_datarootdir}/locale/tr/LC_MESSAGES/libc.mo
%lang(uk) %{_datarootdir}/locale/uk/LC_MESSAGES/libc.mo
%lang(vi) %{_datarootdir}/locale/vi/LC_MESSAGES/libc.mo
%lang(zh_CN) %{_datarootdir}/locale/zh_CN/LC_MESSAGES/libc.mo
%lang(zh_TW) %{_datarootdir}/locale/zh_TW/LC_MESSAGES/libc.mo
%{_localstatedir}/lib/nss_db/Makefile
%changelog
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 2.19-1
*	Sun Sep 01 2013 baho-utot <baho-utot@columbus.rr.com> 2.18-2
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 2.18-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 2.17-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.16-1
-	Initial version
