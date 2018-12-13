Name:           gtk+
Version:        3.22.28
Release:        1%{?dist}
Summary:        The GTK+ 3 package contains libraries used for creating graphical user interfaces for applications.
Vendor:			LeoWare
Distribution:	MyLFS

License:        GPLv2
URL:            http://www.gtk.org/
Source0:        http://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/gtk+-3.22.28.tar.xz

%description
The GTK+ 3 package contains libraries used for creating graphical user interfaces for applications.

%prep
%setup -q

%build
%configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --enable-broadway-backend \
            --enable-x11-backend      \
            --enable-wayland-backend \
            --enable-gtk2-dependency
make %{?_smp_mflags}

%check
#make -k check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
%find_lang gtk30-properties
%find_lang gtk30

%clean
rm -rf $RPM_BUILD_ROOT


%files -f gtk30-properties.lang -f gtk30.lang
%config(noreplace) %{_sysconfdir}/gtk-3.0/im-multipress.conf
%{_bindir}/*
%{_libdir}/girepository-1.0/*
%{_libdir}/gtk-3.0/*
%{_libdir}/libgdk-3.*
%{_datadir}/aclocal/*
%{_datadir}/applications/*
%{_datadir}/gettext/its/*
%{_datadir}/gir-1.0/*
%{_datadir}/glib-2.0/*
%{_datadir}/gtk-3.0/*
%{_datadir}/gtk-doc/*
%{_datadir}/icons/hicolor/
%doc %{_mandir}/*/*
%{_datadir}/themes/*
%{_libdir}/libgailutil-3.*
%{_libdir}/libgtk-3.*

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/gail-3.0/*
%{_includedir}/gtk-3.0/*
%{_libdir}/pkgconfig

%post -p /sbin/ldconfig
%{_bindir}/gtk-query-immodules-3.0 --update-cache

%postun -p /sbin/ldconfig

%changelog
*	Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 3.22.28-1
-	Initial build.