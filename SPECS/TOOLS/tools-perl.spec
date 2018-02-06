Summary:	The Perl package contains the Practical Extraction and Report Language. 	
Name:		tools-perl
Version:	5.26.0
Release:	1
License:	GPL
URL:		http://www.cpan.org/src/5.0
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://www.cpan.org/src/5.0/perl-%{version}.tar.xz
%description
	The Perl package contains the Practical Extraction and Report Language. 
%prep
%setup -q -n perl-%{version}
%build
	sed -e '9751 a#ifndef PERL_IN_XSUB_RE' \
	    -e '9808 a#endif'                  \
	    -i regexec.c
	sh Configure -des -Dprefix=%{_prefix} -Dlibs=-lm 
	make %{?_smp_mflags}
%install
	install -vdm 755 %{buildroot}/tools/bin
	cp -v perl cpan/podlators/scripts/pod2man %{buildroot}/tools/bin
	install -vdm 755 %{buildroot}/tools/lib/perl5/5.26.0
	cp -Rv lib/* %{buildroot}/tools/lib/perl5/5.26.0
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 5.26.0-1
-	LFS-8.1