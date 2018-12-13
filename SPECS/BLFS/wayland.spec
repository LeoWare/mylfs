Name:           wayland
Version:        1.14.0
Release:        1%{?dist}
Summary:        Wayland is a project to define a protocol for a compositor to talk to its clients as well as a library implementation of the protocol.

License:        TBD
URL:            https://wayland.freedesktop.org/
Source0:        https://wayland.freedesktop.org/releases/wayland-1.14.0.tar.xz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  libxml2, libxml2-devel

%description
Wayland is a project to define a protocol for a compositor to talk to its clients as well as a library implementation of the protocol.

%prep
%setup -q


%build
%configure --disable-static --disable-documentation
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*.so*
%{_datadir}/%{name}/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*
%{_libdir}/pkgconfig/*.pc


%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.14.0-1
-	Initial build.