Name:           dbus
Version:        1.12.4
Release:        1%{?dist}
Summary:        Dbus
Vendor:			LeoWare
Distribution:	MyLFS

License:        GPLv2.1
URL:            https://dbus.freedesktop.org
Source0:        https://dbus.freedesktop.org/releases/dbus/dbus-1.12.4.tar.gz

%description
Dbus

%prep
%setup -q


%build
./configure --prefix=/usr                \
	--sysconfdir=/etc                    \
	--localstatedir=/var                 \
	--enable-user-session                \
	--disable-doxygen-docs               \
	--disable-xml-docs                   \
	--disable-static                     \
	--docdir=/usr/share/doc/dbus-1.12.4 \
	--with-console-auth-dir=/run/console \
	--with-system-pid-file=/run/dbus/pid \
	--with-system-socket=/run/dbus/system_bus_socket
make %{?_smp_mflags}

%check
#make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
mv -v /usr/lib/libdbus-1.so.* $RPM_BUILD_ROOT/lib &&
ln -sfv ../../lib/$(readlink $RPM_BUILD_ROOT/usr/lib/libdbus-1.so) $RPM_BUILD_ROOT/usr/lib/libdbus-1.so
chown -v root:messagebus $RPM_BUILD_ROOT/usr/libexec/dbus-daemon-launch-helper
chmod -v      4750       $RPM_BUILD_ROOT/usr/libexec/dbus-daemon-launch-helper

%clean
rm -rf $RPM_BUILD_ROOT


%files
%config(noreplace) /etc/dbus-1/session.conf
%config(noreplace) /etc/dbus-1/system.conf
/lib/systemd/system/dbus.service
/lib/systemd/system/dbus.socket
/lib/systemd/system/multi-user.target.wants/dbus.service
/lib/systemd/system/sockets.target.wants/dbus.socket
%{_bindir}/dbus-*
%{_libdir}/libdbus-1.*
%{_libdir}/systemd/user/dbus.service
%{_libdir}/systemd/user/dbus.socket
%{_libdir}/systemd/user/sockets.target.wants/dbus.socket
%{_libdir}/sysusers.d/*
%{_libdir}/tmpfiles.d/*

%{_libexecdir}/*
%{_datadir}/dbus-1/*
%doc %{_docdir}/%{name}-%{version}/*
%{_datadir}/xml/dbus-1/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/dbus-1.0/*
%{_libdir}/cmake/DBus1/*.cmake
%{_libdir}/dbus-1.0/include/*
%{_libdir}/pkgconfig/*.pc


%changelog
*	Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 1.12.4-1
-	Initial build.