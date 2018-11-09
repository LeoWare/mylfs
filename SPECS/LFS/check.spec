Name:           check
Version:        0.12.0
Release:        1%{?dist}
Summary:        Check is a unit testing framework for C.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Development/Tools
License:        Lesser GPLv2.1
URL:            https://libcheck.github.io/check
Source0:        https://github.com/libcheck/check/releases/download/0.12.0/check-0.12.0.tar.gz

%description
Check is a unit testing framework for C.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%check
make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -name \*.la -delete
rm -v $RPM_BUILD_ROOT%{_infodir}/dir
mv -v $RPM_BUILD_ROOT%{_docdir}/%{name} $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}

%clean
rm -rf $RPM_BUILD_ROOT

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%{_bindir}/*
%{_libdir}/*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_infodir}/*
%doc %{_mandir}/*/*
%license %{_docdir}/%{name}-%{version}/COPYING.LESSER

%package devel
Summary: Development files for check.

%description devel
Development files for check.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*
%{_datadir}/aclocal/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 0.12.0-1
-	Initial build.
