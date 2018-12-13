Name:           libgcrypt
Version:        1.8.2
Release:        1%{?dist}
Summary:        The libgcrypt package contains a general purpose crypto library based on the code used in GnuPG.

License:        GPLv2
URL:            http://www.gnupg.org/
Source0:        https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.2.tar.bz2

%description
The libgcrypt package contains a general purpose crypto library based on the code used in GnuPG. The library provides a high level interface to cryptographic building blocks using an extendable and flexible API.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}
make -C doc html
makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi
makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -v -dm755   $RPM_BUILD_ROOT/usr/share/doc/libgcrypt-1.8.2
install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                    $RPM_BUILD_ROOT/usr/share/doc/libgcrypt-1.8.2
install -v -dm755   $RPM_BUILD_ROOT/usr/share/doc/libgcrypt-1.8.2/html
install -v -m644 doc/gcrypt.html/* \
                    $RPM_BUILD_ROOT/usr/share/doc/libgcrypt-1.8.2/html
install -v -m644 doc/gcrypt_nochunks.html \
                    $RPM_BUILD_ROOT/usr/share/doc/libgcrypt-1.8.2
#install -v -m644 doc/gcrypt.{pdf,ps,dvi,txt,texi} \
#                    $RPM_BUILD_ROOT/usr/share/doc/libgcrypt-1.8.2
install -v -m644 doc/gcrypt.txt \
                    $RPM_BUILD_ROOT/usr/share/doc/libgcrypt-1.8.2

rm -vf $RPM_BUILD_ROOT%{_infodir}/dir


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_infodir}/*.info*
%doc %{_mandir}/*/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*




%changelog
*	Mon Dec 03 2018 Samuel Raynor <samuel@samuelraynor.com> 1.8.2-1
-	Initial build.