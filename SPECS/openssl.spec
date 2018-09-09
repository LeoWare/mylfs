#-----------------------------------------------------------------------------
Summary:	The OpenSSL package contains management tools and libraries relating to cryptography	
Name:		openssl
Version:	1.1.0g
Release:	1
License:	GPL
URL:		https://openssl.org/source
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	https://openssl.org/source/%{name}-%{version}.tar.gz
BuildRequires:	libffi
%description
	The OpenSSL package contains management tools and libraries relating to cryptography.
	These are useful for providing cryptographic functions to other packages, such as OpenSSH,
	email applications and web browsers (for accessing HTTPS sites).
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{name}-%{version}
%build
	./config \
		--prefix=%{_prefix} \
		--openssldir=/etc/ssl \
		--libdir=lib \
		shared \
		zlib-dynamic \
		enable-md2
	make %{?_smp_mflags}
%install
	sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
	make DESTDIR=%{buildroot} MANSUFFIX=ssl install
	mv -v %{buildroot}/usr/share/doc/openssl{,-1.1.0g} &&
	cp -vfr doc/* %{buildroot}/usr/share/doc/openssl-1.1.0g
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm	
#-----------------------------------------------------------------------------
%files -f filelist.rpm
   %defattr(-,root,root)
   	%{_mandir}/man1/*.gz
	%{_mandir}/man3/*.gz
	%{_mandir}/man5/*.gz
	%{_mandir}/man7/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.1.0f-1
*	Fri Jul 17 2018 baho-utot <baho-utot@columbus.rr.com> 1.1.0g-1
-	LFS-8.1
