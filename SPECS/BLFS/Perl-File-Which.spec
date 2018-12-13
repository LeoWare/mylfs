Name:           Perl-File-Which
Version:        1.22
Release:        1%{?dist}
Summary:        File::Which provides a portable implementation of the 'which' utility.
Vendor:			LeoWare
Distribution:	MyLFS

License:        Unknown
URL:            https://www.cpan.org
Source0:        https://www.cpan.org/authors/id/P/PL/PLICEASE/File-Which-1.22.tar.gz

%description
File::Which provides a portable implementation of the 'which' utility.

%prep 
%setup -q -n File-Which-%{version}


%build
perl Makefile.PL
make %{?_smp_mflags}

%check
make test

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
rm -vf $RPM_BUILD_ROOT%{_libdir}/perl5/*/*/perllocal.pod

%clean
rm -rf $RPM_BUILD_ROOT


%files

%{_libdir}/perl5/*/*
%{_mandir}/*/*


%changelog
*	Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 1.22-1
-	Initial build.