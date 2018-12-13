Name:           xcb-proto
Version:        1.12
Release:        1%{?dist}
Summary:       The xcb-proto package provides the XML-XCB protocol descriptions that libxcb uses to generate the majority of its code and API.

License:        TBD
URL:            https://xcb.freedesktop.org/
Source0:        https://xcb.freedesktop.org/dist/xcb-proto-1.12.tar.bz2
Patch0:         http://www.linuxfromscratch.org/patches/blfs/8.2/xcb-proto-1.12-python3-1.patch
Patch1:         http://www.linuxfromscratch.org/patches/blfs/8.2/xcb-proto-1.12-schema-1.patch

BuildRequires: xmlto, libxslt

%description
The xcb-proto package provides the XML-XCB protocol descriptions that libxcb uses to generate the majority of its code and API.

%prep
%setup -q
%patch -P 0 -p 1
%patch -P 1 -p 1

%build
export PYTHON=/usr/bin/python3 %configure --disable-static --with-python=/usr/bin/python3
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT 
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete


%clean
rm -rf $RPM_BUILD_ROOT


%files
/usr/lib/python3.6/site-packages/*
%{_datadir}/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel

%{_libdir}/pkgconfig/*.pc

%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.12-1
-	Initial build