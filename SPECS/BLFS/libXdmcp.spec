Name:           libXdmcp
Version:        1.1.2
Release:        1%{?dist}
Summary:        The libXdmcp package contains a library implementing the X Display Manager Control Protocol. This is useful for allowing clients to interact with the X Display Manager.

License:        None
URL:            https://www.x.org/
Source0:        https://www.x.org/pub/individual/lib/libXdmcp-1.1.2.tar.bz2

%description
The libXdmcp package contains a library implementing the X Display Manager Control Protocol. This is useful for allowing clients to interact with the X Display Manager.

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
#% doc % {_mandir}/*/*
%doc %{_docdir}/%{name}

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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.2-1
-	Initial build