Summary:	The OpenSSL package contains management tools and libraries relating to cryptography	
Name:		openssl
Version:	1.1.0f
Release:	1
License:	GPL
URL:		https://openssl.org/source
Group:		BLFS/Security
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	https://openssl.org/source/%{name}-%{version}.tar.gz
%description
	The OpenSSL package contains management tools and libraries relating to cryptography.
	These are useful for providing cryptographic functions to other packages, such as OpenSSH,
	email applications and web browsers (for accessing HTTPS sites).
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
	make DESTDIR=%{buildroot} MANSUFFIX=ssl install
	mv -v %{buildroot}/usr/share/doc/openssl{,-1.1.0f} &&
	cp -vfr doc/* %{buildroot}/usr/share/doc/openssl-1.1.0f
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,root,root)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.1.0f-1
-	LFS-8.1