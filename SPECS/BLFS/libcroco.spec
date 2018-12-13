Name:           libcroco
Version:        0.6.12
Release:        1%{?dist}
Summary:        The libcroco package contains a standalone CSS2 parsing and manipulation library.
Vendor:			LeoWare
Distribution:	MyLFS

License:        Unknown
URL:            https://github.com/GNOME/libcroco
Source0:        http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.12.tar.xz

%description
The libcroco package contains a standalone CSS2 parsing and manipulation library.

%prep
%setup -q


%build
%configure --disable-static
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/libcroco-*
%doc %{_datadir}/gtk-doc/html/*


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
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 0.6.12-1
-	Initial build.