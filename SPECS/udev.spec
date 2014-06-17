Summary:	Programs for dynamic creation of device nodes
Name:		udev
Version:	208
Release:	1
License:	GPLv2
URL:		http://www.freedesktop.org/wiki/Software/systemd/
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source0:	http://www.freedesktop.org/software/systemd/systemd-%{version}.tar.xz
Source1:	http://anduin.linuxfromscratch.org/sources/other/udev-lfs-%{version}-3.tar.bz2
%description
The Udev package contains programs for dynamic creation of device nodes.
%prep
cd %{_builddir}
tar xf %{SOURCE0}
tar xf %{SOURCE1}
cd %{_builddir}/systemd-%{version}
mv ../udev-lfs-%{version}-3 .
%build
cd %{_builddir}/systemd-%{version}
ln -svf /tools/include/blkid /usr/include
ln -svf /tools/include/uuid  /usr/include
export LD_LIBRARY_PATH=/tools/lib
make VERBOSE=1 %{?_smp_mflags} -f udev-lfs-%{version}-3/Makefile.lfs
%install
cd %{_builddir}/systemd-%{version}
make -f udev-lfs-%{version}-3/Makefile.lfs DESTDIR=%{buildroot} install
%post
/sbin/ldconfig
/sbin/udevadm hwdb --update
bash /lib/udev/init-net-rules.sh || true
%postun	-p /sbin/ldconfig
%files 
%defattr(-,root,root)
%config /etc/udev/rules.d/55-lfs.rules
%config /etc/udev/rules.d/81-cdrom.rules
%config /etc/udev/rules.d/83-cdrom-symlinks.rules
/lib/*
/sbin/*
%{_libdir}/*
%{_includedir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_datarootdir}/gtk-doc/html/libudev/*
%{_mandir}/*/*
%changelog
*	Tue Jun 17 2014 baho-utot <baho-utot@columbus.rr.com> 208-1
*	Fri Aug 30 2013 baho-utot <baho-utot@columbus.rr.com> 206-2
-	fix perms on /lib/usev/init-net-rules.sh
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 206-1
-	Update version
*	Sat May 11 2013 baho-utot <baho-utot@columbus.rr.com> 204-1
-	Update version to 204
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 202-1
-	Intial version
