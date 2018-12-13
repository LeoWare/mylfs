Name:           librsvg
Version:        2.42.2
Release:        2%{?dist}
Summary:        The librsvg package contains a library and tools used to manipulate, convert and view Scalable Vector Graphic (SVG) images. 
Vendor:			LeoWare
Distribution:	MyLFS

License:        Unknown
URL:            https://wiki.gnome.org/action/show/Projects/LibRsvg
Source0:        http://ftp.gnome.org/pub/gnome/sources/librsvg/2.42/%{name}-%{version}.tar.xz

BuildRequires:  gdk-pixbuf, gdk-pixbuf-devel, libcroco, libcroco-devel, pango, pango-devel
BuildRequires:  rustc, rustc-devel, gobject-introspection, gtk+ >= 3, gtk+-devel >= 3
BuildRequires:  gtk-doc

%description
The librsvg package contains a library and tools used to manipulate, convert and view Scalable Vector Graphic (SVG) images. 

%prep
%setup -q


%build
%configure --prefix=/usr    \
            --enable-vala    \
            --disable-static \
            --enable-gtk-doc
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/librsvg-2.*
%{_libdir}/libpixbufloader-svg.*
%{_datadir}/gtk-doc/html/*

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
*	Wed Dec 12 2018 Samuel Raynor <samuel@samuelraynor.com> 2.42.2-2
-	Added BuildRequires to spec.
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 2.42.2-1
-	Initial build.