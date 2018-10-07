#TARBALL:	http://www.cpan.org/src/5.0/perl-5.26.1.tar.xz
#MD5SUM:	70e988b4318739b0cf3ad5e120bfde88;SOURCES/perl-5.26.1.tar.xz
%define __requires_exclude perl\\((VMS|BSD::|Win32|Tk|Mac::|Your::Module::Here|unicore::Name|FCGI|Locale::Codes::.*(Code|Retired))
#-----------------------------------------------------------------------------
Summary:	The Perl package contains the Practical Extraction and Report Language.
Name:		perl
Version:	5.26.1
Release:	1
License:	GPLv1
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://www.cpan.org/src/5.0/%{name}-%{version}.tar.xz
Provides:	perl = 0:5.00405
Provides:	perl = 1:5
Provides:	perl = 1:5.0
Provides:	perl = 1:5.024
Provides:	perl = 1:5.6
Provides:	perl = 1:5.8.0
Provides:	perl = 0:5.003000
Provides:	perl = 0:5.00503
Provides:	perl = 0:5.006001
Provides:	perl = 0:5.006002
Provides:	perl = 0:5.007003
Provides:	perl = 0:5.008001
Provides:	perl = 0:5.009001
Provides:	perl = 0:5.009004
Provides:	perl = 0:5.009005
Provides:	perl = 1:5.010001
Provides:	perl = 1:5.010_000
Provides:	perl(subs)
Provides:	perl(locale)
%description
The Perl package contains the Practical Extraction and Report Language.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	export BUILD_ZLIB=False
	export BUILD_BZIP2=0
	sh Configure -des -Dprefix=/usr \
		-Dvendorprefix=/usr \
		-Dman1dir=%{_mandir}/man1 \
		-Dman3dir=%{_mandir}/man3 \
		-Dpager="${_sbindir}/less -isR" \
		-Duseshrplib \
		-Dusethreads
#		-Doptimize='-march=x86-64 -mtune=generic -O2 -pipe -fstack-protector-strong' \
#		-Dcccdlflags='-fPIC'
#		-Dlddlflags="-shared ${LDFLAGS}" -Dldflags="${LDFLAGS}"
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 Copying %{buildroot}/usr/share/licenses/%{name}/LICENSE
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
#	%{_bindir}/%{NAME}%{VERSION}
#	%%{_libdir}/%{NAME}5/%{VERSION}/*.pm
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 5.26.1-1
-	Initial build.	First version
