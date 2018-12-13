Name:           menu-cache
Version:        1.1.0
Release:        1%{?dist}
Summary:        The Menu Cache package contains a library for creating and utilizing caches to speed up the manipulation for freedesktop.org defined application menus.

License:        TBD
URL:            https://github.com/lxde/menu-cache
Source0:        https://downloads.sourceforge.net/lxde/menu-cache-1.1.0.tar.xz

%description
The Menu Cache package contains a library for creating and utilizing caches to speed up the manipulation for freedesktop.org defined application menus.

%prep
%setup -q


%build
%configure --disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/*
%{_libexecdir}/*


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
*	Thu Dec 06 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.0-1
-	Initial build.