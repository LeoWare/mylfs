Summary:	Contains the utilities for the ext2 file system
Name:		e2fsprogs
Version:	1.42.9
Release:	1
License:	GPLv2
URL:		http://e2fsprogs.sourceforge.net
Group:		LFS/Base
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://prdownloads.sourceforge.net/e2fsprogs/%{name}-%{version}.tar.gz
%description
The E2fsprogs package contains the utilities for handling
the ext2 file system.
%prep
%setup -q
install -vdm 755 build
sed -i -e 's|^LD_LIBRARY_PATH.*|&:/tools/lib|' tests/test_config
%build
cd build
LIBS=-L/tools/lib \
CFLAGS=-I/tools/include \
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
../configure \
	--prefix=%{_prefix} \
	--with-root-prefix='' \
	--enable-elf-shlibs \
	--disable-libblkid \
	--disable-libuuid \
	--disable-uuidd \
	--disable-fsck \
	--disable-silent-rules
make %{?_smp_mflags}
%install
cd build
make DESTDIR=%{buildroot} install
make DESTDIR=%{buildroot} install-libs
chmod -v u+w %{buildroot}/%{_libdir}/{libcom_err,libe2p,libext2fs,libss}.a
rm -rf %{buildroot}%{_infodir}
%check
cd build
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%config /etc/mke2fs.conf
%{_lib}/*
/sbin/*
%{_bindir}/*
%{_libdir}*
%{_sbindir}/*
%{_includedir}/*
%lang(ca) %{_datarootdir}/locale/ca/LC_MESSAGES/e2fsprogs.mo
%lang(cs) %{_datarootdir}/locale/cs/LC_MESSAGES/e2fsprogs.mo
%lang(de) %{_datarootdir}/locale/de/LC_MESSAGES/e2fsprogs.mo
%lang(es) %{_datarootdir}/locale/es/LC_MESSAGES/e2fsprogs.mo
%lang(fr) %{_datarootdir}/locale/fr/LC_MESSAGES/e2fsprogs.mo
%lang(id) %{_datarootdir}/locale/id/LC_MESSAGES/e2fsprogs.mo
%lang(it) %{_datarootdir}/locale/it/LC_MESSAGES/e2fsprogs.mo
%lang(nl) %{_datarootdir}/locale/nl/LC_MESSAGES/e2fsprogs.mo
%lang(pl) %{_datarootdir}/locale/pl/LC_MESSAGES/e2fsprogs.mo
%lang(sv) %{_datarootdir}/locale/sv/LC_MESSAGES/e2fsprogs.mo
%lang(tr) %{_datarootdir}/locale/tr/LC_MESSAGES/e2fsprogs.mo
%lang(vi) %{_datarootdir}/locale/vi/LC_MESSAGES/e2fsprogs.mo
%lang(zh_CN) %{_datarootdir}/locale/zh_CN/LC_MESSAGES/e2fsprogs.mo
%{_datarootdir}/et/*
%{_datarootdir}/ss/*
%{_mandir}/*/*
%changelog
*	Sat Apr 05 2014 baho-utot <baho-utot@columbus.rr.com> 1.42.9-1
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 1.42.8-1
-	Upgrade version
#

