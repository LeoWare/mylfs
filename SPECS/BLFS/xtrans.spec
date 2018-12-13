Name:           xtrans
Version:        1.3.5
Release:        1%{?dist}
Summary:        The Xorg libraries provide library routines that are used within all X Window applications.

License:        TBD
URL:            https://www.x.org/
Source0:        https://www.x.org/pub/individual/lib/xtrans-1.3.5.tar.bz2

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
#% {_libdir}/% {name}.*
#% doc % {_mandir}/*/*
%doc %{_docdir}/%{name}


%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/X11/*
%{_datadir}/aclocal/*.m4
%{_datadir}/pkgconfig/*.pc

%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.3.5-1
-	Initial build