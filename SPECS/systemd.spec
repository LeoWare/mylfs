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
      -Dfirstboot=false            \
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

#cat > $RPM_BUILD_ROOT/%{_lib}/systemd/systemd-user-sessions << "EOF"
##!/bin/bash
#rm -f /run/nologin
#EOF
#chmod -v 755 $RPM_BUILD_ROOT/lib/systemd/systemd-user-sessions

%clean
rm -rf $RPM_BUILD_ROOT
rm -vf %{_bindir}/xsltproc


%files


%changelog
*	Thu Oct 11 2018 Samuel Raynor <samuel@samuelraynor.com> 237-1
-	Initial build.
