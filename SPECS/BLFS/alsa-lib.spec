Name:           alsa-lib
Version:        1.1.5
Release:        1%{?dist}
Summary:        The ALSA Library package contains the ALSA library used by programs (including ALSA Utilities) requiring access to the ALSA sound interface.
Vendor:			LeoWare
Distribution:	MyLFS

License:        GPLv2.1
URL:            http://alsa-project.org
Source0:        ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.5.tar.bz2

%description
The ALSA Library package contains the ALSA library used by programs (including ALSA Utilities) requiring access to the ALSA sound interface.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}
#make %{?_smp_mflags} doc

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
#install -v -d -m755 $RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}/html/search
#install -v -m644 doc/doxygen/html/*.* $RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}/html
#install -v -m644 doc/doxygen/html/search/* $RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}/html/search

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/aserver
%{_libdir}/libasound.*
%{_libdir}/%{name}/*
%{_datadir}/alsa/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}
%{_libdir}/pkgconfig/*
%{_datadir}/aclocal/*

%changelog
* Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.5-1
- Initial build