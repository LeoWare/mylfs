Name:           pcre
Version:        8.41
Release:        1%{?dist}
Summary:        The PCRE package contains Perl Compatible Regular Expression libraries.
Vendor:			LeoWare
Distribution:	MyLFS

License:        PCRE
URL:            https://www.pcre.org/
Source0:        https://downloads.sourceforge.net/pcre/pcre-8.41.tar.bz2

%description
The PCRE package contains Perl Compatible Regular Expression libraries. These are useful for implementing regular expression pattern matching using the same syntax and semantics as Perl 5.

%prep
%setup -q

%build
%configure --prefix=/usr                     \
            --docdir=%{_docdir}/%{name}-%{version} \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

mv -v $RPM_BUILD_ROOT/usr/lib/libpcre.so.* $RPM_BUILD_ROOT/lib &&
ln -sfv ../../lib/$(readlink $RPM_BUILD_ROOT/usr/lib/libpcre.so) $RPM_BUILD_ROOT/usr/lib/libpcre.so

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/libpcre*
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
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 8.41-1
-	Initial build.