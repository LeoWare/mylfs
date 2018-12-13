Name:           at-spi2-core
Version:        2.26.2
Release:        1%{?dist}
Summary:        The At-Spi2 Core package is a part of the GNOME Accessibility Project.
Vendor:			LeoWare
Distribution:	MyLFS

License:        LibGPLv2
URL:            https://github.com/GNOME/at-spi2-core
Source0:        http://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.26/at-spi2-core-2.26.2.tar.xz

%description
The At-Spi2 Core package is a part of the GNOME Accessibility Project. It provides a Service Provider Interface for the Assistive Technologies available on the GNOME platform and a library against which applications can be linked.

%prep
%setup -q


%build
%configure --enable-gtk-doc
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
%{find_lang} %{name}

%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
%{_sysconfdir}/xdg/autostart/*
%{_libdir}/libatspi.*
%{_libdir}/girepository-1.0/*
%doc %{_datadir}/gtk-doc/html/*
%{_libexecdir}/*
%{_datadir}/dbus-1/accessibility-services/*
%{_datadir}/dbus-1/services/*
%{_datadir}/defaults/*
%{_datadir}/gir-1.0/*
%{_libdir}/systemd/user/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%changelog
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 2.26.2-1
-	Initial build.