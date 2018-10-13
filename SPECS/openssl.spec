Name:           openssl
Version:        1.1.0g
Release:        1%{?dist}
Summary:        The OpenSSL package contains management tools and libraries relating to cryptography.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          System Environment/Libraries
License:        OpenSSL
URL:            https://www.openssl.org/
Source0:        https://openssl.org/source/%{name}-%{version}.tar.gz

%description
The OpenSSL package contains management tools and libraries relating to cryptography. These are useful for providing cryptographic functions to other packages, such as OpenSSH, email applications and web browsers (for accessing HTTPS sites).

%prep
%setup -q


%build
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make %{?_smp_mflags}

%check
make test

%install
rm -rf $RPM_BUILD_ROOT
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install DESTDIR=$RPM_BUILD_ROOT
mv -v $RPM_BUILD_ROOT/usr/share/doc/openssl $RPM_BUILD_ROOT/usr/share/doc/openssl-1.1.0g
cp -vfr doc/* $RPM_BUILD_ROOT/usr/share/doc/openssl-1.1.0g
find $RPM_BUILD_ROOT -name \*.la -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_sysconfdir}/ssl/misc/*
%config(noreplace) %{_sysconfdir}/ssl/openssl.cnf
%{_sysconfdir}/ssl/openssl.cnf.dist
%doc %{_docdir}/*
%doc %{_mandir}/*/*
%{_libdir}/libssl.*
%{_libdir}/libcrypto.*
%{_libdir}/engines-1.1/*
%{_bindir}/c_rehash
%{_bindir}/openssl

%package devel
Summary: Development headers for libssl and libcrypto

%description devel
Development headers for libssl and libcrypto

%files devel
%{_libdir}/pkgconfig/*.pc
%{_includedir}/openssl/*


%changelog
*	Wed Oct 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.0g-1
-	Initial build.
