Name:           libelf
Version:        0.170
Release:        1%{?dist}
Summary:        Libelf is a library for handling ELF (Executable and Linkable Format) files.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          System Environment/Libraries
License:        GPLv3
URL:            https://sourceware.org/elfutils/
Source0:        https://sourceware.org/ftp/elfutils/0.170/elfutils-0.170.tar.bz2

%description
Libelf is a library for handling ELF (Executable and Linkable Format) files.

%prep
%setup -q -n elfutils-%{version}


%build
%configure
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make -C libelf install DESTDIR=$RPM_BUILD_ROOT
install -vdm 755 $RPM_BUILD_ROOT%{_libdir}/pkgconfig
install -vm644 config/libelf.pc $RPM_BUILD_ROOT%{_libdir}/pkgconfig/libelf.pc

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_libdir}/lib*
%{_libdir}/pkgconfig/*.pc

%package devel
Summary: libelf development headers

%description devel
libelf development headers

%files devel
%{_includedir}/*.h
%{_includedir}/elfutils/*.h
%changelog
*	Wed Oct 10 2018 Samuel Raynor <samuel@samuelraynor.com> 0.170-1
-	Initial build.
