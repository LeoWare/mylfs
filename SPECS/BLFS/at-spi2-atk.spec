Name:           at-spi2-atk
Version:        2.26.1
Release:        1%{?dist}
Summary:        The At-Spi2 Atk package contains a library that bridges ATK to At-Spi2 D-Bus service.
Vendor:			LeoWare
Distribution:	MyLFS

License:        LibGPLv2
URL:            https://github.com/GNOME/at-spi2-atk
Source0:        http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.26/at-spi2-atk-2.26.1.tar.xz

%description
The At-Spi2 Atk package contains a library that bridges ATK to At-Spi2 D-Bus service.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/libatk-bridge-2.0.*
%{_libdir}/gnome-settings-daemon-3.0/gtk-modules/*
%{_libdir}/gtk-2.0/modules/*

%post -p /sbin/ldconfig
/usr/bin/glib-compile-schemas %{_usrdir}/glib-2.0/schemas

%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%changelog
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 2.26.1-1
-	Initial build.