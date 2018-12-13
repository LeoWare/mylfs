Name:           libass
Version:        0.14.0
Release:        1%{?dist}
Summary:        libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format that allows for more advanced subtitles than the conventional SRT and similar formats.
Vendor:			LeoWare
Distribution:	MyLFS

License:        ISC
URL:            https://github.com/libass/libass
Source0:        https://github.com/libass/libass/releases/download/0.14.0/libass-0.14.0.tar.xz

%description
libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format that allows for more advanced subtitles than the conventional SRT and similar formats.

%prep
%setup -q


%build
%configure --disable-static
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/libass.*


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
*	Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 0.14.0-1
-	Initial build.