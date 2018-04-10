Summary:	The Perl package contains the Practical Extraction and Report Language.
Name:		tools-perl
Version:	5.26.1
Release:	1
License:	GPL
URL:		http://www.cpan.org/src/5.0
Group:		LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-patch
Source0:	http://www.cpan.org/src/5.0/perl-%{version}.tar.xz
%description
	The Perl package contains the Practical Extraction and Report Language.
%prep
%setup -q -n perl-%{version}
%build
	sh Configure -des -Dprefix=%{_prefix} -Dlibs=-lm
	make %{?_smp_mflags}
%install
	install -vdm 755 %{buildroot}%{_bindir}
	cp -v perl cpan/podlators/scripts/pod2man %{buildroot}%{_bindir}
	install -vdm 755 %{buildroot}%{_libdir}/perl5/%{version}
	cp -Rv lib/* %{buildroot}%{_libdir}/perl5/%{version}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 5.26.1-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 5.26.0-1
-	LFS-8.1
