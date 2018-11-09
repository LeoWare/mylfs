Name:			libarchive
Version:		3.3.2
Release:		1
Vendor:			LeoWare
Distribution:	MyLFS

Summary:		The libarchive library provides a single interface for reading/writing various compression formats.
License:		TBD
URL:			http://www.libarchive.org/
Source0:		http://www.libarchive.org/downloads/libarchive-3.3.2.tar.gz

%description
The libarchive library provides a single interface for reading/writing various compression formats.

%prep
%setup -q

%build
%configure --disable-static --without-nettle
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
find $RPM_BUILD_ROOT -name \*.la -delete

%files
%{_bindir}/*
%doc %{_mandir}/*/*
%{_libdir}/*.so*

%package devel
Summary: Development files for %{name}

%description devel
Development files for %{name}

%files devel
%{_includedir}
%{_libdir}/pkgconfig/*.pc

%changelog
*	Fri Oct 19 2018 Samuel Raynor <samuel@samuelraynor.com> 3.3.2-1
-	Initial build.
