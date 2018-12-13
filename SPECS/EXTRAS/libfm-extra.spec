Name:           libfm-extra
Version:        1.2.5
Release:        1%{?dist}
Summary:        The libfm-extra package contains a library and other files required by menu-cache-gen libexec of menu-cache.

License:        TBD
URL:            https://wiki.lxde.org/en/Libfm
Source0:        https://downloads.sourceforge.net/pcmanfm/libfm-1.2.5.tar.xz

%description
The libfm-extra package contains a library and other files required by menu-cache-gen libexec of menu-cache.

%prep
%setup -q -n libfm-%{version}


%build
%configure --with-extra-only --with-gtk=no --disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/%{name}.*

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
*	Thu Dec 06 2018 Samuel Raynor <samuel@samuelraynor.com> 1.2.5-1
-	Initial build.