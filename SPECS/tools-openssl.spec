Summary:	The OpenSSL package contains management tools and libraries relating to cryptography
Name:		tools-openssl
Version:	1.1.0g
Release:	1
License:	GPL
URL:		https://openssl.org/source
Group:		LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-libelf
Source0:	https://openssl.org/source/openssl-%{version}.tar.gz
%description
	The OpenSSL package contains management tools and libraries relating to cryptography.
	These are useful for providing cryptographic functions to other packages, such as OpenSSH,
	email applications and web browsers (for accessing HTTPS sites).
%prep
%setup -q -n openssl-%{version}
%build
	./config \
		--prefix=%{_prefix} \
		--openssldir=/tools/etc/ssl \
		no-shared \
		no-zlib \
		enable-md2
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}%{_docdir}
	rm -rf %{buildroot}%{_mandir}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.1.0f-1
-	LFS-8.1
