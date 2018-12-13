Name:           xcb-util-wm
Version:        0.4.1
Release:        1%{?dist}
Summary:        The xcb-util-wm package contains libraries which provide client and window-manager helpers for EWMH and ICCCM.

License:        TBD
URL:            https://xcb.freedesktop.org/
Source0:        https://xcb.freedesktop.org/dist/%{name}-%{version}.tar.bz2

BuildRequires:  libxcb, libxcb-devel

%description
The xcb-util-wm package contains libraries which provide client and window-manager helpers for EWMH and ICCCM.


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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 0.4.1-1
-	Initial build.