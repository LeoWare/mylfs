Name:           libffi
Version:        3.2.1
Release:        1%{?dist}
Summary:        The Libffi library provides a portable, high level programming interface to various calling conventions.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          System Environment/Libraries
License:        None
URL:            https://sourceware.org/libffi/
Source0:        ftp://sourceware.org/pub/libffi/%{name}-%{version}.tar.gz

%description
The Libffi library provides a portable, high level programming interface to various calling conventions. This allows a programmer to call any function specified by a call interface description at run time.

%prep
%setup -q
sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in
sed -e '/^includedir/ s/=.*$/=@includedir@/' \
	-e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in


%build
%configure --disable-static
make %{?_smp_mflags}

%check
make check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
rm $RPM_BUILD_ROOT%{_infodir}/dir
find $RPM_BUILD_ROOT -name \*.la -delete

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_libdir}/libffi.*
%doc %{_mandir}/*/*
%doc %{_infodir}/*

%package devel
Summary: Development headers for libffi

%description devel
Development headers for libffi

%files devel
%{_libdir}/pkgconfig/*.pc
%{_includedir}/*

%changelog
*	Wed Oct 10 2018 Samuel Raynor <samuel@samuelraynor.com> 3.2.1-1
-	Initial version.
