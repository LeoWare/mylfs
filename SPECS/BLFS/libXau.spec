Name:           libXau
Version:        1.0.8
Release:        1%{?dist}
Summary:        The libXau package contains a library implementing the X11 Authorization Protocol. This is useful for restricting client access to the display.

License:        None
URL:            https://www.x.org/
Source0:        https://www.x.org/pub/individual/lib/libXau-1.0.8.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
The libXau package contains a library implementing the X11 Authorization Protocol. This is useful for restricting client access to the display.

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
%{_libdir}/%{name}.*
%doc %{_mandir}/*/*

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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.0.8-1
-	Initial build