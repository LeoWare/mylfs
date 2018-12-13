Name:           curl
Version:        7.58.0
Release:        1%{?dist}
Summary:        The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: FTP, FTPS, HTTP, HTTPS, SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS and FILE.

License:        TBD
URL:            https://curl.haxx.se/
Source0:        https://curl.haxx.se/download/curl-7.58.0.tar.xz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: FTP, FTPS, HTTP, HTTPS, SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS and FILE. Its ability to both download and upload files can be incorporated into other programs to support functions like streaming media.

%prep
%setup -q


%build
%configure	--disable-static \
			--enable-threaded-resolver \
			--with-ca-path=/etc/ssl/certs
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

rm -rf docs/examples/.deps

find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \;

install -v -d -m755 $RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}
cp -v -R docs/*     $RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}


find $RPM_BUILD_ROOT -name "*.la" -delete


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*.so*
%doc %{_mandir}/man1/*
%doc %{_docdir}/%{name}-%{version}


%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*
%{_libdir}/pkgconfig/*.pc
%{_mandir}/man3/*


%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 7.58.0-1
-	Initial build.