Name:           fribidi
Version:        1.0.1
Release:        1%{?dist}
Summary:        The FriBidi package is an implementation of the Unicode Bidirectional Algorithm (BIDI).
Vendor:			LeoWare
Distribution:	MyLFS

License:        LGPLv2.1
URL:            https://github.com/fribidi/fribidi/
Source0:        https://github.com/fribidi/fribidi/releases/download/v%{version}/fribidi-%{version}.tar.bz2

%description
The FriBidi package is an implementation of the Unicode Bidirectional Algorithm (BIDI). This is useful for supporting Arabic and Hebrew alphabets in other packages.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/fribidi
%{_libdir}/libfribidi.*
%doc %{_mandir}/*/*


%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc


%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%changelog
*	Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 1.0.1-1
-	Initial build.