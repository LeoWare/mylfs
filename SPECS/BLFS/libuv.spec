Name:           libuv
Version:        1.19.1
Release:        1%{?dist}
Summary:        The libuv package is a multi-platform support library with a focus on asynchronous I/O.

License:        TBD
URL:            https://github.com/libuv/libuv
Source0:        https://github.com/libuv/libuv/archive/v1.19.1/libuv-1.19.1.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
The libuv package is a multi-platform support library with a focus on asynchronous I/O.

%prep
%setup -q
sh autogen.sh

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
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 5.0.1-1
-	Initial build.