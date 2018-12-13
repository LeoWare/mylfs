Name:           harfbuzz
Version:        1.7.5
Release:        1%{?dist}
Summary:        The Fontconfig package contains a library and support programs used for configuring and customizing font access.

License:        TBD
URL:            https://www.freedesktop.org/wiki/Software/harfbuzz/
Source0:        https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.7.5.tar.bz2

BuildRequires:  glib, glib-devel, icu, icu-devel, freetype, freetype-devel, cairo, cairo-devel, gobject-introspection, gobject-introspection-devel

%description
The Fontconfig package contains a library and support programs used for configuring and customizing font access.

%prep
%setup -q
rm -f src/fcobjshash.h

%build
%configure	--with-gobject --enable-gtk-goc
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*.so*
%doc %{_datadir}/gtk-doc/html/*
%{_libdir}/girepository-1.0/*.typelib
%{_datadir}/gir-1.0/*.gir

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc



%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.7.5-1
-	Initial build.