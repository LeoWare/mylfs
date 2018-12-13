Name:           gtksourceview
Version:        3.24.6
Release:        1%{?dist}
Summary:        The GtkSourceView package contains libraries used for extending the GTK+ text functions to include syntax highlighting.

License:        GPLv2
URL:            https://wiki.gnome.org/Projects/GtkSourceView
Source0:        http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.24/gtksourceview-3.24.6.tar.xz

BuildRequires:  gtk+ >= 3, gtk+-devel >= 3

%description
The GtkSourceView package contains libraries used for extending the GTK+ text functions to include syntax highlighting.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%find_lang %{name}-3.0
%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}-3.0.lang
%{_libdir}/girepository-1.0/*
%{_libdir}/lib%{name}*
%{_datadir}/gir-1.0/*
%{_datadir}/gtksourceview-3.0/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc
%{_datadir}/gtk-doc/html/*


%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 3.24.6-1
-	Initial build