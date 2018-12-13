%define __gdk_pixbuf_query_loaders %(which gdk-pixbuf-query-loaders)
Name:           gdk-pixbuf
Version:        2.36.11
Release:        1%{?dist}
Summary:        The Gdk Pixbuf package is a toolkit for image loading and pixel buffer manipulation.

License:        TBD
URL:            TBD
Source0:        http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.11.tar.xz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  glib, glib-devel, libjpeg-turbo, libjpeg-turbo-devel, libpng, libpng-devel
BuildRequires:  shared-mime-info, libtiff, libtiff-devel, gtk-doc, which


%description
The Gdk Pixbuf package is a toolkit for image loading and pixel buffer manipulation. It is used by GTK+ 2 and GTK+ 3 to load and manipulate images. In the past it was distributed as part of GTK+ 2 but it was split off into a separate package in preparation for the change to GTK+ 3.

%prep
%setup -q


%build
%configure --with-x11 --enable-gtk-doc
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files


%post
/sbin/ldconfig
%{__gdk_pixbuf_query_loaders} --update-cache

%postun 
/sbin/ldconfig
%{__gdk_pixbuf_query_loaders} --update-cache

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*
%{_libdir}/pkgconfig/*.pc

%changelog
*	Wed Dec 12 2018 Samuel Raynor <samuel@samuelraynor.com> 2.36.11-1
-	Initial build.