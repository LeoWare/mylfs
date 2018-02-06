Summary:	The Perl package contains the Practical Extraction and Report Language.
Name:		perl
Version:	5.26.0
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://www.cpan.org/src/5.0/%{name}-%{version}.tar.xz
%description
	The Perl package contains the Practical Extraction and Report Language.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	export BUILD_ZLIB=False
	export BUILD_BZIP2=0
	sh Configure -des -Dprefix=/usr \
		-Dvendorprefix=/usr \
		-Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 \
		-Dpager="/usr/bin/less -isR" \
		-Duseshrplib \
		-Dusethreads
#		-Doptimize='-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong' \
#		-Dcccdlflags='-fPIC' 
#		-Dlddlflags="-shared ${LDFLAGS}" -Dldflags="${LDFLAGS}"
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version