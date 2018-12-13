Name:           pixman
Version:        0.34.0
Release:        1%{?dist}
Summary:        The Pixman package contains a library that provides low-level pixel manipulation features such as image compositing and trapezoid rasterization.

License:        TBD
URL:            https://www.cairographics.org/
Source0:        https://www.cairographics.org/releases/pixman-0.34.0.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  gtk+, libpng

%description
The Pixman package contains a library that provides low-level pixel manipulation features such as image compositing and trapezoid rasterization.

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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 0.34.0-1
-	Initial build.