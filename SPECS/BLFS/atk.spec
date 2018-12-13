Name:           atk
Version:        2.26.1
Release:        1%{?dist}
Summary:        ATK provides the set of accessibility interfaces that are implemented by other toolkits and applications.
Vendor:			LeoWare
Distribution:	MyLFS

License:        LibGPLv2
URL:            https://developer.gnome.org/atk/
Source0:        http://ftp.gnome.org/pub/gnome/sources/atk/2.26/%{name}-%{version}.tar.xz

%description
ATK provides the set of accessibility interfaces that are implemented by other toolkits and applications. Using the ATK interfaces, accessibility tools have full access to view and control running applications.

%prep
%setup -q


%build
mkdir build &&
cd    build &&

%{__meson} --prefix=/usr &&
LANG=en_US.UTF-8 %{__ninja}

%check


%install
rm -rf $RPM_BUILD_ROOT
cd build
DESTDIR=$RPM_BUILD_ROOT %{__ninja} install
%{find_lang} atk10

%clean
rm -rf $RPM_BUILD_ROOT


%files -f build/atk10.lang
%{_lib64dir}/libatk-1.0.*
%{_lib64dir}/girepository-1.0/*
%{_datadir}/gir-1.0/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_lib64dir}/pkgconfig/*.pc

%changelog
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 2.26.1-1
-	Initial build.