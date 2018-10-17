Name:           dbus
Version:        1.12.4
Release:        1%{?dist}
Summary:        D-Bus is a message bus system, a simple way for applications to talk to one another.
Vendor:			LeoWare
Distribution:	MyLFS

Group:         System 
License:       GPLv2
URL:           http://www.freedesktop.org/wiki/Software/dbus
Source0:       http://dbus.freedesktop.org/releases/dbus/dbus-1.12.4.tar.gz

%description
D-Bus supplies both a system daemon (for events such as "new hardware device added" or "printer queue changed") and a per-user-login-session daemon (for general IPC needs among user applications). Also, the message bus is built on top of a general one-to-one message passing framework, which can be used by any two applications to communicate directly (without going through the message bus daemon).

%prep
%setup -q

%build
./configure --prefix=/usr                       \
              --sysconfdir=/etc                   \
              --localstatedir=/var                \
              --disable-static                    \
              --disable-doxygen-docs              \
              --disable-xml-docs                  \
              --docdir=/usr/share/doc/%{name}-%{version} \
              --with-console-auth-dir=/run/console
make %{?_smp_mflags}

%check
make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -vdm 755 $RPM_BUILD_ROOT/lib
mv -v $RPM_BUILD_ROOT%{_libdir}/libdbus-1.so.* $RPM_BUILD_ROOT/lib
ln -sfv ../../lib/$(readlink %{_libdir}/libdbus-1.so) %{_libdir}/libdbus-1.so
ln -sfv /etc/machine-id %{buildroot}%{_sharedstatedir}/dbus
find $RPM_BUILD_ROOT -name \*.la -delete

%clean
rm -rf $RPM_BUILD_ROOT
#rm -rf $RPM_BUILD_DIR

%files
%dir /etc/dbus-1
%config(noreplace) %{_sysconfdir}/dbus-1/*.conf
/lib/*.so.*
/lib/systemd/*
%{_bindir}/dbus-*
%{_libdir}/*.so
%{_libdir}/sysusers.d/*
%{_libdir}/tmpfiles.d/*
%{_libexecdir}/*
%{_datadir}/dbus-1/*
%doc %{_docdir}/%{name}-%{version}/*
%{_datadir}/xml/*
%dir %{_sharedstatedir}/%{name}
%{_sharedstatedir}/%{name}/*

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/cmake/*
%{_libdir}/dbus-1.0/*
%{_libdir}/pkgconfig/*.pc
%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 1.12.4-1
-	Initial build.
