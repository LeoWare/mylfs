Summary:	Security client
Name:		nss
Version:	3.35
Release:	1
License:	MPLv2.0
URL:		http://ftp.mozilla.org/pub/mozilla.org/security/nss
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		%{name}-%{version}.tar.gz
Patch:		nss-3.35-standalone-1.patch

%description
 The Network Security Services (NSS) package is a set of libraries
 designed to support cross-platform development of security-enabled
 client and server applications. Applications built with NSS can
 support SSL v2 and v3, TLS, PKCS #5, PKCS #7, PKCS #11, PKCS #12,
 S/MIME, X.509 v3 certificates, and other security standards.
 This is useful for implementing SSL and S/MIME or other Internet
 security standards into an application.

%prep
%setup -q
%patch -p1

%build

cd nss
make -j1 VERBOSE=1 BUILD_OPT=1 \
	NSPR_INCLUDE_DIR=/usr/include/nspr  \
	USE_SYSTEM_ZLIB=1                   \
	ZLIB_LIBS=-lz                       \
	NSS_ENABLE_WERROR=0                 \
	$([ $(uname -m) = x86_64 ] && echo USE_64=1) \
	$([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)

%install
cd dist
install -vdm 755 $RPM_BUILD_ROOT%{_bindir}
install -vdm 755 $RPM_BUILD_ROOT%{_libdir}/pkgconfig
install -vdm 755 $RPM_BUILD_ROOT%{_includedir}/%{name}
install -v -m755 Linux*/lib/*.so              $RPM_BUILD_ROOT/usr/lib/
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} $RPM_BUILD_ROOT/usr/lib/

#install -v -m755 -d                           $RPM_BUILD_ROOT/usr/include/nss
cp -v -RL {public,private}/nss/*              $RPM_BUILD_ROOT/usr/include/nss
chmod -v 644                                  $RPM_BUILD_ROOT/usr/include/nss/*

install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} $RPM_BUILD_ROOT/usr/bin/

install -v -m644 Linux*/lib/pkgconfig/nss.pc  $RPM_BUILD_ROOT/usr/lib/pkgconfig

%post	-p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%defattr(-,root,root)
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*

%package devel
Summary: Development files for %{name}

%description devel
Development files for %{name}

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*

%changelog
*	Fri Oct 19 2018 Samuel Raynor <samuel@samuelraynor.com> 3.35-1
-	Initial build.
