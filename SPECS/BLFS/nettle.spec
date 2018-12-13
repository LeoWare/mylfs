Name:           nettle
Version:        3.4
Release:        1%{?dist}
Summary:        The Nettle package contains a low-level cryptographic library that is designed to fit easily in many contexts.

License:        TBD
URL:            https://www.lysator.liu.se/~nisse/nettle/
Source0:        https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz

%description
The Nettle package contains a low-level cryptographic library that is designed to fit easily in many contexts.

%prep
%setup -q


%build
%configure --disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

chmod   -v   755 $RPM_BUILD_ROOT%{_libdir}/lib{hogweed,nettle}.so
install -v -m755 -d $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
install -v -m644 nettle.html $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}

rm -f $RPM_BUILD_ROOT%{_infodir}/dir

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*
%doc %{_docdir}/%{name}-%{version}
%doc %{_infodir}/*.info*


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
*	Tue Dec 11 2018 Samuel Raynor <samuel@samuelraynor.com> 3.4-1
-	Initial build.