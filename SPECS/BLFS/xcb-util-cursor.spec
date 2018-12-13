Name:           xcb-util-cursor
Version:        0.1.3
Release:        1%{?dist}
Summary:        The xcb-util-cursor package provides a module that implements the XCB cursor library. It is a the XCB replacement for libXcursor.

License:        TBD
URL:            https://xcb.freedesktop.org/
Source0:        https://xcb.freedesktop.org/dist/%{name}-%{version}.tar.bz2

BuildRequires:  xcb-util, xcb-util-devel

%description
The xcb-util-cursor package provides a module that implements the XCB cursor library. It is a the XCB replacement for libXcursor.


%prep
%setup -q


%build
%configure --disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/*.so*


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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 0.1.3-1
-	Initial build.