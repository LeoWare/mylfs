Name:           libXext
Version:        1.3.3
Release:        1%{?dist}
Summary:        The Xorg libraries provide library routines that are used within all X Window applications.

License:        TBD
URL:            https://www.x.org/
Source0:        https://www.x.org/pub/individual/lib/%{name}-%{version}.tar.bz2

BuildRequires:  fontconfig, fontconfig-devel libxcb, libxcb-devel

%description
The Xorg libraries provide library routines that are used within all X Window applications.

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
#% doc % {_mandir}/*/*
%doc %{_docdir}/%{name}



%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/X11/*
#% {_datadir}/aclocal/*.m4
%{_libdir}/pkgconfig/*.pc
%{_mandir}/man3/*

%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.3.3-1
-	Initial build