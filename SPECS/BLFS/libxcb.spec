Name:           libxcb
Version:        1.12
Release:        1%{?dist}
Summary:        The libxcb package provides an interface to the X Window System protocol, which replaces the current Xlib interface.

License:        TBD
URL:            https://xcb.freedesktop.org/
Source0:        https://xcb.freedesktop.org/dist/libxcb-1.12.tar.bz2
Patch0:         http://www.linuxfromscratch.org/patches/blfs/8.2/libxcb-1.12-python3-1.patch

BuildRequires:  libXau, xcb-proto, libXdmcp

%description
The libxcb package provides an interface to the X Window System protocol, which replaces the current Xlib interface. Xlib can also use XCB as a transport layer, allowing software to make requests and receive responses with both.

%prep
%setup -q
%patch -P 0 -p 1
sed -i "s/pthread-stubs//" configure

%build
export PYTHON=/usr/bin/python3 %configure \
	--enable-xinput \
	--without-doxygen \
	--docdir=%{_docdir}/%{name}-%{version} \
	--disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT 
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/%{name}*.*
%doc %{_mandir}/*/*
%doc %{_docdir}/%{name}-%{version}

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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.12-1
-	Initial build