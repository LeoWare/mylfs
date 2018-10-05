Summary:	Security client
Name:		nss
Version:	3.15.4
Release:	1
License:	MPLv2.0
URL:		http://ftp.mozilla.org/pub/mozilla.org/security/nss
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		%{name}-%{version}.tar.gz
Patch:		nss-3.15.4-standalone-1.patch
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
make VERBOSE=1 BUILD_OPT=1 \
	NSPR_INCLUDE_DIR=%{_includedir}/nspr \
	USE_SYSTEM_ZLIB=1 \
	ZLIB_LIBS=-lz \
	$([ $(uname -m) = x86_64 ] && echo USE_64=1) \
	$([ -f %{_includedir}/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)
%install
cd nss
cd ../dist
install -vdm 755 %{buildroot}%{_bindir}
install -vdm 755 %{buildroot}%{_includedir}/nss
install -vdm 755 %{buildroot}%{_libdir}
install -v -m755 Linux*/lib/*.so %{buildroot}%{_libdir}
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} %{buildroot}%{_libdir}
cp -v -RL {public,private}/nss/* %{buildroot}%{_includedir}/nss
chmod 644 %{buildroot}%{_includedir}/nss/*
install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} %{buildroot}%{_bindir}
install -vdm 755 %{buildroot}%{_libdir}/pkgconfig
install -vm 644 Linux*/lib/pkgconfig/nss.pc %{buildroot}%{_libdir}/pkgconfig
%post	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%changelog
*	Thu Apr 10 2014 baho-utot <baho-utot@columbus.rr.com> 3.15.4-1
*	Sun Aug 25 2013 baho-utot <baho-utot@columbus.rr.com> 3.15.1-1
-	Upgrade version
