Name:           fvwm
Version:        2.6.8
Release:        1%{?dist}
Summary:        This is the F(?) Virtual Window Manager (FVWM).
Vendor:			LeoWare
Distribution:	MyLFS

License:        TBD
URL:            http://fvwm.org/
Source0:        https://github.com/fvwmorg/fvwm/releases/download/2.6.8/fvwm-2.6.8.tar.gz

%description
FVWM is an extremely powerful ICCCM-compliant multiple virtual desktop window manager for the X Window system. Support is excellent. Check it out!

%prep
%setup -q


%build
%configure --enable-gtk-doc
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/libatspi.*
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
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 2.6.8-1
-	Initial build.