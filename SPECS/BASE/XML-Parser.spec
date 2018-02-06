Summary:	The XML::Parser module is a Perl interface to James Clark's XML parser, Expat. 
Name:		XML-Parser
Version:	2.44
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://cpan.metacpan.org/authors/id/T/TO/TODDR/%{name}-%{version}.tar.gz
%description
	The XML::Parser module is a Perl interface to James Clark's XML parser, Expat. 
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	perl Makefile.PL
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