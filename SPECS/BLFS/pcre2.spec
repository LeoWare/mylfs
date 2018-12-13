Name:           pcre2
Version:        10.31
Release:        1%{?dist}
Summary:        The PCRE2 package contains a new generation of the Perl Compatible Regular Expression libraries.
Vendor:			LeoWare
Distribution:	MyLFS

License:        PCRE
URL:            https://www.pcre.org/
Source0:        https://downloads.sourceforge.net/pcre/pcre2-10.31.tar.bz2

%description
The PCRE2 package contains a new generation of the Perl Compatible Regular Expression libraries. These are useful for implementing regular expression pattern matching using the same syntax and semantics as Perl.

%prep
%setup -q

%build
%configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.31 \
            --enable-unicode                    \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/libpcre2*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%changelog
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 10.31-1
-	Initial build.