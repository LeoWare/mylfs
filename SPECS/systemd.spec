Name:           systemd
Version:        237
Release:        1%{?dist}
Summary:        The systemd package contains programs for controlling the startup, running, and shutdown of the system.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          System Environment/Base
License:        GPLv2
URL:            http://www.freedesktop.org/wiki/Software/systemd/
Source0:        https://github.com/systemd/systemd/archive/v%{version}/%{name}-%{version}.tar.gz
Source1:		http://anduin.linuxfromscratch.org/LFS/systemd-man-pages-237.tar.xz

%description
The systemd package contains programs for controlling the startup, running, and shutdown of the system.

%prep
%setup -q
%setup -T -D -a 1
ln -svf /bin/true /usr/bin/xsltproc
sed '178,222d' -i src/resolve/meson.build
sed -i 's/GROUP="render", //' rules/50-udev-default.rules.in

%build
cd       build

LANG=en_US.UTF-8                   \
meson --prefix=/usr                \
      --sysconfdir=/etc            \
      --localstatedir=/var         \
      -Dblkid=true                 \
      -Dbuildtype=release          \
      -Ddefault-dnssec=no          \
      -Dfirstboot=false          \
      -Dinstall-tests=false        \
      -Dkill-path=/bin/kill        \
      -Dkmod-path=/bin/kmod        \
      -Dldconfig=false             \
      -Dmount-path=/bin/mount      \
      -Drootprefix=                \
      -Drootlibdir=/lib            \
      -Dsplit-usr=true             \
      -Dsulogin-path=/sbin/sulogin \
      -Dsysusers=false             \
      -Dumount-path=/bin/umount    \
      -Db_lto=false                \
	  -Defi=true \
	  -Dgnu-efi=true \
	  -Dseccomp=true \
      ..
LANG=en_US.UTF-8 %{_bindir}/ninja

%install
rm -rf $RPM_BUILD_ROOT
cd build
LANG=en_US.UTF-8 DESTDIR=$RPM_BUILD_ROOT %{_bindir}/ninja install
install -vdm 755 $RPM_BUILD_ROOT/sbin
for tool in runlevel reboot shutdown poweroff halt telinit; do
     ln -sfv ../bin/systemctl $RPM_BUILD_ROOT/sbin/${tool}
done
ln -sfv ../lib/systemd/systemd $RPM_BUILD_ROOT/sbin/init
#%find_lang %{name}.lang
#cat > $RPM_BUILD_ROOT/%{_lib}/systemd/systemd-user-sessions << "EOF"
##!/bin/bash
#rm -f /run/nologin
#EOF
#chmod -v 755 $RPM_BUILD_ROOT/lib/systemd/systemd-user-sessions


%clean
rm -rf $RPM_BUILD_ROOT
rm -vf %{_bindir}/xsltproc


%files
/bin/*
%{_sysconfdir}/X11/xinit/xinitrc.d/*.sh
%{_sysconfdir}/init.d/README
%config(noreplace) %{_sysconfdir}/pam.d/*
%config(noreplace) %{_sysconfdir}/systemd/*.conf
%{_sysconfdir}/systemd/system/*
%{_sysconfdir}/udev/*.conf
%{_sysconfdir}/xdg/systemd/user
/lib/libnss*
/lib/libsystemd*
/lib/libudev*
%config(noreplace) /lib/modprobe.d/systemd.conf
/lib/security/*.so
/lib/systemd/*
/lib/udev/*
/sbin/*
%{_bindir}/*
%{_libdir}/systemd/*
%{_libdir}/tmpfiles.d/*
%{_libdir}/environment.d/*
%{_libdir}/kernel/*
%{_libdir}/sysctl.d/*
%{_datadir}/bash-completion/completions/*
%{_datadir}/dbus-1/*
%doc %{_docdir}/systemd/*
%{_datadir}/factory/*
%{_mandir}/*/*
%{_datadir}/polkit-1/*
%{_datadir}/systemd/*
%{_datadir}/zsh/*
%{_var}/log/README
%lang(be) %{_datadir}/locale/be/LC_MESSAGES/systemd.mo
%lang(be@latin) %{_datadir}/locale/be@latin/LC_MESSAGES/systemd.mo
%lang(bg) %{_datadir}/locale/bg/LC_MESSAGES/systemd.mo
%lang(ca) %{_datadir}/locale/ca/LC_MESSAGES/systemd.mo
%lang(cs) %{_datadir}/locale/cs/LC_MESSAGES/systemd.mo
%lang(da) %{_datadir}/locale/da/LC_MESSAGES/systemd.mo
%lang(de) %{_datadir}/locale/de/LC_MESSAGES/systemd.mo
%lang(el) %{_datadir}/locale/el/LC_MESSAGES/systemd.mo
%lang(es) %{_datadir}/locale/es/LC_MESSAGES/systemd.mo
%lang(fr) %{_datadir}/locale/fr/LC_MESSAGES/systemd.mo
%lang(gr) %{_datadir}/locale/gl/LC_MESSAGES/systemd.mo
%lang(hr) %{_datadir}/locale/hr/LC_MESSAGES/systemd.mo
%lang(hu) %{_datadir}/locale/hu/LC_MESSAGES/systemd.mo
%lang(id) %{_datadir}/locale/id/LC_MESSAGES/systemd.mo
%lang(it) %{_datadir}/locale/it/LC_MESSAGES/systemd.mo
%lang(ko) %{_datadir}/locale/ko/LC_MESSAGES/systemd.mo
%lang(pl) %{_datadir}/locale/pl/LC_MESSAGES/systemd.mo
%lang(pt_BR) %{_datadir}/locale/pt_BR/LC_MESSAGES/systemd.mo
%lang(ro) %{_datadir}/locale/ro/LC_MESSAGES/systemd.mo
%lang(ru) %{_datadir}/locale/ru/LC_MESSAGES/systemd.mo
%lang(sk) %{_datadir}/locale/sk/LC_MESSAGES/systemd.mo
%lang(sr) %{_datadir}/locale/sr/LC_MESSAGES/systemd.mo
%lang(sv) %{_datadir}/locale/sv/LC_MESSAGES/systemd.mo
%lang(tr) %{_datadir}/locale/tr/LC_MESSAGES/systemd.mo
%lang(uk) %{_datadir}/locale/uk/LC_MESSAGES/systemd.mo
%lang(zh_CN) %{_datadir}/locale/zh_CN/LC_MESSAGES/systemd.mo
%lang(zh_TW) %{_datadir}/locale/zh_TW/LC_MESSAGES/systemd.mo

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_lib64dir}/pkgconfig/*.pc
%{_datadir}/pkgconfig/*.pc
%{_libdir}/rpm/*


%changelog
*	Thu Oct 11 2018 Samuel Raynor <samuel@samuelraynor.com> 237-1
-	Initial build.
